import 'package:flutter/material.dart';
import 'pages/boats/boat_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boats App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BoatListPage(), // start on your Boats screen
    );
  }
}
