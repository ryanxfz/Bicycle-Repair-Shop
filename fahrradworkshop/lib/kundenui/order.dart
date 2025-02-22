import 'package:fahrradworkshop/classes/company.dart';
import 'package:fahrradworkshop/global.dart';
import 'package:flutter/material.dart';
import 'dart:math'; //for randomised Buchung ID

Company company = Globals.company;

class Order extends StatefulWidget {
  final String kunden;

  Order({Key? key, required this.kunden}) : super(key: key);

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  double totalPrice = 0;
  List<String> parts = ["SpareParts", "Service"];

  List<List<Map<String, dynamic>>> partsData = [
    // Spare Parts
    [
      {"title": "Road Bike Tires", "isChecked": false, "price": 60},
      {"title": "Mountain Bike Tires", "isChecked": false, "price": 20},
      {"title": "Brake Levers", "isChecked": false, "price": 10},
      {"title": "Handlebar Grips", "isChecked": false, "price": 10},
      {"title": "Saddles", "isChecked": false, "price": 40},
      {"title": "front Lights", "isChecked": false, "price": 17},
      {"title": "rear Lights", "isChecked": false, "price": 17},
    ],
    // Services
    [
      {"title": "Brake Adjustment", "isChecked": false, "price": 20},
      {"title": "Basic Tune-Up", "isChecked": false, "price": 30},
      {"title": "Tire Inflation", "isChecked": false, "price": 10},
      {"title": "Frame Alignment", "isChecked": false, "price": 30},
    ],
  ];

  final TextEditingController _notesController = TextEditingController();
  String beschreibung = ''; // Variable to store additional description

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double _calculateTotalPrice() {
    double totalPrice = 0;
    for (var section in partsData) {
      for (var item in section) {
        if (item["isChecked"] == true) {
          totalPrice += item["price"];
        }
      }
    }
    return totalPrice;
  }

  void _showConfirmationDialog() {
    List<Map<String, dynamic>> selectedSpareParts = [];
    List<Map<String, dynamic>> selectedServices = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Order'),
          content: const Text(
              'Your order will be created. Are you sure you want to proceed?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                selectedSpareParts.clear();
                selectedServices.clear();

                for (int partIndex = 0; partIndex < partsData.length; partIndex++) {
                  for (int itemIndex = 0; itemIndex < partsData[partIndex].length; itemIndex++) {
                    if (partsData[partIndex][itemIndex]["isChecked"]) {

                      Map<String, dynamic> newItem = Map<String, dynamic>.from(partsData[partIndex][itemIndex]);
                      newItem["isChecked"] = false;
                      newItem["workstatus"] = false;

                      if (partIndex == 0) {
                        // Spare Parts
                        selectedSpareParts.add(newItem);
                      } else if (partIndex == 1) {
                        // Services
                        selectedServices.add(newItem);
                      }
                    }
                  }
                }

                beschreibung = _notesController.text;

                //generate random ID
                var random = Random();
                int id = random.nextInt(9000) + 1000; //random number von 1000-9999

                company.addBuchungId(id);

                Map<String, dynamic> newOrder = {
                  'id': id,
                  'kunde': widget.kunden,
                  'stat': "Confirmed",
                  'beschreibung': beschreibung,
                  'price': _calculateTotalPrice(),
                  'SparePart': selectedSpareParts,
                  'Service': selectedServices
                };
                Map<String, dynamic> bookingInfo = {
                  "bookingID" : id,
                  "nachricht": " ",
                  "responseFromCustomer": "noInfo", // Possible values: approved, rejected, pending, noInfo
                  "nachrichtVonKunden": " ", // Initially empty
                  "responseCheck": false,
                  "statusNachricht": "notSent" // Possible values: sent, notSent
                };
                company.addBookinginfo(bookingInfo);

                print('id: ${newOrder['id']}');

                company.addBuchungen(newOrder);
                Navigator.of(context).pop(); 

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Order Created'),
                      content: Text('Your order with ID: $id has been created.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );

              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Parts'),
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: parts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    leading: const CircleAvatar(),
                    title: Text(parts[index]),
                    subtitle: const Text("Tap to expand"),
                    children: partsData[index].map((data) {
                      return CheckboxListTile(
                        title: Text(data["title"]),
                        value: data["isChecked"],
                        onChanged: (bool? value) {
                          setState(() {
                            data["isChecked"] = value!;
                            totalPrice = _calculateTotalPrice();
                          });
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _notesController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Additional Description',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: _showConfirmationDialog,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
