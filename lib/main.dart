import 'package:flutter/material.dart';
import 'CarPage/pages/carlistpage.dart';
import 'CustomerList/dao/customerDatabase.dart';
import 'CustomerList/pages/CustomerPage.dart';
import 'AppLocalizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorCustomerDatabase
      .databaseBuilder('customer.db')
      .build();

  runApp(MyApp(database: database));
}

class MyApp extends StatefulWidget {
  final CustomerDatabase database;

  const MyApp({super.key, required this.database});

  // ⭐ 切换语言
  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLanguage(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale("en", "US");

  void changeLanguage(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Final Project',
      locale: _locale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // 加这一行更保险
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
      ),
      home: MainMenu(database: widget.database),
    );
  }
}

class MainMenu extends StatelessWidget {
  final CustomerDatabase database;

  const MainMenu({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc?.translate('main_menu_title') ?? 'Main Menu',
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text(
                loc?.translate('button_customer_list') ?? 'Customer List',
              ),
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
              child: Text(
                loc?.translate('button_cars_for_sale') ?? 'Cars for sale',
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CarListPage()),
                );
              },
            ),
            ElevatedButton(
              child: Text(
                loc?.translate('button_boats_for_sale') ?? 'Boats for sale',
              ),
              onPressed: () {},
            ),
            ElevatedButton(
              child: Text(
                loc?.translate('button_purchase_offer') ?? 'Purchase offer',
              ),
              onPressed: () {},
            ),

            // ⭐ 语言切换按钮
            ElevatedButton(
              child: const Text("中文"),
              onPressed: () {
                MyApp.setLocale(context, const Locale("zh", "CN"));
              },
            ),
            ElevatedButton(
              child: const Text("English"),
              onPressed: () {
                MyApp.setLocale(context, const Locale("en", "US"));
              },
            ),
          ],
        ),
      ),
    );
  }
}
