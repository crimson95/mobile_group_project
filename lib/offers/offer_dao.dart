import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'offer.dart';
/// Data Access Object (DAO) for all SQL operations related to purchase offers.
///
/// This class is responsible for:
/// • Creating the database and its tables
/// • Inserting new offers
/// • Retrieving all saved offers
/// • Updating existing records
/// • Deleting specific offers
///
/// By separating all SQL logic into this class, the UI stays clean and
/// the database code becomes reusable and easier to maintain.
class OfferDao {
  /// A single shared instance (Singleton pattern)
  /// so the whole app works with one database connection.
  static final OfferDao instance = OfferDao._init();
  /// The underlying SQLite database instance.
  static Database? _database;

  OfferDao._init();
  /// Returns the database instance, initializing it if needed.
  ///
  /// The first time this getter is called, the database file is created
  /// (if it doesn't exist) and the `_createDB` method is run.
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Create/open the database file
    _database = await _initDB('offers.db');
    return _database!;
  }
  /// Creates the physical database file on the device.
  ///
  /// [filePath] is the SQLite file name (e.g., "offers.db").
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }
  /// Runs only once — when the database file is first created.
  ///
  /// It defines the schema for the `offers` table.
  /// `accepted` is stored as an INTEGER (0 or 1), since SQLite
  /// doesn’t have a boolean type.
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE offers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerId TEXT NOT NULL,
        itemId TEXT NOT NULL,
        price REAL NOT NULL,
        date TEXT NOT NULL,
        accepted INTEGER NOT NULL
      )
    ''');
  }
  /// Inserts a new offer into the `offers` table.
  /// Returns the automatically generated ID of the new row.
  Future<int> insertOffer(Offer offer) async {
    final db = await instance.database;
    return await db.insert('offers', offer.toMap());
  }
  /// Retrieves all offers from the database in a List of `Offer` objects.
  /// If the table is empty, this simply returns an empty list.
  Future<List<Offer>> getOffers() async {
    final db = await instance.database;
    final result = await db.query('offers');
    // Convert each row (Map) into an Offer object using the model factory.
    return result.map((map) => Offer.fromMap(map)).toList();
  }
  /// Updates an existing offer in the database.
  ///
  /// The offer must already have an [id].
  /// Returns the number of affected rows (normally 1).
  Future<int> updateOffer(Offer offer) async {
    final db = await instance.database;
    return await db.update(
      'offers',
      offer.toMap(),
      where: 'id = ?',
      whereArgs: [offer.id],
    );
  }
  /// Removes a specific offer by its ID.
  ///
  /// Returns the number of deleted rows (normally 1).
  Future<int> deleteOffer(int id) async {
    final db = await instance.database;
    return await db.delete(
      'offers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
