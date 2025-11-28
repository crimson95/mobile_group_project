import 'package:floor/floor.dart';
import '../model/customer.dart';

@dao
abstract class CustomerDAO{

  @Query('SELECT * FROM Customer ORDER BY id ASC')
  Future<List<Customer>> getAllCustomers();

  @insert
  Future<int> insertCustomer(Customer i);

  @delete
  Future<int> deleteCustomer(Customer i);

  @update
  Future<int> updateCustomer(Customer i);
}