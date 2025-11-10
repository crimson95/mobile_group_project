import 'package:floor/floor.dart';
import '../model/customer.dart';

@dao
abstract class CustomerDAO{

  @Query('SELECT * FROM Customer')
  Future<List<Customer>> getAllCustomers();

  @insert
  Future<void> insertCustomer(Customer i);

  @delete
  Future<void> deleteCustomer(Customer i);

  @update
  Future<void> updateCustomer(Customer i);
}