import 'package:flutter/material.dart';
import '../model/car.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import '../../AppLocalizations.dart';

/// A widget that displays summarized information about a [Car] object,
/// including its year, make, model, price, and ID.
///
/// The card also provides an optional delete button used to trigger
/// an external delete handler.
class CarCard extends StatelessWidget {
  /// The car data to display within this card.
  final Car car;

  /// Callback executed when the delete icon is pressed.
  ///
  /// This value may be null if the delete button should perform no action.
  final VoidCallback? onDelete;

  /// Creates a new [CarCard] that presents information about a car.
  const CarCard({
    super.key,
    required this.car,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Container(
                height: 80,
                width: 80,
                color: Colors.grey,
                child: const Icon(Icons.directions_car),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${car.year} ${car.make} ${car.model}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("\$${car.price}"),
                  Text(
                    "${loc?.translate('car_id') ?? 'ID'} #${car.id}",
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
