import 'package:floor/floor.dart';
import '../model/customer.dart';

/// Data Access Object for performing CRUD operations on the Customer table.
@dao
abstract class CustomerDAO{

  /// Returns all customers stored in the database.
  @Query('SELECT * FROM Customer ORDER BY id ASC')
  Future<List<Customer>> getAllCustomers();

  /// Inserts a new customer and returns the generated ID.
  @insert
  Future<int> insertCustomer(Customer i);

  /// Updates an existing customer record.
  @delete
  Future<int> deleteCustomer(Customer i);

  /// Deletes a customer from the database.
  @update
  Future<int> updateCustomer(Customer i);
}