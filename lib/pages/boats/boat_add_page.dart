import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../dao/boatDatabase.dart';
import '../../model/boat.dart';

class BoatAddPage extends StatefulWidget {
  const BoatAddPage({super.key});

  @override
  State<BoatAddPage> createState() => _BoatAddPageState();
}

class _BoatAddPageState extends State<BoatAddPage> {
  final _yearController = TextEditingController();
  final _lengthController = TextEditingController();
  final _powerController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _encryptedPrefs = EncryptedSharedPreferences();

  @override
  void initState() {
    super.initState();
    _loadLastBoat();
  }

  Future<void> _loadLastBoat() async {
    // read previous boat values (if any)
    final year = await _encryptedPrefs.getString('boat_year').catchError((_) => null);
    final length = await _encryptedPrefs.getString('boat_length').catchError((_) => null);
    final power = await _encryptedPrefs.getString('boat_power').catchError((_) => null);
    final price = await _encryptedPrefs.getString('boat_price').catchError((_) => null);
    final address = await _encryptedPrefs.getString('boat_address').catchError((_) => null);

    if (!mounted) return;

    if (year != null &&
        length != null &&
        power != null &&
        price != null &&
        address != null) {
      // ask if user wants to copy
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Copy previous boat?'),
            content: const Text(
                'Do you want to start with the values from the last boat you added?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  _yearController.text = year;
                  _lengthController.text = length;
                  _powerController.text = power;
                  _priceController.text = price;
                  _addressController.text = address;
                  Navigator.pop(context);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      });
    }
  }

  Future<void> _saveBoat() async {
    if (!_formKey.currentState!.validate()) return;

    final year = int.parse(_yearController.text.trim());
    final length = double.parse(_lengthController.text.trim());
    final power = _powerController.text.trim();
    final price = double.parse(_priceController.text.trim());
    final address = _addressController.text.trim();

    final db =
    await $FloorBoatDatabase.databaseBuilder('boat_database.db').build();
    final dao = db.boatDAO;

    final boat = Boat(Boat.ID++, year, length, power, price, address);
    await dao.insertBoat(boat);

    // save last boat to encrypted shared prefs
    await _encryptedPrefs.setString('boat_year', year.toString());
    await _encryptedPrefs.setString('boat_length', length.toString());
    await _encryptedPrefs.setString('boat_power', power);
    await _encryptedPrefs.setString('boat_price', price.toString());
    await _encryptedPrefs.setString('boat_address', address);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Boat added')),
    );

    Navigator.pop(context); // go back to list
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add boat')),
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
                onPressed: _saveBoat,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
