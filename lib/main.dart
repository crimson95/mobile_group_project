import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'home_page.dart';
import 'l10n/app_localizations.dart';
/// Entry point of the whole application.
///
/// This is where I make sure Flutter is fully initialized,
/// set up desktop database support, and then launch the main widget tree.
Future<void> main() async {
  // Make sure the Flutter engine is ready before we touch
  // any plugins, databases, or platform-specific APIs.
  WidgetsFlutterBinding.ensureInitialized();
  // On desktop platforms, the regular sqflite package does not work
  // the same way it does on Android/iOS.
  // sqflite_common_ffi gives us a file-based database implementation
  // that behaves similarly, so the exact same code can run on Windows,
  // Linux, or macOS without extra changes.
  if (!kIsWeb &&
      (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  // Launch the root widget of the app.
  runApp(const MyApp());
}
  /// Root widget for the group project.
  ///
  /// This widget is responsible for:
  /// - Turning on Material Design for the whole app
  /// - Registering the localization system
  /// - Pointing to the first screen (the shared HomePage with 4 buttons)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Group Project',
// Localization setup:
      // AppLocalizations contains all the generated strings for each language.
      // By registering these delegates and supported locales here,
      // every screen in the app can easily call:
      //   AppLocalizations.of(context)!.someTextKey
      // and get the correct translation.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // If we wanted to force a specific language during testing
      // (for example always Arabic or always English),
      // we could uncomment this line and set the desired locale.
      // locale: const Locale('en'),

      // The first screen that shows up after the app starts.
      // HomePage is the shared entry point where the user chooses
      // which group member’s feature they want to open.

      home: const HomePage(),
    );
  }
}
