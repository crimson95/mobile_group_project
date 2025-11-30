import 'package:flutter/material.dart';
import 'CarPage/pages/carlistpage.dart';
import 'CustomerList/dao/customerDatabase.dart';
import 'CustomerList/pages/CustomerPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorCustomerDatabase
      .databaseBuilder('customer.db')
      .build();

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final CustomerDatabase database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Final project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
      ),
      home: MainMenu(database: database),
    );
  }
}

class MainMenu extends StatelessWidget {
  final CustomerDatabase database;

  const MainMenu({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Menu')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: const Text("Customer List"),
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
              child: const Text("Cars for sale"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CarListPage()),
                );
              },
            ),
            ElevatedButton(
              child: const Text("Boats for sale"),
              onPressed: () {},
            ),
            ElevatedButton(
              child: const Text("Purchase offer"),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
