import 'package:flutter/material.dart';
import '../dao/boatDatabase.dart';
import '../model/boat.dart';
import '../../AppLocalizations.dart';

class BoatDetailsPage extends StatefulWidget {
  final Boat boat;

  const BoatDetailsPage({super.key, required this.boat});

  @override
  State<BoatDetailsPage> createState() => _BoatDetailsPageState();
}

class _BoatDetailsPageState extends State<BoatDetailsPage> {
  late TextEditingController _yearController;
  late TextEditingController _lengthController;
  late TextEditingController _powerController;
  late TextEditingController _priceController;
  late TextEditingController _addressController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _yearController =
        TextEditingController(text: widget.boat.yearBuilt.toString());
    _lengthController =
        TextEditingController(text: widget.boat.lengthMeters.toString());
    _powerController = TextEditingController(text: widget.boat.powerType);
    _priceController =
        TextEditingController(text: widget.boat.price.toString());
    _addressController = TextEditingController(text: widget.boat.address);
  }

  @override
  void dispose() {
    _yearController.dispose();
    _lengthController.dispose();
    _powerController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _updateBoat() async {
    late final loc = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final year = int.parse(_yearController.text.trim());
    final length = double.parse(_lengthController.text.trim());
    final power = _powerController.text.trim();
    final price = double.parse(_priceController.text.trim());
    final address = _addressController.text.trim();

    final db =
    await $FloorBoatDatabase.databaseBuilder('boat_database.db').build();
    final dao = db.boatDAO;

    final updated = Boat(
      widget.boat.id,
      year,
      length,
      power,
      price,
      address,
    );

    await dao.updateBoat(updated);

    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(loc.translate('boat_updated')!)));

    Navigator.pop(context);
  }

  Future<void> _deleteBoat() async {
    late final loc = AppLocalizations.of(context)!;
    final db =
    await $FloorBoatDatabase.databaseBuilder('boat_database.db').build();
    final dao = db.boatDAO;

    await dao.deleteBoat(widget.boat);

    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(loc.translate('boat_deleted')!)));

    Navigator.pop(context);
  }

  void _confirmDelete() {
    late final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.translate('delete_boat')!),
        content:
        Text(loc.translate('delete_boat_msg')!),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.translate('no')!),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteBoat();
            },
            child: Text(loc.translate('yes')!),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    late final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('boat_details')!)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: loc.translate('year_built')!),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? loc.translate('year_required')! : null,
              ),
              TextFormField(
                controller: _lengthController,
                decoration:
                InputDecoration(labelText: loc.translate('length_meters')!),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                value == null || value.isEmpty ? loc.translate('length_required')! : null,
              ),
              TextFormField(
                controller: _powerController,
                decoration:
                InputDecoration(labelText: loc.translate('power_type')!),
                validator: (value) =>
                value == null || value.isEmpty ? loc.translate('power_required')! : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: loc.translate('price')!),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                value == null || value.isEmpty ? loc.translate('price_required')! : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: loc.translate('address')!),
                validator: (value) =>
                value == null || value.isEmpty ? loc.translate('address_required')! : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateBoat,
                child: Text(loc.translate('Update')!),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _confirmDelete,
                child: Text(loc.translate('Delete')!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
