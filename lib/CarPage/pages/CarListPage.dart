import 'package:flutter/material.dart';
import '../model/car.dart';
import 'CarListPageState.dart';
import 'CarFormPage.dart';

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

class CarListPage extends StatefulWidget {
  const CarListPage({super.key});

  @override
  State<CarListPage> createState() => CarListPageState();
}

class CarListPageState extends State<CarListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cars for Sale")),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: sampleCars
                  .map((car) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CarCard(car: car),
              ))
                  .toList(),
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CarFormPage()),
          );
        },
      ),
    );
  }
}
