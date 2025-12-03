import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'boats/pages/boat_list_page.dart';
import 'CustomerPage/dao/customerDatabase.dart';
import 'CustomerPage/pages/CustomerPage.dart';
import 'CarPage/pages/carlistpage.dart';
import 'offers/offer_database.dart';
import 'offers/offers_page.dart';
import 'AppLocalizations.dart';

/// Entry point of the application. Initializes the Floor database.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Customer DB
  final customerDb = await $FloorCustomerDatabase
      .databaseBuilder('customer.db')
      .build();

  // Offer DB
  final offerDb = await $FloorOfferDatabase
      .databaseBuilder('offer_database.db')
      .build();

  runApp(MyApp(
    customerDatabase: customerDb,
    offerDatabase: offerDb,
  ));
}


/// Root widget of the application, stores the selected locale state.
class MyApp extends StatefulWidget {
  /// Shared Floor database instance for customers
  final CustomerDatabase customerDatabase;

  /// Shared Floor database instance for offers
  final OfferDatabase offerDatabase;

  const MyApp({
    super.key,
    required this.customerDatabase,
    required this.offerDatabase,
  });

  static void setLocale(BuildContext context, Locale newLocale) {
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state?.changeLanguage(newLocale);
  }

  @override
  MyAppState createState() => MyAppState();
}


/// Application state responsible for storing theme and locale information.
class MyAppState extends State<MyApp>{
  /// Current selected locale. Defaults to English (Canada).
  var _locale = Locale('en', 'CA');

  /// Updates the UI language.
  void changeLanguage(Locale newLocale){
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en','CA'),
        Locale('zh'),
        Locale('ar'),
        Locale('fr'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: _locale,
      debugShowCheckedModeBanner: false,
      title: 'Final project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        appBarTheme: AppBarTheme(
          backgroundColor:Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      home: MainMenu(database: widget.customerDatabase,
        offerDb: widget.offerDatabase,),
    );
  }
}

/// Main menu of the application, containing navigation buttons.
class MainMenu extends StatelessWidget {
  /// Provides access to the Floor database.
  final CustomerDatabase database;
  final OfferDatabase offerDb;

  const MainMenu({super.key, required this.database, required this.offerDb,});

  /// Builds the language dropdown menu for selecting application locale.
  Widget _buildLanguageDropdown(BuildContext context) {
    Locale current = Localizations.localeOf(context);
    final loc = AppLocalizations.of(context)!;

    return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        value: current,
        icon: const Icon(Icons.language, color: Colors.white),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        style: const TextStyle(fontSize: 14, color: Colors.black),

        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            MyApp.setLocale(context, newLocale);
          }
        },

        items:  [
          DropdownMenuItem(
            value: Locale('en', 'CA'),
            child: Text(loc.translate('EN')!),
          ),
          DropdownMenuItem(
            value: Locale('zh'),
            child: Text(loc.translate('ZH')!),
          ),
          DropdownMenuItem(
            value: Locale('ar'),
            child: Text('AR'),
          ),
          DropdownMenuItem(
            value: Locale('fr'),
            child: Text('FR'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('Main Menu')!),
        actions: [
          _buildLanguageDropdown(context),
        ],
      ),
      body: Center(
        child: LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 600;

              if (isMobile) {
                // 手機排法：Wrap 兩行兩個按鈕
                return Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    ElevatedButton(
                        child: Text(loc.translate('Customer Page')!), onPressed: () {
                          Navigator.push(context,
                        MaterialPageRoute(
                          builder: (_) => CustomerPage(database: database),
                        ),);
                    }),
                    ElevatedButton(
                        child: Text(loc.translate('Cars for sale')!), onPressed: () {
                          Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CarListPage()),
                    );}),
                    ElevatedButton(
                        child: Text(loc.translate('Boats for sale')!), onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const BoatListPage()),
                      );}),
                    ElevatedButton(
                        child: Text(loc.translate('Purchase offers')!), onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OfferPage(database: offerDb),
                      ),
                    );}),
                  ],
                );
              }
              // 桌機／平板排法：維持你的 Row
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text(loc.translate('Customer Page')!),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CustomerPage(database: database),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: Text(loc.translate('Cars for sale')!),
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CarListPage()),
                    );},
                  ),
                  ElevatedButton(
                    child: Text(loc.translate('Boats for sale')!),
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const BoatListPage()),
                    );},
                  ),
                  ElevatedButton(
                    child: Text(loc.translate('Purchase offers')!),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OfferPage(database: offerDb),
                      ),
                    );},
                  ),
                ],
              );
            },
        ),
      ),
    );
  }
}
