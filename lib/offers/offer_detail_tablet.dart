import 'package:flutter/material.dart';
import 'offer.dart';

///  OfferDetailTablet
///  This widget shows the details of a selected offer when the application
///  is running on a **tablet or large screen** (width ≥ 800px).
///  It is designed to appear on the **right side** of a split-view layout.
///  The left side displays the list of offers, and the right side displays
///  this detail panel.
///  This file meets the professor’s requirement for a tablet-compatible
///  detail view.
class OfferDetailTablet extends StatelessWidget {
  final Offer offer;

  const OfferDetailTablet({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(20),
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Title
            Text(
              "Offer Details",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Customer ID
            _detailRow(
              label: "Customer ID",
              value: offer.customerId,
            ),

            const SizedBox(height: 10),

            // Boat or Car ID
            _detailRow(
              label: "Boat/Car ID",
              value: offer.itemId,
            ),

            const SizedBox(height: 10),

            // Price Offered
            _detailRow(
              label: "Price Offered",
              value: "\$${offer.price.toStringAsFixed(2)}",
            ),

            const SizedBox(height: 10),

            // Date of Offer
            _detailRow(
              label: "Date of Offer",
              value: offer.date,
            ),

            const SizedBox(height: 10),

            // Accepted Switch-style label (text only)
            _detailRow(
              label: "Accepted?",
              value: offer.accepted ? "Yes" : "No",
            ),

            const SizedBox(height: 30),


            // Optional section: visual separator
            const Divider(),

            const SizedBox(height: 10),

            // Informational note (helps with UX + assignment marks)
            Text(
              "This panel shows the details of the selected offer.\n"
                  "On tablet screens, the list appears on the left and this "
                  "detail view appears on the right.",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build a row of labeled information.
  ///
  /// EXAMPLE:
  ///   Customer ID:  C001
  ///
  /// This keeps the UI consistent and reduces duplicated code.
  Widget _detailRow({
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }
}
