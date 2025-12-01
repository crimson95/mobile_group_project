import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'customerDAO.dart';
import '../model/customer.dart';
part 'customerDatabase.g.dart';

/// Floor database definition for storing [Customer] records.
@Database(version: 1, entities: [Customer])
abstract class CustomerDatabase extends FloorDatabase{
  /// Provides access to the DAO for performing CRUD operations.
  CustomerDAO get myDAO;
}