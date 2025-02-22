import 'package:fahrradworkshop/betreiberui/einnahme.dart';
import 'package:flutter/material.dart';

class RequestBetreiber extends StatefulWidget {
  @override
  _RequestBetreiberState createState() => _RequestBetreiberState();
}

class _RequestBetreiberState extends State<RequestBetreiber> {
  List<Map<String, dynamic>> allSparepart = company.getAllSparePart();

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> requestedSpareparts = allSparepart.where((part) => part['isRequested']).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Request Betreiber'),
      ),
      body: ListView.builder(
        itemCount: requestedSpareparts.length,
        itemBuilder: (context, index) {
          return _buildSparePartCard(requestedSpareparts[index]);
        },
      ),
    );
  }

  Widget _buildSparePartCard(Map<String, dynamic> sparePart) {
    Color stockColor = Colors.red;
    Color clickColor = Colors.green;

    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(sparePart['name']),
        subtitle: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'OUT OF STOCK ',
                style: TextStyle(color: stockColor, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' - ',
              ),
              TextSpan(
                text: 'Please click to close the request',
                style: TextStyle(color: clickColor),
              ),
            ],
          ),
        ),
        onTap: () {
          _showConfirmationDialog(sparePart);
        },
      ),
    );
  }

  void _showConfirmationDialog(Map<String, dynamic> sparePart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Closure'),
          content: Text('The request for ${sparePart['name']} will be closed. Are you sure?'),
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
                  sparePart['isRequested'] = false;
                });
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}