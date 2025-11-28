import 'package:flutter/material.dart';
import '../../dao/boatDatabase.dart';
import '../../model/boat.dart';

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
        .showSnackBar(const SnackBar(content: Text('Boat updated')));

    Navigator.pop(context);
  }

  Future<void> _deleteBoat() async {
    final db =
    await $FloorBoatDatabase.databaseBuilder('boat_database.db').build();
    final dao = db.boatDAO;

    await dao.deleteBoat(widget.boat);

    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Boat deleted')));

    Navigator.pop(context);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete boat'),
        content:
        const Text('Are you sure you want to delete this boat listing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteBoat();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boat details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year built'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? 'Year required' : null,
              ),
              TextFormField(
                controller: _lengthController,
                decoration:
                const InputDecoration(labelText: 'Length (meters)'),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                value == null || value.isEmpty ? 'Length required' : null,
              ),
              TextFormField(
                controller: _powerController,
                decoration:
                const InputDecoration(labelText: 'Power type (Sail/Motor)'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Power type required' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                value == null || value.isEmpty ? 'Price required' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Address required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateBoat,
                child: const Text('Update'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _confirmDelete,
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
