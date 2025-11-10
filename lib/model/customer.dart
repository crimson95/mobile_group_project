import 'package:floor/floor.dart';

@entity
class Customer{
  static int ID = 1;

  Customer(this.id, this.firstName, this.lastName, this.address, this.bday, this.licenseNum){
    if(this.id > ID){
      ID = this.id + 1;
    }
  }

  @primaryKey
  final int id;

  String firstName;
  String lastName;
  String address;
  String bday;
  int licenseNum;
}