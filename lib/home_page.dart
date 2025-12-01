import 'package:flutter/material.dart';
import 'offers/offers_page.dart';
import 'l10n/app_localizations.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // This is just a simple static title for the whole group app
        title: const Text('Group Project Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const OffersPage(),
              ),
            );
          },
          // Button text for your module
          child: const Text('Purchase Offers'),
        ),
      ),
    );
  }
}
