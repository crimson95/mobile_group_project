import 'package:flutter/material.dart';
import 'package:floor/floor.dart';
import 'dao/customerDAO.dart';
import 'dao/customerDatabase.dart';
import 'model/customer.dart';
import 'pages/CustomerListPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorCustomerDatabase.databaseBuilder('customer.db').build();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.database});
  final CustomerDatabase database;

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
          children: <Widget>[
            ElevatedButton(child: const Text("Customer List"), onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => CustomerListPage(database: database),
              ),
            );
          },
        ),
            ElevatedButton(child: Text("Cars for sale"), onPressed: (){
            }),
            ElevatedButton(child: Text("Boats for sale"), onPressed: (){
            }),
            ElevatedButton(child: Text("Purchase offer"), onPressed: (){
            })
          ],
        ),
      ),
    );
  }
}
