import 'package:fahrradworkshop/classes/company.dart';
import 'package:fahrradworkshop/global.dart';
import 'package:flutter/material.dart';

Company company = Globals.company;

class RequestMitarbeiterTab extends StatefulWidget {
  int buchungid;

  RequestMitarbeiterTab({
    Key? key,
    required this.buchungid,
  }) : super(key: key);

  @override
  _RequestMitarbeiterTabState createState() => _RequestMitarbeiterTabState();
}

class _RequestMitarbeiterTabState extends State<RequestMitarbeiterTab> {
  List<String> parts = ["SpareParts", "Service"];
  List<List<Map<String, dynamic>>> partsData = [
    [
      {"title": "Road Bike Tires", "isChecked": false, "price": 60},
      {"title": "Mountain Bike Tires", "isChecked": false, "price": 20},
      {"title": "Brake Levers", "isChecked": false, "price": 10},
      {"title": "Handlebar Grips", "isChecked": false, "price": 10},
      {"title": "Saddles", "isChecked": false, "price": 40},
      {"title": "Front Lights", "isChecked": false, "price": 17},
      {"title": "Rear Lights", "isChecked": false, "price": 17},
    ],
    [
      {"title": "Brake Adjustment", "isChecked": false, "price": 20},
      {"title": "Basic Tune-Up", "isChecked": false, "price": 30},
      {"title": "Tire Inflation", "isChecked": false, "price": 10},
      {"title": "Frame Alignment", "isChecked": false, "price": 30},
    ],
  ];

  late List<Map<String, dynamic>> chosenSpareParts;
  late List<Map<String, dynamic>> chosenServices;

  // Hypothetical data
  Map<String, dynamic> bookingInfo = {};

  TextEditingController messageController = TextEditingController();
  TextEditingController additionalExplanationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chosenSpareParts = company.getBuchung(widget.buchungid)["SparePart"];
    chosenServices = company.getBuchung(widget.buchungid)["Service"];
    _filterChosenItems();
    bookingInfo = company.getBookingInfo(widget.buchungid);
    messageController.text = bookingInfo['nachricht'];
    additionalExplanationController.text = bookingInfo['nachrichtVonKunden'];
  }

  void _filterChosenItems() {
    partsData[0].removeWhere((item) =>
        chosenSpareParts.any((chosenItem) => chosenItem['title'] == item['title']));
    partsData[1].removeWhere((item) =>
        chosenServices.any((chosenItem) => chosenItem['title'] == item['title']));
  }

  void _sendMessage() {
    setState(() {
      bookingInfo['statusNachricht'] = 'sent';
    });
  }

  void _makeAnotherMessage() {
    setState(() {
      bookingInfo['nachricht'] = '';
      bookingInfo['responseFromCustomer'] = 'noInfo';
      bookingInfo['nachrichtVonKunden'] = '';
      bookingInfo['statusNachricht'] = 'notSent';
      bookingInfo['responseCheck'] = false;
      messageController.text = bookingInfo['nachricht'];
      additionalExplanationController.text = bookingInfo['nachrichtVonKunden'];
    });
  }

  Future<void> _confirmSendMessage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss the dialog.
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Send Message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to send this message to the customer?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                _sendMessage();
                Navigator.of(context).pop();
              },
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
      title: Text('Request Approval from Customer'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Ask the customer for approval:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.green[100],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: messageController,
              maxLines: null,
              readOnly: bookingInfo['statusNachricht'] == 'sent',
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Write your message here...',
              ),
              onChanged: (text) {
                bookingInfo['nachricht'] = text;
              },
            ),
          ),
          const SizedBox(height: 8.0),
          if (bookingInfo['statusNachricht'] != 'sent')
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  _confirmSendMessage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  'Send to Customer',
                  style: TextStyle(color: Colors.black),
                  ),
              ),
            ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Response from Customer:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  bookingInfo['responseFromCustomer'],
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: bookingInfo['responseFromCustomer'] == "approved"
                        ? Colors.green
                        : bookingInfo['responseFromCustomer'] == "rejected"
                            ? Colors.red
                            : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Additional Explanation from Customer:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: additionalExplanationController,
              readOnly: true,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Additional explanation will be here...',
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              _makeAnotherMessage();
            },
            child: Text('Make Another Message'),
          ),
        ],
      ),
    ),
  );
}
}