import 'package:flutter/material.dart';
import '../../model/boat.dart';
import '../../dao/boatDatabase.dart';
import 'boat_add_page.dart';
import 'boat_details_page.dart';
import 'package:final_group_project/localization/app_localizations.dart';



class BoatListPage extends StatefulWidget {
  const BoatListPage({super.key});

  @override
  State<BoatListPage> createState() => _BoatListPageState();
}

class _BoatListPageState extends State<BoatListPage> {
  List<Boat> boats = [];

  @override
  void initState() {
    super.initState();
    _loadBoats();
  }

  Future<void> _loadBoats() async {
    final database =
    await $FloorBoatDatabase.databaseBuilder('boat_database.db').build();
    final dao = database.boatDAO;

    final list = await dao.findAllBoats();
    setState(() {
      boats = list;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boats for Sale'),
      ),
      bottomNavigationBar: boats.isEmpty
          ? null
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BoatAddPage()),
            );
            _loadBoats();
          },
          icon: const Icon(Icons.add),
          label: const Text(
            "Add Boat",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
      body: boats.isEmpty
          ? Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BoatAddPage()),
            );
            _loadBoats();
          },
          icon: const Icon(Icons.add, size: 28),
          label: const Text(
            "Add Your First Boat",
            style: TextStyle(fontSize: 20),
          ),
        ),
      )
          : ListView.builder(
        itemCount: boats.length,
        itemBuilder: (context, index) {
          final boat = boats[index];
          return ListTile(
            title: Text(
                '${boat.yearBuilt} • ${boat.powerType} • ${boat.lengthMeters
                    .toStringAsFixed(1)} m'),
            subtitle: Text('\$${boat.price.toStringAsFixed(2)}'),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BoatDetailsPage(boat: boat),
                ),
              );
              _loadBoats();
            },
          );
        },
      ),
    );
  }
}