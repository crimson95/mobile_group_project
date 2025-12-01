import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import '../model/car.dart';
import '../dao/CarDatabase.dart';
import '../../AppLocalizations.dart';

/// A page that provides a form for creating or editing a car entry.
///
/// This page supports two modes:
/// - Editing an existing car (when [carId] is provided)
/// - Creating a new car optionally prefilled using [templateCar]
class CarFormPage extends StatefulWidget {
  /// The ID of the car to edit. If null, the form creates a new car.
  final int? carId;

  /// A car object whose values are used to prefill the form for quick duplication.
  final Car? templateCar;

  const CarFormPage({super.key, this.carId, this.templateCar});

  @override
  State<CarFormPage> createState() => _CarFormPageState();
}

/// State class that manages the behavior of [CarFormPage].
class _CarFormPageState extends State<CarFormPage> {
  /// Controller for the auto-generated car title.
  final TextEditingController titleController = TextEditingController();

  /// Controller for the car's year field.
  final TextEditingController yearController = TextEditingController();

  /// Controller for the car's make field.
  final TextEditingController makeController = TextEditingController();

  /// Controller for the car's model field.
  final TextEditingController modelController = TextEditingController();

  /// Controller for the car's price field.
  final TextEditingController priceController = TextEditingController();

  /// Encrypted preferences used to store the last saved car's title.
  final EncryptedSharedPreferences encryptedPrefs =
  EncryptedSharedPreferences();

  @override
  void initState() {
    super.initState();
    if (widget.carId != null) {
      _loadCar(widget.carId!);
    } else if (widget.templateCar != null) {
      final c = widget.templateCar!;
      yearController.text = c.year.toString();
      makeController.text = c.make;
      modelController.text = c.model;
      priceController.text = c.price;
    }
  }

  /// Loads an existing car from the database and populates the form fields.
  ///
  /// [id] is the database ID of the car to load.
  Future<void> _loadCar(int id) async {
    final db = await $FloorCarDatabase.databaseBuilder('car.db').build();
    final car = await db.carDAO.findCarById(id);

    if (car != null) {
      setState(() {
        yearController.text = car.year.toString();
        makeController.text = car.make;
        modelController.text = car.model;
        priceController.text = car.price;
        titleController.text = "${car.year} ${car.make} ${car.model}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.translate('car_editor_title') ?? "Car Editor"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            Text(
              loc?.translate('year') ?? "Year",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText:
                loc?.translate('enter_year_hint') ?? "Enter year (e.g. 2020)",
              ),
            ),
            const SizedBox(height: 16),

            Text(
              loc?.translate('make') ?? "Make",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: makeController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: loc?.translate('enter_make_hint') ??
                    "Enter make (e.g. Toyota)",
              ),
            ),
            const SizedBox(height: 16),

            Text(
              loc?.translate('model') ?? "Model",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: modelController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: loc?.translate('enter_model_hint') ??
                    "Enter model (e.g. Corolla)",
              ),
            ),
            const SizedBox(height: 16),

            Text(
              loc?.translate('price') ?? "Price",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: loc?.translate('enter_price_hint') ??
                    "Enter price (e.g. \$20,000)",
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: Text(
                          loc?.translate('confirm_save_title') ??
                              "Confirm Save",
                        ),
                        content: Text(
                          loc?.translate('confirm_save_content') ??
                              "Do you want to save this car?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            child:
                            Text(loc?.translate('cancel') ?? "Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              _onSavePressed();
                            },
                            child:
                            Text(loc?.translate('save_car') ?? "Save"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(loc?.translate('save_car') ?? "Save Car"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Validates form data, saves shared preferences, and returns the created or
  /// updated [Car] object back to the previous page.
  Future<void> _onSavePressed() async {
    final title = titleController.text.trim();
    final yearText = yearController.text.trim();
    final make = makeController.text.trim();
    final model = modelController.text.trim();
    final price = priceController.text.trim();

    final loc = AppLocalizations.of(context);

    if (yearText.isEmpty || make.isEmpty || model.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc?.translate('please_fill_all_fields') ??
                "Please fill in all fields.",
          ),
        ),
      );
      return;
    }

    await encryptedPrefs.setString(
      'last_saved_car_title',
      "$yearText $make $model",
    );

    if (widget.carId == null) {
      final newCar = Car(
        id: DateTime.now().millisecondsSinceEpoch,
        year: int.parse(yearText),
        make: make,
        model: model,
        price: price,
        mileage: "N/A",
        type: "Unknown",
      );
      Navigator.pop(context, newCar);
    } else {
      final updatedCar = Car(
        id: widget.carId!,
        year: int.parse(yearText),
        make: make,
        model: model,
        price: price,
        mileage: "N/A",
        type: "Unknown",
      );
      Navigator.pop(context, updatedCar);
    }
  }
}
