import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'offer.dart';
import 'dart:convert';
/// A small helper class responsible for securely remembering
/// the last purchase offer the user worked on.
///
/// In this project, we use encrypted storage instead of regular
/// SharedPreferences because the assignment requires that sensitive
/// or user-typed information is saved securely.
///
/// This class hides all the read/write logic so the rest of the app
/// doesn’t need to think about JSON, encryption, or storage keys.
class SharedPrefsService {
  /// The unique key we use to store the serialized offer.
  /// Using a constant prevents typos across the codebase.
  static const _key = 'last_offer';
  /// Secure storage instance.
  ///
  /// `FlutterSecureStorage` automatically encrypts data on Android/iOS,
  /// and uses safe system-level APIs where available.
  static const _storage = FlutterSecureStorage();
  /// Saves the most recently entered offer.
  ///
  /// This method converts the `Offer` object into a JSON string
  /// so it can be stored in encrypted storage.
  /// Next time the user opens the app, we can restore these values
  /// to pre-fill the form or give them the option to copy from
  /// their last entry.
  static Future<void> saveLastOffer(Offer offer) async {
    final jsonStr = jsonEncode(offer.toMap());
    await _storage.write(key: _key, value: jsonStr);
  }
  /// Loads the last saved offer, if any exists.
  ///
  /// If this is the first time the app runs, or if the user cleared their data,
  /// the method returns `null` so the calling screen can start with a blank form.
  ///
  /// When data *is* found, we decode the JSON back into a Dart `Map`,
  /// and then rebuild a full `Offer` object through the model’s factory.

  static Future<Offer?> loadLastOffer() async {
    final jsonStr = await _storage.read(key: _key);
    if (jsonStr == null) return null;

    final map = jsonDecode(jsonStr);
    return Offer.fromMap(map);
  }
}
