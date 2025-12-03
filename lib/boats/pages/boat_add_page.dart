import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../AppLocalizations.dart';
import '../dao/boatDatabase.dart';
import '../model/boat.dart';

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
        late final loc = AppLocalizations.of(context)!;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(loc.translate('copy_previous_boat_title')!),
            content: Text(
                loc.translate('copy_previous_boat_message')!),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(loc.translate('no')!),
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
                child: Text(loc.translate('yes')!),
              ),
            ],
          ),
        );
      });
    }
  }

  Future<void> _saveBoat() async {
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
      SnackBar(content: Text(loc.translate('boat_added')!)),
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
    late final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('add_boat')!)),
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
                onPressed: _saveBoat,
                child: Text(loc.translate('save')!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
