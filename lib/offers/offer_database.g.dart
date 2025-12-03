// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $OfferDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $OfferDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $OfferDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<OfferDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorOfferDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $OfferDatabaseBuilderContract databaseBuilder(String name) =>
      _$OfferDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $OfferDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$OfferDatabaseBuilder(null);
}

class _$OfferDatabaseBuilder implements $OfferDatabaseBuilderContract {
  _$OfferDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $OfferDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $OfferDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<OfferDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$OfferDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$OfferDatabase extends OfferDatabase {
  _$OfferDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  OfferDAO? _offerDAOInstance;

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
            'CREATE TABLE IF NOT EXISTS `Offer` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `customerId` INTEGER NOT NULL, `itemId` INTEGER NOT NULL, `priceOffered` REAL NOT NULL, `dateOfOffer` TEXT NOT NULL, `accepted` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  OfferDAO get offerDAO {
    return _offerDAOInstance ??= _$OfferDAO(database, changeListener);
  }
}

class _$OfferDAO extends OfferDAO {
  _$OfferDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _offerInsertionAdapter = InsertionAdapter(
            database,
            'Offer',
            (Offer item) => <String, Object?>{
                  'id': item.id,
                  'customerId': item.customerId,
                  'itemId': item.itemId,
                  'priceOffered': item.priceOffered,
                  'dateOfOffer': item.dateOfOffer,
                  'accepted': item.accepted ? 1 : 0
                }),
        _offerUpdateAdapter = UpdateAdapter(
            database,
            'Offer',
            ['id'],
            (Offer item) => <String, Object?>{
                  'id': item.id,
                  'customerId': item.customerId,
                  'itemId': item.itemId,
                  'priceOffered': item.priceOffered,
                  'dateOfOffer': item.dateOfOffer,
                  'accepted': item.accepted ? 1 : 0
                }),
        _offerDeletionAdapter = DeletionAdapter(
            database,
            'Offer',
            ['id'],
            (Offer item) => <String, Object?>{
                  'id': item.id,
                  'customerId': item.customerId,
                  'itemId': item.itemId,
                  'priceOffered': item.priceOffered,
                  'dateOfOffer': item.dateOfOffer,
                  'accepted': item.accepted ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Offer> _offerInsertionAdapter;

  final UpdateAdapter<Offer> _offerUpdateAdapter;

  final DeletionAdapter<Offer> _offerDeletionAdapter;

  @override
  Future<List<Offer>> getAllOffers() async {
    return _queryAdapter.queryList('SELECT * FROM Offer',
        mapper: (Map<String, Object?> row) => Offer(
            id: row['id'] as int?,
            customerId: row['customerId'] as int,
            itemId: row['itemId'] as int,
            priceOffered: row['priceOffered'] as double,
            dateOfOffer: row['dateOfOffer'] as String,
            accepted: (row['accepted'] as int) != 0));
  }

  @override
  Future<int> insertOffer(Offer offer) {
    return _offerInsertionAdapter.insertAndReturnId(
        offer, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateOffer(Offer offer) async {
    await _offerUpdateAdapter.update(offer, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteOffer(Offer offer) async {
    await _offerDeletionAdapter.delete(offer);
  }
}
