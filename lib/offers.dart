import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Offers & Coupons'),
      ),
      body:  OffersList(),
    );
  }
}

class OffersList extends StatelessWidget {
  final List<OfferItem> offers = [
    OfferItem(
      title: '50% Off on Blockbuster Movies',
      description: 'Get 50% off on tickets for the latest blockbuster movies.',
      code: 'BLOCKBUSTER50',
    ),
    OfferItem(
      title: 'Buy 1 Get 1 Free',
      description: 'Buy one ticket and get another one free.',
      code: 'B1G1MOVIE',
    ),
    // Add more offers here
  ];

   OffersList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                offer.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(offer.description),
              trailing: ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: offer.code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Coupon code copied: ${offer.code}')),
                  );
                },
                child: const Text('Copy Code'),
              ),
            ),
          ),
        );
      },
    );
  }
}

class OfferItem {
  final String title;
  final String description;
  final String code;

  OfferItem({required this.title, required this.description, required this.code});
}
