import 'package:flutter/material.dart';
import 'pages/boats/boat_list_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/boats/boat_list_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:final_group_project/localization/app_localizations.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // helper to change language from pages
  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state =
    context.findAncestorStateOfType<_MyAppState>();
    state?.changeLanguage(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); // default English

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('fil'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const BoatListPage(), // for now start on your Boats screen
    );
  }
}