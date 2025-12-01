import 'package:floor/floor.dart';

/// Boat entity stored in the SQLite database.
@entity
class Boat {
  /// Static counter for generating unique IDs.
  static int ID = 1;

  @primaryKey
  final int id;

  final int yearBuilt;
  final double lengthMeters;
  final String powerType; // "Sail" or "Motor"
  final double price;
  final String address;

  Boat(
      this.id,
      this.yearBuilt,
      this.lengthMeters,
      this.powerType,
      this.price,
      this.address,
      ) {
    // keep ID ahead of any existing boat IDs
    if (id >= ID) {
      ID = id + 1;
    }
  }
}