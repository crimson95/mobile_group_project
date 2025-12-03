import 'package:floor/floor.dart';
import '../model/boat.dart';

@dao
abstract class BoatDAO {
  @Query('SELECT * FROM Boat')
  Future<List<Boat>> findAllBoats();

  @insert
  Future<void> insertBoat(Boat boat);

  @update
  Future<void> updateBoat(Boat boat);

  @delete
  Future<void> deleteBoat(Boat boat);
}