import 'package:flutter/material.dart';
import 'offer_database.dart';
import 'offer_dao.dart';
import 'offer.dart';
import '../../AppLocalizations.dart';
import 'offer_detail_page.dart';

class OfferListPage extends StatefulWidget {
  final OfferDatabase database;

  /// True when displayed side-by-side with a tablet detail panel.
  final bool isWide;

  /// Called when an offer is selected in wide mode.
  final ValueChanged<Offer>? onOfferSelected;

  const OfferListPage({
    super.key,
    required this.database,
    required this.isWide,
    this.onOfferSelected,
  });

  @override
  OfferListPageState createState() => OfferListPageState();
}

class OfferListPageState extends State<OfferListPage> {
  late OfferDAO _offerDAO;
  List<Offer> _offers = [];

  @override
  void initState() {
    super.initState();
    _offerDAO = widget.database.offerDAO;
    reloadOffers();
  }

  /// Reloads all offers from the database.
  Future<void> reloadOffers() async {
    final list = await _offerDAO.getAllOffers();
    setState(() {
      _offers = list;
    });
  }

  Future<void> _openDetailPhone(Offer offer) async {
    final result = await Navigator.push<String?>(
      context,
      MaterialPageRoute(
        builder: (_) => OfferDetailPage(
          database: widget.database,
          offer: offer,
        ),
      ),
    );

    // If detail page reports a change (updated or deleted), reload the list.
    if (result == 'updated' || result == 'deleted') {
      await reloadOffers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (_offers.isEmpty) {
      return Center(
        child: Text(
          loc.translate('no_offers_yet') ?? 'No offers yet.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: _offers.length,
      itemBuilder: (context, index) {
        final o = _offers[index];
        return ListTile(
          title: Text(
            'ID ${o.id ?? '-'}  \$${o.priceOffered.toStringAsFixed(2)}',
          ),
          subtitle: Text(
            '${loc.translate('customer')}: ${o.customerId}, ${loc.translate('item')}: ${o.itemId}\n'
            '${loc.translate('date_of_offer') ?? 'Date of offer'}: ${o.dateOfOffer}',
          ),
          trailing: Icon(
            o.accepted ? Icons.check_circle : Icons.hourglass_empty,
            color: o.accepted ? Colors.green : Colors.orange,
          ),
          onTap: () {
            if (widget.isWide && widget.onOfferSelected != null) {
              widget.onOfferSelected!(o);
            } else {
              _openDetailPhone(o);
            }
          },
        );
      },
    );
  }
}
