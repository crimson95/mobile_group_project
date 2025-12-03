import 'package:flutter/material.dart';
import 'offer_database.dart';
import 'offer_dao.dart';
import 'offer.dart';
import '../../AppLocalizations.dart';
import 'offer_form_page.dart';

/// Detail screen used on phones (navigated to from the list).
class OfferDetailPage extends StatefulWidget {
  final OfferDatabase database;
  final Offer offer;

  const OfferDetailPage({
    super.key,
    required this.database,
    required this.offer,
  });

  @override
  State<OfferDetailPage> createState() => _OfferDetailPageState();
}

class _OfferDetailPageState extends State<OfferDetailPage> {
  late Offer _offer;
  late OfferDAO _offerDAO;

  @override
  void initState() {
    super.initState();
    _offer = widget.offer;
    _offerDAO = widget.database.offerDAO;
  }

  Future<void> _editOffer() async {
    final updated = await Navigator.push<Offer?>(
      context,
      MaterialPageRoute(
        builder: (_) => OfferFormPage(
          database: widget.database,
          existingOffer: _offer,
        ),
      ),
    );

    if (updated != null) {
      setState(() {
        _offer = updated;
      });
      // 告訴上一頁「有更新」
      Navigator.pop(context, 'updated');
    }
  }

  Future<void> _deleteOffer() async {
    final loc = AppLocalizations.of(context)!;

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
      await _offerDAO.deleteOffer(_offer);
      Navigator.pop(context, 'deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('offers_title') ?? 'Purchase offers'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ID: ${_offer.id ?? '-'}',
                  style: const TextStyle(fontSize: 22)),
              Text('${loc.translate('customer_id')}: ${_offer.customerId}',
                  style: const TextStyle(fontSize: 22)),
              Text('${loc.translate('item_id')}: ${_offer.itemId}',
                  style: const TextStyle(fontSize: 22)),
              Text(
                  '${loc.translate('price_offered') ?? 'Price offered'}: \$${_offer.priceOffered.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 22)),
              Text(
                  '${loc.translate('date_of_offer') ?? 'Date of offer'}: ${_offer.dateOfOffer}',
                  style: const TextStyle(fontSize: 22)),
              Text(
                '${loc.translate('Accepted')}: ${_offer.accepted ? '${loc.translate('Yes')}' : '${loc.translate('No')}'}',
                style: const TextStyle(fontSize: 22),
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
      ),
    );
  }
}
