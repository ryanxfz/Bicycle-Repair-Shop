import 'package:fahrradworkshop/classes/company.dart';
import 'package:fahrradworkshop/global.dart';
import 'package:flutter/material.dart';

Company company = Globals.company;

class RequestCustomer extends StatefulWidget {
  const RequestCustomer({Key? key}) : super(key: key);

  @override
  _RequestCustomerState createState() => _RequestCustomerState();
}

class _RequestCustomerState extends State<RequestCustomer> {
  List<String> buchungIds = ["--Select your Booking ID--"] + company.getAllBuchungId();
  String selectedBuchungId = ""; // Default selection

  Map<String, dynamic> bookingInfo = {
      "bookingID" : 0,
      "nachricht": " ",
      "responseFromCustomer": "noInfo", // Possible values: approved, rejected, pending, noInfo
      "nachrichtVonKunden": " ", // Initially empty
      "responseCheck": false,
      "statusNachricht": "notSent"
    };
  TextEditingController responseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (buchungIds.isNotEmpty) {
      // Initialize bookingInfo with the first buchungid if available
      selectedBuchungId = buchungIds[0];
      responseController.text = bookingInfo['nachrichtVonKunden'];
    }
  }

  void _confirmResponse(bool approved) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Response'),
          content: Text('Are you sure you want to ${approved ? 'approve' : 'reject'} this request?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (!bookingInfo['responseCheck'] && bookingInfo['statusNachricht'] == 'sent') {
                    // Update responseFromCustomer and nachrichtVonKunden if responseCheck is false and statusNachricht is sent
                    bookingInfo['responseFromCustomer'] = approved ? 'approved' : 'rejected';
                    bookingInfo['nachrichtVonKunden'] = responseController.text;
                    bookingInfo['responseCheck'] = true;
                  }
                  Navigator.of(context).pop();
                });
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _onBuchungIdChanged(String? newValue) {
     setState(() {
      selectedBuchungId = newValue!;
      if (selectedBuchungId == "--Select your Booking ID--") {
        bookingInfo = {
          "bookingID": 0,
          "nachricht": " ",
          "responseFromCustomer": "noInfo",
          "nachrichtVonKunden": " ",
          "responseCheck": false,
          "statusNachricht": "notSent"
        };
      } else {
        bookingInfo = company.getBookingInfowithString(selectedBuchungId);
      }
      responseController.text = bookingInfo['nachrichtVonKunden'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Response from Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedBuchungId,
              items: buchungIds.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('Booking ID: $value'),
                );
              }).toList(),
              onChanged: _onBuchungIdChanged,
              isExpanded: true,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Message from Employee:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                bookingInfo['nachricht'],
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Response:',
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
                controller: responseController,
                readOnly: bookingInfo['statusNachricht'] == 'sent' && bookingInfo['responseCheck'],
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write your response here...',
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: bookingInfo['statusNachricht'] == 'sent' && !bookingInfo['responseCheck']
                      ? () {
                          _confirmResponse(true);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'Approve',
                    style: TextStyle(color: Colors.black),
                    ),
                ),
                ElevatedButton(
                  onPressed: bookingInfo['statusNachricht'] == 'sent' && !bookingInfo['responseCheck']
                      ? () {
                          _confirmResponse(false);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'Reject',
                    style: TextStyle(color: Colors.black),
                    ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}