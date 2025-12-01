import 'package:floor/floor.dart';

/// Represents a car entity stored in the Floor database.
///
/// This model includes all important attributes of a car such as
/// year, make, model, price, mileage, and type. The class also
/// provides serialization methods for converting to and from JSON.
@entity
class Car {
  /// The primary key used to uniquely identify the car in the database.
  @primaryKey
  final int id;

  /// The manufacturing year of the car.
  final int year;

  /// The brand or manufacturer of the car.
  String make;

  /// The model name of the car.
  String model;

  /// The selling price of the car.
  String price;

  /// The recorded mileage of the car.
  String mileage;

  /// The classification or type of the car (e.g., Sedan, SUV).
  String type;

  /// Creates a new [Car] object with the specified fields.
  Car({
    required this.id,
    required this.year,
    required this.make,
    required this.model,
    required this.price,
    required this.mileage,
    required this.type,
  });

  /// Converts the current [Car] object into a JSON-compatible map.
  ///
  /// This method is useful for storing the car data or transmitting it
  /// over a network.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'year': year,
      'make': make,
      'model': model,
      'price': price,
      'mileage': mileage,
      'type': type,
    };
  }

  /// Creates a new [Car] instance from a JSON map.
  ///
  /// The [json] parameter must contain all expected fields.
  static Car fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      year: json['year'],
      make: json['make'],
      model: json['model'],
      price: json['price'],
      mileage: json['mileage'],
      type: json['type'],
    );
  }
}
