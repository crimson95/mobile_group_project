import 'package:flutter/material.dart';
import 'offer.dart';
import 'offer_dao.dart';
import 'offer_form_page.dart';
/// This screen displays all purchase offers currently stored in the database.
/// It acts as the “list page” required by the assignment:
/// - Shows items from the database
/// - Lets the user tap an item to view/update/delete it
/// - Has a floating button to add a brand-new offer
/// Every time we return from the form page, we refresh the list so the
/// user always sees the most up-to-date information.
class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  /// Local in-memory list of offers.
  /// This is only used for displaying the list; the real data lives in SQLite.
  List<Offer> offers = [];

  @override
  void initState() {
    super.initState();
    _loadOffers(); // Load database items as soon as the page opens
  }
  /// Fetches all offers from the database using OfferDao.
  ///
  /// After retrieving them, we call `setState()` so Flutter rebuilds the UI
  /// and shows the updated list immediately.
  Future<void> _loadOffers() async {
    offers = await OfferDao.instance.getOffers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top bar of the screen — required “ActionBar”.
      appBar: AppBar(                    // ACTION BAR HERE
        title: const Text("Purchase Offers"),
      ),
      // Floating button >> opens the form page to add a new offer.
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const OfferFormPage(),
            ),
          );
          _loadOffers();
        },
        child: const Icon(Icons.add),
      ),
      // The main list of offers.
      body: ListView.builder(
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return ListTile(
            // Display the offer summary so the user gets quick information.
          title: Text("Offer: \$${offer.price.toStringAsFixed(2)}"),
            subtitle: Text("Customer ID: ${offer.customerId}"),
            // When tapped >> open the same form, but with existing data
            // so the user can update or delete it.
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OfferFormPage(offer: offer),
                ),
              );
              _loadOffers();
            },
          );
        },
      ),
    );
  }
}
