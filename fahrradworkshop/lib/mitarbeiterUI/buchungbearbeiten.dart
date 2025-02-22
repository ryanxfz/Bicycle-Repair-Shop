import 'package:fahrradworkshop/classes/company.dart';
import 'package:fahrradworkshop/global.dart';
import 'package:fahrradworkshop/mitarbeiterui/buchungdetail/tabbuchungdetails.dart';
import 'package:flutter/material.dart';

Company company = Globals.company;

class BuchungArbeit extends StatefulWidget {
  const BuchungArbeit({Key? key}) : super(key: key);

  @override
  _BuchungArbeitState createState() => _BuchungArbeitState();
}

class _BuchungArbeitState extends State<BuchungArbeit> {
  // Simplified buchungen data
  List<Map<String, dynamic>> buchungenData = [];

  @override
  void initState() {
    super.initState();
    // Initialize buchungenData
    buchungenData = company.getAllBuchung();
  }

  // Function to get color based on status
  Color getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.blue;
      case 'On Progress':
        return Colors.orange;
      case 'Finished':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: buchungenData.length,
              itemBuilder: (context, index) {
                final buchung = buchungenData[index];
                return Card(
                  child: ListTile(
                    title: Text("Booking: " + buchung['id'].toString()),
                    subtitle: const Text("Click to work on the order"),
                    trailing: Text(
                      buchung['stat'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: getStatusColor(buchung['stat']),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TabBuchungdetails(
                            buchungID: buchung['id'],
                            status: buchung['stat'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
