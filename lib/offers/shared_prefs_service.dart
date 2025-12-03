import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

/// Handles saving and loading the last entered offer form data.
/// Used for both creating and editing purchase offers.
class OfferSharedPref {
  static final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  /// Saves last input fields for creating a purchase offer.
  static Future<void> saveOfferInput({
    required String customerId,
    required String itemId,
    required String price,
    required String date,
    required bool accepted,
  }) async {
    await _prefs.setString("offer_customerId", customerId);
    await _prefs.setString("offer_itemId", itemId);
    await _prefs.setString("offer_price", price);
    await _prefs.setString("offer_date", date);
    await _prefs.setString("offer_accepted", accepted ? "1" : "0");
  }

  /// Loads previously saved offer form data.
  /// Returns a Map<String, dynamic>.
  static Future<Map<String, dynamic>> loadOfferInput() async {
    final customerId = await _prefs.getString("offer_customerId") ?? "";
    final itemId = await _prefs.getString("offer_itemId") ?? "";
    final price = await _prefs.getString("offer_price") ?? "";
    final date = await _prefs.getString("offer_date") ?? "";
    final acceptedString = await _prefs.getString("offer_accepted") ?? "0";

    return {
      "customerId": customerId,
      "itemId": itemId,
      "price": price,
      "date": date,
      "accepted": acceptedString == "1",
    };
  }

  /// Clears saved data if needed.
  static Future<void> clear() async {
    await _prefs.clear();
  }
}
