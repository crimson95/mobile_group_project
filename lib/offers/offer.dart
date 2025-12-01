/// A simple data model that represents a purchase offer created by the user.
///
/// This class is used throughout the app to transfer offer information
/// between the UI, the database, and secure storage.
///
/// Fields:
/// • [id] — Primary key in the SQLite table (null when inserting a new row)
/// • [customerId] — The ID of the customer making the offer
/// • [itemId] — The ID of the item (car or boat) the offer is for
/// • [price] — The monetary value the customer is offering
/// • [date] — The date the offer was made (yyyy-MM-dd format)
/// • [accepted] — Whether the offer has been accepted or not
class Offer {
  final int? id;
  final String customerId;
  final String itemId;
  final double price;
  final String date;
  final bool accepted;

  Offer({
    this.id,
    required this.customerId,
    required this.itemId,
    required this.price,
    required this.date,
    required this.accepted,
  });
  /// Returns a copy of this Offer with the option to override selected fields.
  ///
  /// This is extremely useful when updating a row in the database,
  /// because SQLite returns only the new ID when inserting, so we can
  /// easily attach it to a full Offer object.
  Offer copyWith({
    int? id,
    String? customerId,
    String? itemId,
    double? price,
    String? date,
    bool? accepted,
  }) {
    return Offer(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      itemId: itemId ?? this.itemId,
      price: price ?? this.price,
      date: date ?? this.date,
      accepted: accepted ?? this.accepted,
    );
  }
  /// Converts this Offer into a Map suitable for SQLite storage.
  ///
  /// Note: SQLite has no boolean type, so [accepted] is stored as 1 (true)
  /// or 0 (false).
  Map<String, dynamic> toMap() => {
    'id': id,
    'customerId': customerId,
    'itemId': itemId,
    'price': price,
    'date': date,
    'accepted': accepted ? 1 : 0,
  };
  /// Factory constructor that creates an Offer from a SQLite row.
  factory Offer.fromMap(Map<String, dynamic> map) => Offer(
    id: map['id'] as int?,
    customerId: map['customerId'] as String,
    itemId: map['itemId'] as String,
    price: (map['price'] as num).toDouble(),
    date: map['date'] as String,
    accepted: (map['accepted'] as int) == 1,
  );
  /// Converts this Offer into a JSON-safe Map (used by secure storage).
  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'itemId': itemId,
    'price': price,
    'date': date,
    'accepted': accepted,
  };

  /// Creates an Offer from a JSON Map.
  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    id: json['id'] as int?,
    customerId: json['customerId'] as String,
    itemId: json['itemId'] as String,
    price: (json['price'] as num).toDouble(),
    date: json['date'] as String,
    accepted: json['accepted'] as bool,
  );
}
