import 'package:flutter/material.dart';
import '../../model/boat.dart';
import '../../dao/boatDatabase.dart';
import 'boat_add_page.dart';
import 'boat_details_page.dart';

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
        title: const Text('Boats for sale'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // go to Add page, then reload when we come back
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BoatAddPage()),
          );
          _loadBoats();
        },
        child: const Icon(Icons.add),
      ),
      body: boats.isEmpty
          ? const Center(child: Text('No boats yet'))
          : ListView.builder(
        itemCount: boats.length,
        itemBuilder: (context, index) {
          final boat = boats[index];
          return ListTile(
            title: Text(
                '${boat.yearBuilt} • ${boat.powerType} • ${boat.lengthMeters.toStringAsFixed(1)} m'),
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
