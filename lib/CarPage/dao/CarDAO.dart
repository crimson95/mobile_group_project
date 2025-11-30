import 'package:floor/floor.dart';
import '../model/car.dart';

@dao
abstract class CarDAO {
  @Query('SELECT * FROM Car')
  Future<List<Car>> getAllCars();

  @insert
  Future<int> insertCar(Car car);

  @update
  Future<void> updateCar(Car car);

  @delete
  Future<void> deleteCar(Car car);
}
