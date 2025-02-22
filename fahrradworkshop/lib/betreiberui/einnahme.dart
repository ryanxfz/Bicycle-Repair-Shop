import 'package:fahrradworkshop/betreiberui/pricedetailscreen.dart';
import 'package:fahrradworkshop/classes/company.dart';
import 'package:fahrradworkshop/global.dart';
import 'package:flutter/material.dart';

Company company = Globals.company;

class Einnahme extends StatelessWidget {
  const Einnahme({Key? key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> partsData = company.getAllBuchung();
    double totalPrice = partsData.fold(0.0, (sum, item) => sum + item['price']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Income'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: partsData.length,
              itemBuilder: (context, index) {
                final part = partsData[index];
                return Card(
                  child: ListTile(
                    title: Text("Booking: ${part['id'].toString()}"),
                    subtitle: const Text("Tap to See Details"),
                    trailing: Text(
                      "\u20AC ${part['price'].toString()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PriceDetailScreen(
                            id: part['id'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.blueGrey.withOpacity(0.2),
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Total Price: \u20AC ${totalPrice.toStringAsFixed(2)}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
