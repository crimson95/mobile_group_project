import 'package:floor/floor.dart';

@entity
class Customer{
  @primaryKey
  final int? id;
  final String firstName;
  final String lastName;
  final String address;
  final String bday;
  final String licenseNum;

  Customer({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.bday,
    required this.licenseNum
  });
}