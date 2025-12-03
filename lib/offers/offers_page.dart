import 'package:flutter/material.dart';
import 'offer_database.dart';
import 'offer.dart';
import '../../AppLocalizations.dart';
import 'offer_list_page.dart';
import 'offer_detail_tablet.dart';
import 'offer_form_page.dart';

/// Top-level page for managing purchase offers.
/// - Shows AppBar + FAB
/// - On wide screens: List + Details side-by-side
/// - On phones: only the list is visible
class OfferPage extends StatefulWidget {
  final OfferDatabase database;

  const OfferPage({super.key, required this.database});

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  final GlobalKey<OfferListPageState> _listKey = GlobalKey<OfferListPageState>();

  Offer? _selectedOffer;

  Future<void> _openNewOfferForm() async {
    final loc = AppLocalizations.of(context)!;

    final Offer? created = await Navigator.push<Offer?>(
      context,
      MaterialPageRoute(
        builder: (_) => OfferFormPage(
          database: widget.database,
          existingOffer: null,
        ),
      ),
    );

    if (created != null) {
      // Reload list and select the newly created offer (on tablet).
      _listKey.currentState?.reloadOffers();
      setState(() {
        _selectedOffer = created;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc.translate('offer_added') ?? 'Offer added.',
          ),
        ),
      );
    }
  }

  /// Called when an offer was updated in a form or detail page.
  void _onOfferUpdated(Offer updated) {
    _listKey.currentState?.reloadOffers();
    setState(() {
      _selectedOffer = updated;
    });
  }

  /// Called when an offer was deleted.
  void _onOfferDeleted() {
    _listKey.currentState?.reloadOffers();
    setState(() {
      _selectedOffer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final bool isWide = size.width > size.height && size.width > 720;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('offers_title') ?? 'Purchase offers'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openNewOfferForm,
        child: const Icon(Icons.add),
      ),
      body: isWide
          ? Row(
        children: [
          Expanded(
            flex: 2,
            child: OfferListPage(
              key: _listKey,
              database: widget.database,
              isWide: true,
              onOfferSelected: (offer) {
                setState(() {
                  _selectedOffer = offer;
                });
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: OfferDetailTablet(
              database: widget.database,
              offer: _selectedOffer,
              onOfferUpdated: _onOfferUpdated,
              onOfferDeleted: _onOfferDeleted,
            ),
          ),
        ],
      )
          : OfferListPage(
        key: _listKey,
        database: widget.database,
        isWide: false,
        onOfferSelected: null, // phone: navigation handled in list page
      ),
    );
  }
}
