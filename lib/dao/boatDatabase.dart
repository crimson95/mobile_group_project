import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../model/boat.dart';
import 'boatDAO.dart';

part 'boatDatabase.g.dart';

@Database(version: 1, entities: [Boat])
abstract class BoatDatabase extends FloorDatabase {
  BoatDAO get boatDAO;
}