import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'offer.dart';
import 'offer_dao.dart';

part 'offer_database.g.dart';

/// Floor database for storing purchase [Offer] records.
@Database(version: 1, entities: [Offer])
abstract class OfferDatabase extends FloorDatabase {
  /// DAO for accessing [Offer] records.
  OfferDAO get offerDAO;
}
