import 'package:floor/floor.dart';

@entity
class Car {
  @primaryKey
  final int id;

  final int year;
  String make;
  String model;
  String price;
  String mileage;
  String type;

  Car({
    required this.id,
    required this.year,
    required this.make,
    required this.model,
    required this.price,
    required this.mileage,
    required this.type,
  });
}