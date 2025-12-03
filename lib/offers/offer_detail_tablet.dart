import 'package:flutter/material.dart';
import 'offer_database.dart';
import 'offer_dao.dart';
import 'offer.dart';
import '../../AppLocalizations.dart';
import 'offer_form_page.dart';

/// Detail panel used in tablet/desktop mode (side-by-side with the list).
class OfferDetailTablet extends StatefulWidget {
  final OfferDatabase database;
  final Offer? offer;

  /// Called when the offer was updated.
  final ValueChanged<Offer> onOfferUpdated;

  /// Called when the offer was deleted.
  final VoidCallback onOfferDeleted;

  const OfferDetailTablet({
    super.key,
    required this.database,
    required this.offer,
    required this.onOfferUpdated,
    required this.onOfferDeleted,
  });

  @override
  State<OfferDetailTablet> createState() => _OfferDetailTabletState();
}

class _OfferDetailTabletState extends State<OfferDetailTablet> {
  late OfferDAO _offerDAO;

  @override
  void initState() {
    super.initState();
    _offerDAO = widget.database.offerDAO;
  }

  Future<void> _editOffer() async {
    final loc = AppLocalizations.of(context)!;
    final offer = widget.offer;
    if (offer == null) return;

    final updated = await Navigator.push<Offer?>(
      context,
      MaterialPageRoute(
        builder: (_) => OfferFormPage(
          database: widget.database,
          existingOffer: offer,
        ),
      ),
    );

    if (updated != null) {
      widget.onOfferUpdated(updated);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(loc.translate('offer_updated') ?? 'Offer updated.'),
        ),
      );
    }
  }

  Future<void> _deleteOffer() async {
    final loc = AppLocalizations.of(context)!;
    final offer = widget.offer;
    if (offer == null) return;

    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('delete_offer') ?? 'Delete offer?'),
        content: Text(
          loc.translate('delete_offer_msg') ??
              'Are you sure you want to delete this offer?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.translate('Cancel') ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.translate('Delete') ?? 'Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await _offerDAO.deleteOffer(offer);
      widget.onOfferDeleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final offer = widget.offer;

    if (offer == null) {
      return Center(
        child: Text(
          loc.translate('Please select an offer from the list.') ??
              'Please select an offer from the list.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ID: ${offer.id ?? '-'}',
                style: const TextStyle(fontSize: 24)),
            Text('${loc.translate('Customer ID')}: ${offer.customerId}',
                style: const TextStyle(fontSize: 24)),
            Text('${loc.translate('Item ID')}: ${offer.itemId}',
                style: const TextStyle(fontSize: 24)),
            Text(
                '${loc.translate('price_offered') ?? 'Price offered'}: \$${offer.priceOffered.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24)),
            Text(
                '${loc.translate('date_of_offer') ?? 'Date of offer'}: ${offer.dateOfOffer}',
                style: const TextStyle(fontSize: 24)),
            Text(
              '${('Accepted')}: ${offer.accepted ? '${('Yes')}' : '${('No')}'}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _editOffer,
              child: Text(
                  loc.translate('update_offer') ?? 'Update offer'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _deleteOffer,
              child: Text(loc.translate('Delete') ?? 'Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
