import 'package:flutter/material.dart';
import '../model/car.dart';
import 'CarFormPage.dart';
import '../dao/CarDatabase.dart';
import 'CarListPageState.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import '../../AppLocalizations.dart';

/// A static list of sample cars used as placeholder data.
///
/// This can be useful for testing or demonstrating the UI
/// when there is no data stored in the database.
final List<Car> sampleCars = [
  Car(
    id: 1,
    year: 2020,
    make: "Toyota",
    model: "Corolla",
    price: "\$23,000",
    mileage: "50,000 km",
    type: "Sedan",
  ),
  Car(
    id: 2,
    year: 2021,
    make: "Honda",
    model: "Civic",
    price: "\$25,000",
    mileage: "30,000 km",
    type: "Sedan",
  ),
  Car(
    id: 3,
    year: 2019,
    make: "Ford",
    model: "Escape",
    price: "\$27,500",
    mileage: "60,000 km",
    type: "SUV",
  ),
];

/// A page that displays the list of cars stored in the local database.
///
/// This page supports both small-screen (single-column) and large-screen
/// (master-detail) layouts, and provides actions to create, edit and delete cars.
class CarListPage extends StatefulWidget {
  const CarListPage({super.key});

  @override
  State<CarListPage> createState() => CarListPageState();
}

/// State class that manages the behavior and UI of [CarListPage].
class CarListPageState extends State<CarListPage> {
  /// Encrypted preferences used to store and retrieve the last saved car title.
  final EncryptedSharedPreferences encryptedPrefs =
  EncryptedSharedPreferences();

  /// The title of the last car saved by the user.
  String? lastSavedCarTitle;

  /// The list of cars currently loaded from the database.
  List<Car> cars = [];

  /// The car that is currently selected in wide-screen (master-detail) mode.
  Car? _selectedCar;

  @override
  void initState() {
    super.initState();
    _loadCars();
    _loadLastSavedCar();
  }

  /// Loads the last saved car title from encrypted shared preferences.
  Future<void> _loadLastSavedCar() async {
    final title = await encryptedPrefs.getString('last_saved_car_title');
    setState(() {
      lastSavedCarTitle = title;
    });
  }

  /// Loads all cars from the Floor database and updates the local list.
  Future<void> _loadCars() async {
    final db = await $FloorCarDatabase.databaseBuilder('car.db').build();
    final allCars = await db.carDAO.getAllCars();
    setState(() {
      cars = allCars;
    });
  }

  /// Navigates to the [CarFormPage] to edit an existing car.
  ///
  /// When the user finishes editing, the updated car is saved back to the database
  /// and the list of cars is refreshed.
  Future<void> _editCar(int carId) async {
    final updatedCar = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CarFormPage(carId: carId),
      ),
    );

    if (updatedCar != null) {
      final db = await $FloorCarDatabase.databaseBuilder('car.db').build();
      await db.carDAO.updateCar(updatedCar);
    }

    await _loadCars();
  }

  /// Deletes the provided [car] from the database and reloads the list.
  Future<void> _deleteCar(Car car) async {
    final db = await $FloorCarDatabase.databaseBuilder('car.db').build();
    await db.carDAO.deleteCar(car);
    await _loadCars();
  }

  /// Builds the list widget that displays all cars.
  ///
  /// The [isWide] flag controls whether the list is shown as a simple
  /// card list (on narrow screens) or as a simple text list used in a
  /// master-detail layout (on wide screens).
  Widget _buildCarList(bool isWide) {
    final loc = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (lastSavedCarTitle != null)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "${loc?.translate('last_saved_car') ?? 'Last Saved Car'}: $lastSavedCarTitle",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ...cars.map(
              (car) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                if (isWide) {
                  setState(() {
                    _selectedCar = car;
                  });
                } else {
                  _editCar(car.id);
                }
              },
              child: isWide
                  ? Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${car.year} ${car.make} ${car.model}",
                  style: const TextStyle(fontSize: 16),
                ),
              )
                  : CarCard(
                car: car,
                onDelete: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          loc?.translate('confirm_delete_title') ??
                              "Confirm Delete",
                        ),
                        content: Text(
                          loc?.translate('confirm_delete_content') ??
                              "Are you sure you want to delete this car?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              loc?.translate('cancel') ?? "Cancel",
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);

                              await _deleteCar(car);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    loc?.translate('car_deleted') ??
                                        "Car deleted successfully",
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              loc?.translate('delete') ?? "Delete",
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the detail panel used on wide screens, showing the selected car
  /// along with an edit and delete action.
  Widget _buildDetailPanel() {
    final loc = AppLocalizations.of(context);

    if (_selectedCar == null) {
      return Center(
        child: Text(
          loc?.translate('select_car_from_list') ??
              'Select a car from the list',
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    final car = _selectedCar!;

    return Center(
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CarCard(
              car: car,
              onDelete: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        loc?.translate('confirm_delete_title') ??
                            "Confirm Delete",
                      ),
                      content: Text(
                        loc?.translate('confirm_delete_content') ??
                            "Are you sure you want to delete this car?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            loc?.translate('cancel') ?? "Cancel",
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);

                            await _deleteCar(car);

                            setState(() {
                              _selectedCar = null;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  loc?.translate('car_deleted') ??
                                      "Car deleted successfully",
                                ),
                              ),
                            );
                          },
                          child: Text(
                            loc?.translate('delete') ?? "Delete",
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _editCar(car.id);
                },
                child: Text(
                  loc?.translate('edit_car') ?? "Edit Car",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isWide = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc?.translate('car_list_title') ?? "Cars for Sale",
        ),
      ),
      body: isWide
          ? Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: _buildCarList(true),
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            flex: 3,
            child: _buildDetailPanel(),
          ),
        ],
      )
          : Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: _buildCarList(false),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          if (cars.isEmpty) {
            final newCar = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CarFormPage(),
              ),
            );

            if (newCar != null) {
              final db =
              await $FloorCarDatabase.databaseBuilder('car.db').build();

              await db.carDAO.insertCar(newCar);

              setState(() {
                cars.add(newCar);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    loc?.translate('car_added') ?? "Car added successfully",
                  ),
                ),
              );
            }
            return;
          }

          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text(
                  loc?.translate('new_car_title') ?? "New car",
                ),
                content: Text(
                  loc?.translate('new_car_content') ??
                      "How do you want to start?",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: Text(
                      loc?.translate('cancel') ?? "Cancel",
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext);

                      final lastCar = cars.last;

                      final newCar = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CarFormPage(
                            templateCar: lastCar,
                          ),
                        ),
                      );

                      if (newCar != null) {
                        final db = await $FloorCarDatabase
                            .databaseBuilder('car.db')
                            .build();

                        await db.carDAO.insertCar(newCar);

                        setState(() {
                          cars.add(newCar);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              loc?.translate('car_added') ??
                                  "Car added successfully",
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      loc?.translate('copy_last') ?? "Copy last",
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext);

                      final newCar = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CarFormPage(),
                        ),
                      );

                      if (newCar != null) {
                        final db = await $FloorCarDatabase
                            .databaseBuilder('car.db')
                            .build();

                        await db.carDAO.insertCar(newCar);

                        setState(() {
                          cars.add(newCar);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              loc?.translate('car_added') ??
                                  "Car added successfully",
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      loc?.translate('blank_form') ?? "Blank form",
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
