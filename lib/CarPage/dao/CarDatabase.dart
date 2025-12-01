import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'CarDAO.dart';
import '../model/car.dart';

part 'CarDatabase.g.dart';

/// The Floor database definition for storing and managing [Car] entities.
///
/// This abstract class defines the schema version and registers all entities.
/// Floor automatically generates the concrete implementation in
/// `CarDatabase.g.dart` when the build runner is executed.
///
/// Use `$FloorCarDatabase.databaseBuilder('car.db').build()` to obtain
/// an instance of this database at runtime.
@Database(version: 1, entities: [Car])
abstract class CarDatabase extends FloorDatabase {
  /// Provides access to all database operations related to the [Car] entity.
  ///
  /// The generated implementation will supply the correct DAO instance.
  CarDAO get carDAO;
}
