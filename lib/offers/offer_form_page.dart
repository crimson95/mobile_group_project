import 'package:flutter/material.dart';
import 'offer.dart';
import 'offer_dao.dart';
import 'shared_prefs_service.dart';
import '../../AppLocalizations.dart';
/// Screen for creating a new purchase offer or editing an existing one.
///
/// If [offer] is null, the page behaves in "create" mode.
/// If [offer] is not null, the form is pre-filled and the user can
/// update or delete that existing record.
class OfferFormPage extends StatefulWidget {
  final Offer? offer; // null = new offer

  const OfferFormPage({Key? key, this.offer}) : super(key: key);

  @override
  State<OfferFormPage> createState() => _OfferFormPageState();
}

class _OfferFormPageState extends State<OfferFormPage> {
  // Global key that lets us validate the form and check if
  /// the user filled all mandatory fields.
  final _formKey = GlobalKey<FormState>();
  /// Controllers to read and update text field values.
  final _customerIdCtrl = TextEditingController();
  final _itemIdCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  bool _accepted = false;
  /// A small helper that tells us whether this is an edit or a new record.
  bool get _isEdit => widget.offer != null;

  @override
  void initState() {
    super.initState();
    // If an existing offer is passed in, we are in edit mode
    // and we should populate all fields with its values.
    if (_isEdit) {
      final o = widget.offer!;
      _customerIdCtrl.text = o.customerId;
      _itemIdCtrl.text = o.itemId;
      _priceCtrl.text = o.price.toStringAsFixed(2);
      _dateCtrl.text = o.date;
      _accepted = o.accepted;
    } else {
      // For a brand-new offer, we try to load the last offer from
      // encrypted storage and ask the user if they want to copy it.
      _loadLastOffer(); // copy-previous feature
    }
  }
  /// Tries to restore the last created offer from secure storage.
  ///
  /// If data exists, the user is asked whether they want to
  /// copy those values or start from a clean slate.
  Future<void> _loadLastOffer() async {
    final last = await SharedPrefsService.loadLastOffer();
    if (last == null) return;
    final loc = AppLocalizations.of(context)!;
    final copy = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.translate('copyprev_title')!),
        content: Text(loc.translate('copyprev_msg')!
          ,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.translate('blank')!),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.translate('copy')!),
          ),
        ],
      ),
    );

    if (copy == true) {
      _customerIdCtrl.text = last.customerId;
      _itemIdCtrl.text = last.itemId;
      _priceCtrl.text = last.price.toStringAsFixed(2);
      _dateCtrl.text = last.date;
      _accepted = last.accepted;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _customerIdCtrl.dispose();
    _itemIdCtrl.dispose();
    _priceCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }
  /// Opens the date picker and formats the selected date as yyyy-MM-dd.
  ///
  /// This keeps the date format consistent between what the user sees
  /// and what we store in the database.
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDate: now,
    );
    if (picked != null) {
      _dateCtrl.text =
      '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() {});
    }
  }
  /// Validates the form and then either inserts a new offer
  /// or updates an existing one in the database.
  ///
  /// On success, a Snackbar is shown and the page pops back to
  /// the list screen after a short delay so the user still
  /// has time to read the message.
  Future<void> _save() async {
    // If any validator returns an error string, stop here.
    if (!_formKey.currentState!.validate()) return;

    final price = double.parse(_priceCtrl.text.trim());
    final loc = AppLocalizations.of(context)!;
    final offer = Offer(
      id: widget.offer?.id,
      customerId: _customerIdCtrl.text.trim(),
      itemId: _itemIdCtrl.text.trim(),
      price: price,
      date: _dateCtrl.text.trim(),
      accepted: _accepted,
    );

    if (_isEdit) {
      // Update existing row in the database
      await OfferDao.instance.updateOffer(offer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.translate('offer_updated')!)),
      );
    } else {
      // Insert new row and save it as the "last offer" for the copy feature.
      final id = await OfferDao.instance.insertOffer(offer);
      await SharedPrefsService.saveLastOffer(offer.copyWith(id: id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.translate('offer_added')!)),
      );
    }

    // wait so Snackbar is visible before leaving
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      Navigator.pop(context);
    }
  }
  /// Asks the user to confirm, then removes the current offer from the database.
  /// This is only available in edit mode. After deletion, a Snackbar
  /// confirms the action and the screen closes.
  Future<void> _delete() async {
    final loc = AppLocalizations.of(context)!;
    if (!_isEdit) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.translate('delete_offer')!),
        content: Text(loc.translate('delete_offer_msg')!),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.translate('cancel')!),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.translate('delete')!),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await OfferDao.instance.deleteOffer(widget.offer!.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.translate('offer_deleted')!)),
      );
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
  /// Displays an instructional dialog explaining how to use this form.
  ///
  /// This satisfies the requirement that each activity must have
  /// an ActionBar item that shows usage instructions.
  void _showInstructions() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.translate('form_help_title')!),
        content: Text(
          loc.translate('form_help_body')!
        ),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      // The AppBar title changes depending on whether we are adding or editing.
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Offer' : loc.translate('new_offer')!),
        // Info icon >> shows instructions dialog.
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInstructions,
          ),
          // Delete icon only appears in edit mode.
          if (_isEdit)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _delete,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Customer ID field
              TextFormField(
                controller: _customerIdCtrl,
                decoration: InputDecoration(labelText: loc.translate('customer_id')!),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              // Boat/Car ID field
              TextFormField(
                controller: _itemIdCtrl,
                decoration:
                InputDecoration(labelText: loc.translate('item_id')!),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              TextFormField(
                // Price field (numeric only)
                controller: _priceCtrl,
                decoration:
                InputDecoration(labelText: loc.translate('price_offered')!),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  return double.tryParse(v.trim()) == null
                      ? 'Enter a number'
                      : null;
                },
              ),
              TextFormField(
                // Date picker field (read-only, opened by suffix icon)
                controller: _dateCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: loc.translate('date_of_offer')!,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined),
                    onPressed: _pickDate,
                  ),
                ),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              // Accepted switch row
              Row(
                children: [
                  Text(loc.translate('accepted')!),
                  const SizedBox(width: 8),
                  Switch(
                    value: _accepted,
                    onChanged: (val) => setState(() => _accepted = val),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Primary action button > save or update
              ElevatedButton(
                onPressed: _save,
                child: Text(_isEdit ? loc.translate('update_offer')! : loc.translate('save_offer')!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
