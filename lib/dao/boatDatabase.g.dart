// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boatDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $BoatDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $BoatDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $BoatDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<BoatDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorBoatDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $BoatDatabaseBuilderContract databaseBuilder(String name) =>
      _$BoatDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $BoatDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$BoatDatabaseBuilder(null);
}

class _$BoatDatabaseBuilder implements $BoatDatabaseBuilderContract {
  _$BoatDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $BoatDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $BoatDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<BoatDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$BoatDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$BoatDatabase extends BoatDatabase {
  _$BoatDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  BoatDAO? _boatDAOInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Boat` (`id` INTEGER NOT NULL, `yearBuilt` INTEGER NOT NULL, `lengthMeters` REAL NOT NULL, `powerType` TEXT NOT NULL, `price` REAL NOT NULL, `address` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BoatDAO get boatDAO {
    return _boatDAOInstance ??= _$BoatDAO(database, changeListener);
  }
}

class _$BoatDAO extends BoatDAO {
  _$BoatDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _boatInsertionAdapter = InsertionAdapter(
            database,
            'Boat',
            (Boat item) => <String, Object?>{
                  'id': item.id,
                  'yearBuilt': item.yearBuilt,
                  'lengthMeters': item.lengthMeters,
                  'powerType': item.powerType,
                  'price': item.price,
                  'address': item.address
                }),
        _boatUpdateAdapter = UpdateAdapter(
            database,
            'Boat',
            ['id'],
            (Boat item) => <String, Object?>{
                  'id': item.id,
                  'yearBuilt': item.yearBuilt,
                  'lengthMeters': item.lengthMeters,
                  'powerType': item.powerType,
                  'price': item.price,
                  'address': item.address
                }),
        _boatDeletionAdapter = DeletionAdapter(
            database,
            'Boat',
            ['id'],
            (Boat item) => <String, Object?>{
                  'id': item.id,
                  'yearBuilt': item.yearBuilt,
                  'lengthMeters': item.lengthMeters,
                  'powerType': item.powerType,
                  'price': item.price,
                  'address': item.address
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Boat> _boatInsertionAdapter;

  final UpdateAdapter<Boat> _boatUpdateAdapter;

  final DeletionAdapter<Boat> _boatDeletionAdapter;

  @override
  Future<List<Boat>> findAllBoats() async {
    return _queryAdapter.queryList('SELECT * FROM Boat',
        mapper: (Map<String, Object?> row) => Boat(
            row['id'] as int,
            row['yearBuilt'] as int,
            row['lengthMeters'] as double,
            row['powerType'] as String,
            row['price'] as double,
            row['address'] as String));
  }

  @override
  Future<void> insertBoat(Boat boat) async {
    await _boatInsertionAdapter.insert(boat, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBoat(Boat boat) async {
    await _boatUpdateAdapter.update(boat, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBoat(Boat boat) async {
    await _boatDeletionAdapter.delete(boat);
  }
}
