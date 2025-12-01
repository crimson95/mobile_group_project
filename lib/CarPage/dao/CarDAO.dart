import 'package:floor/floor.dart';
import '../model/car.dart';

/// Data Access Object (DAO) for managing all database operations
/// related to the [Car] entity.
///
/// This DAO provides CRUD functions including retrieving all cars,
/// finding a car by ID, inserting new cars, updating existing cars,
/// and deleting car records.
@dao
abstract class CarDAO {
  /// Retrieves all car records stored in the database.
  ///
  /// Returns a [Future] that completes with a list of all [Car] objects.
  @Query('SELECT * FROM Car')
  Future<List<Car>> getAllCars();

  /// Retrieves a single car by its unique [id].
  ///
  /// If no matching car exists, this method returns `null`.
  @Query('SELECT * FROM Car WHERE id = :id')
  Future<Car?> findCarById(int id);

  /// Inserts a new [car] into the database.
  ///
  /// Returns a [Future] that completes with the inserted row's ID.
  @insert
  Future<int> insertCar(Car car);

  /// Updates an existing [car] in the database.
  ///
  /// The car must already exist, otherwise nothing will be updated.
  @update
  Future<void> updateCar(Car car);

  /// Deletes the specified [car] from the database.
  ///
  /// If the car does not exist, this method performs no action.
  @delete
  Future<void> deleteCar(Car car);
}
