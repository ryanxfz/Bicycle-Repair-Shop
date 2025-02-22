import 'package:flutter/material.dart';
import 'package:fahrradworkshop/global.dart';

class PriceDetailScreen extends StatefulWidget {
  final int id;

  PriceDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  _PriceDetailScreenState createState() => _PriceDetailScreenState();
}

class _PriceDetailScreenState extends State<PriceDetailScreen> {
  // Temporary data for demonstration
  List<Map<String, dynamic>> priceDetails = [];
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    // Retrieve booking details from company and populate priceDetails
    var booking = Globals.company.getBuchung(widget.id);
    if (booking != null) {
      priceDetails.addAll(booking["SparePart"] ?? []);
      priceDetails.addAll(booking["Service"] ?? []);
      calculateTotalPrice();
    } else {
      // Handle the case where booking is null (optional)
      // You may want to show an error message or handle it differently
    }
  }

  // Method to calculate total price
  void calculateTotalPrice() {
    int total = 0;
    for (var item in priceDetails) {
      total += item["price"] as int; // Explicitly cast to int
    }
    setState(() {
      totalPrice = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Price Detail'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
  itemCount: priceDetails.length,
  itemBuilder: (context, index) {
    String name = priceDetails[index]["title"] ?? ""; // Use "title" instead of "name"
    int price = priceDetails[index]["price"] as int ?? 0; // Handle null price

    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(name), // Display the name (using "title" key)
        trailing: Text(
          '\u20AC $price',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  },
),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Total: \u20AC $totalPrice',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}