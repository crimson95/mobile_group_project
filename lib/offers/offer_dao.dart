import 'package:floor/floor.dart';
import 'offer.dart';

/// Data Access Object for the [Offer] table.
@dao
abstract class OfferDAO {
  /// Returns all offers in the database.
  @Query('SELECT * FROM Offer')
  Future<List<Offer>> getAllOffers();

  /// Inserts a new offer and returns the generated ID.
  @insert
  Future<int> insertOffer(Offer offer);

  /// Updates an existing offer.
  @update
  Future<void> updateOffer(Offer offer);

  /// Deletes an offer from the database.
  @delete
  Future<void> deleteOffer(Offer offer);
}
