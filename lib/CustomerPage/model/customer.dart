import 'package:floor/floor.dart';

@entity
/// Represents a customer entity stored in the database.
class Customer{
  @primaryKey
  /// The auto-generated ID of the customer.
  final int? id;
  /// The first name of the customer.
  final String firstName;
  // The last name of the customer.
  final String lastName;
  /// The home address of the customer.
  final String address;
  /// The birthday of the customer.
  final String bday;
  /// The driver's license number of the customer.
  final String licenseNum;

  /// Creates a new [Customer] object.
  Customer({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.bday,
    required this.licenseNum
  });
}