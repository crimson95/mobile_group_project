import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'offer_database.dart';
import 'offer_dao.dart';
import 'offer.dart';
import '../../AppLocalizations.dart';

/// Form page used for both creating and editing an offer.
class OfferFormPage extends StatefulWidget {
  final OfferDatabase database;

  /// Existing offer if editing, or null if creating a new one.
  final Offer? existingOffer;

  const OfferFormPage({
    super.key,
    required this.database,
    this.existingOffer,
  });

  @override
  State<OfferFormPage> createState() => _OfferFormPageState();
}

class _OfferFormPageState extends State<OfferFormPage> {
  late OfferDAO _offerDAO;

  late TextEditingController _customerIdController;
  late TextEditingController _itemIdController;
  late TextEditingController _priceController;
  late TextEditingController _dateController;
  bool _accepted = false;

  bool get isEditing => widget.existingOffer != null;

  @override
  void initState() {
    super.initState();
    _offerDAO = widget.database.offerDAO;

    _customerIdController = TextEditingController();
    _itemIdController = TextEditingController();
    _priceController = TextEditingController();
    _dateController = TextEditingController();

    if (isEditing) {
      final o = widget.existingOffer!;
      _customerIdController.text = o.customerId.toString();
      _itemIdController.text = o.itemId.toString();
      _priceController.text = o.priceOffered.toStringAsFixed(2);
      _dateController.text = o.dateOfOffer;
      _accepted = o.accepted;
    } else {
      _loadLastInput(); // optional: load from encrypted shared prefs
    }
  }

  @override
  void dispose() {
    _customerIdController.dispose();
    _itemIdController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _loadLastInput() async {
    final prefs = EncryptedSharedPreferences();
    _customerIdController.text =
        await prefs.getString('offer_customerId') ?? '';
    _itemIdController.text =
        await prefs.getString('offer_itemId') ?? '';
    _priceController.text =
        await prefs.getString('offer_price') ?? '';
    _dateController.text =
        await prefs.getString('offer_date') ?? '';
    final acceptedStr =
        await prefs.getString('offer_accepted') ?? '0';
    _accepted = acceptedStr == '1';

    setState(() {});
  }

  Future<void> _saveLastInput() async {
    final prefs = EncryptedSharedPreferences();
    await prefs.setString('offer_customerId', _customerIdController.text);
    await prefs.setString('offer_itemId', _itemIdController.text);
    await prefs.setString('offer_price', _priceController.text);
    await prefs.setString('offer_date', _dateController.text);
    await prefs.setString('offer_accepted', _accepted ? '1' : '0');
  }

  bool _validateForm(AppLocalizations loc) {
    if (_customerIdController.text.trim().isEmpty ||
        _itemIdController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty ||
        _dateController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(loc.translate('req') ?? 'Required'),
          content: Text(
            loc.translate(
                'Please fill in all fields before saving.') ??
                'Please fill in all fields before saving.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.translate('OK') ?? 'OK'),
            ),
          ],
        ),
      );
      return false;
    }

    if (int.tryParse(_customerIdController.text.trim()) == null ||
        int.tryParse(_itemIdController.text.trim()) == null ||
        double.tryParse(_priceController.text.trim()) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc.translate('enter_number') ?? 'Please enter valid numbers.',
          ),
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context)!;

    if (!_validateForm(loc)) return;

    final int customerId =
    int.parse(_customerIdController.text.trim());
    final int itemId =
    int.parse(_itemIdController.text.trim());
    final double price =
    double.parse(_priceController.text.trim());
    final String date = _dateController.text.trim();

    if (isEditing) {
      final original = widget.existingOffer!;
      // 檢查是否有變更
      final bool noChanges =
          original.customerId == customerId &&
              original.itemId == itemId &&
              original.priceOffered == price &&
              original.dateOfOffer == date &&
              original.accepted == _accepted;

      if (noChanges) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              loc.translate('No changes detected.') ??
                  'No changes detected.',
            ),
          ),
        );
        return;
      }

      final updated = original.copyWith(
        customerId: customerId,
        itemId: itemId,
        priceOffered: price,
        dateOfOffer: date,
        accepted: _accepted,
      );

      await _offerDAO.updateOffer(updated);
      await _saveLastInput();
      Navigator.pop(context, updated);
    } else {
      final newOffer = Offer(
        customerId: customerId,
        itemId: itemId,
        priceOffered: price,
        dateOfOffer: date,
        accepted: _accepted,
      );

      final int newId = await _offerDAO.insertOffer(newOffer);
      final inserted = newOffer.copyWith(id: newId);

      await _saveLastInput();
      Navigator.pop(context, inserted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? (loc.translate('update_offer') ?? 'Update offer')
              : (loc.translate('new_offer') ?? 'New offer'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _customerIdController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText:
                loc.translate('customer_id') ?? 'Customer ID',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _itemIdController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: loc.translate('item_id') ?? 'Item ID',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText:
                loc.translate('price_offered') ?? 'Price offered',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText:
                loc.translate('date_of_offer') ?? 'Date of offer',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    loc.translate('accepted') ?? 'Accepted?',
                  ),
                ),
                Switch(
                  value: _accepted,
                  onChanged: (v) {
                    setState(() {
                      _accepted = v;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _save,
              child: Text(
                isEditing
                    ? (loc.translate('update_offer') ?? 'Update offer')
                    : (loc.translate('save_offer') ?? 'Save offer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
