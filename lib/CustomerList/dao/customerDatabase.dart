import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'customerDAO.dart';
import '../model/customer.dart';
part 'customerDatabase.g.dart';

@Database(version: 1, entities: [Customer])
abstract class CustomerDatabase extends FloorDatabase{
  CustomerDAO get myDAO;
}