import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../dao/boatDatabase.dart';
import '../../model/boat.dart';
import 'package:final_group_project/localization/app_localizations.dart';


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
    String? year;
    String? length;
    String? power;
    String? price;
    String? address;

    try {
      year = await _encryptedPrefs.getString('boat_year');
      length = await _encryptedPrefs.getString('boat_length');
      power = await _encryptedPrefs.getString('boat_power');
      price = await _encryptedPrefs.getString('boat_price');
      address = await _encryptedPrefs.getString('boat_address');
    } catch (_) {
      return;
    }


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Boat added')),
    );

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
            title: Text(AppLocalizations.of(context)!.translate('copy_previous_boat_title')!,
            ),
            content: Text(AppLocalizations.of(context)!.translate('copy_previous_boat_title')!,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.translate('no')!,
                ),
              ),
              TextButton(
                onPressed: () {
                  _yearController.text = year!;
                  _lengthController.text = length!;
                  _powerController.text = power!;
                  _priceController.text = price!;
                  _addressController.text = address!;
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.translate('yes')!,
                ),
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
      SnackBar(content: Text(AppLocalizations.of(context)!.translate('boat_added')!,),),
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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.translate('add_boat')!,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration( labelText: AppLocalizations.of(context)!.translate('year_built')!,
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? AppLocalizations.of(context)!.translate('year_required')! : null,
              ),
              TextFormField(
                controller: _lengthController,
                decoration:
                InputDecoration(labelText: AppLocalizations.of(context)!.translate('length_meters')!,
                ),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                value == null || value.isEmpty ? AppLocalizations.of(context)!.translate('length_required')! : null,
              ),
              TextFormField(
                controller: _powerController,
                decoration:
                InputDecoration(labelText: AppLocalizations.of(context)!.translate('power_type')!,
                ),
                validator: (value) =>
                value == null || value.isEmpty ? AppLocalizations.of(context)!.translate('power_required')! : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('price')!,
                ),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                value == null || value.isEmpty ? AppLocalizations.of(context)!.translate('price_required')! : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate('address')!,
                ),
                validator: (value) =>
                value == null || value.isEmpty ?  AppLocalizations.of(context)!.translate('address_required')! : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveBoat,
                child: Text(AppLocalizations.of(context)!.translate('save')!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
