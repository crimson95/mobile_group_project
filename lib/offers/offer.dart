import 'package:floor/floor.dart';
import '../../AppLocalizations.dart';

/// Entity class representing a purchase offer made by a customer.
@Entity(tableName: 'Offer')
class Offer {
  /// Auto-generated primary key.
  @PrimaryKey(autoGenerate: true)
  final int? id;

  /// The customer ID who made the offer.
  final int customerId;

  /// ID of the car or boat.
  final int itemId;

  /// Offered price.
  final double priceOffered;

  /// Date of the offer (stored as a String, e.g. "2025-12-03").
  final String dateOfOffer;

  /// Whether this offer was accepted.
  final bool accepted;

  /// Creates a new [Offer] instance.
  Offer({
    this.id,
    required this.customerId,
    required this.itemId,
    required this.priceOffered,
    required this.dateOfOffer,
    required this.accepted,
  });

  /// Returns a copy of this offer with some fields replaced.
  Offer copyWith({
    int? id,
    int? customerId,
    int? itemId,
    double? priceOffered,
    String? dateOfOffer,
    bool? accepted,
  }) {
    return Offer(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      itemId: itemId ?? this.itemId,
      priceOffered: priceOffered ?? this.priceOffered,
      dateOfOffer: dateOfOffer ?? this.dateOfOffer,
      accepted: accepted ?? this.accepted,
    );
  }
}
