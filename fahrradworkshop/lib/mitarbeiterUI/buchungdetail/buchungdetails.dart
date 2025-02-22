import 'package:fahrradworkshop/classes/company.dart';
import 'package:fahrradworkshop/global.dart';
import 'package:flutter/material.dart';

Company company = Globals.company;

class BuchungDetail extends StatefulWidget {
  final int buchungId;
  final String Status;

  const BuchungDetail({required this.buchungId, required this.Status, Key? key}) : super(key: key);

  @override
  _BuchungDetailState createState() => _BuchungDetailState();
}

class _BuchungDetailState extends State<BuchungDetail> {
  List<String> parts = ["Spareparts"];
  List<List<Map<String, dynamic>>> partsData = [];
  List<List<Map<String, dynamic>>> serviceData = [];
  String _selectedStatus = "";
  String anothervalue = ""; // Variable to store the selected status

  // State variable to hold the selected dropdown value
  @override
  void initState() {
    super.initState();
    // Initialize partsData using widget.buchungId
    List<Map<String, dynamic>> spareParts = company.getBuchung(widget.buchungId)['SparePart'] ?? [];
    List<Map<String, dynamic>> services = company.getBuchung(widget.buchungId)['Service'] ?? [];
    _selectedStatus = company.getStatusfromBuchungIDwithString(widget.buchungId);

    partsData.add(spareParts);
    serviceData.add(services);
  }

bool isInStock(String name) {
  print('Checking stock for: $name');
  for (var sparepart in company.getAllSparePart()) {
    print('Sparepart: ${sparepart['name']} - Quantity: ${sparepart['quantity']}');
    if (sparepart['name'] == name) {
      return sparepart['quantity'] > 0;
    }
  }
  return false;
}

void _showConfirmationDialog(bool inStock, Map<String, dynamic> data, String name) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: Text(
          inStock
              ? 'Are you sure you want to mark this item as worked on?'
              : 'This item is out of stock, make a request to the Betreiber?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (inStock) {
                setState(() {
                  data["isChecked"] = true;
                });
                // Replace with your logic to decrease stock
                company.decreaseStock(name);
                Navigator.of(context).pop(); // Dismiss the dialog

              } else {
                company.setRequestedtoTrue(name);
                Navigator.of(context).pop(); // Dismiss the dialog first
                // Show the "Request has been made" popup
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Request Made'),
                      content: Text('Request has been successfully made to the Betreiber.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Dismiss the dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}

  void _showStatusUpdateConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Status'),
          content: Text('Are you sure you want to update the status to "$_selectedStatus"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  anothervalue = _selectedStatus;
                  company.setStatusBuchung(widget.buchungId, anothervalue); // Store the selected status
                });
                Navigator.of(context).pop(); // Dismiss the dialog
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
        title: Text('Current Status: ${company.getStatusfromBuchungIDwithString(widget.buchungId)}'),
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: parts.length + 1,
              itemBuilder: (context, index) {
                if (index < parts.length) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.white,
                      collapsedBackgroundColor: Colors.white,
                      leading: const CircleAvatar(),
                      title: Text(parts[index]),
                      subtitle: const Text("Tap to expand"),
                      children: partsData[index].map((data) {
                        // Ensure 'name' and 'title' fields are non-null and are strings
                        String title = data["title"] ?? "";
                        bool inStock = isInStock(title);
                        bool isChecked = data["isChecked"] ?? false;
                        return Card(
                          child: InkWell(
                            onTap: () {
                              _showConfirmationDialog(inStock, data, title);
                            },
                            child: ListTile(
                              title: Text(title),
                              subtitle: isChecked
                                  ? Text("Already done", style: TextStyle(color: Colors.green))
                                  : Text(
                                      inStock
                                          ? "Tap to update progress"
                                          : "Out of stock",
                                      style: TextStyle(
                                          color: inStock ? Colors.green : Colors.red),
                                    ),
                              trailing: Icon(
                                isChecked
                                    ? Icons.check_circle
                                    : (inStock ? Icons.arrow_forward : Icons.cancel),
                                color: isChecked
                                    ? Colors.green
                                    : (inStock ? Colors.blue : Colors.red),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.white,
                      collapsedBackgroundColor: Colors.white,
                      leading: const CircleAvatar(),
                      title: Text('Service'),
                      subtitle: const Text("Tap to expand"),
                      children: serviceData[0].map((data) {
                        String title = data["title"] ?? "";
                        bool isChecked = data["isChecked"] ?? false;
                        return Card(
                          child: InkWell(
                            onTap: () {
                              _showConfirmationDialog(true, data, title);
                            },
                            child: ListTile(
                              title: Text(title),
                              subtitle: isChecked
                                  ? Text("Already worked on", style: TextStyle(color: Colors.green))
                                  : Text(
                                      "Not worked on yet",
                                      style: TextStyle(color: Colors.red),
                                    ),
                              trailing: Icon(
                                isChecked ? Icons.check_circle : Icons.arrow_forward,
                                color: isChecked ? Colors.green : Colors.blue,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Customer Description:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )
                ),
                const SizedBox(height:8.0),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    readOnly: true,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: company.getBuchung(widget.buchungId)["beschreibung"],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0), // Add spacing between TextField and Button
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          // Show confirmation dialog for updating status
                          _showStatusUpdateConfirmationDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50), // Make button larger
                        ),
                        child: const Text('Update Status'),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      flex: 3,
                      child: DropdownButton<String>(
                        value: _selectedStatus,
                        isExpanded: true,
                        alignment: Alignment.center,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedStatus = newValue!;
                          });
                        },
                        items: <String>['Confirmed', 'On Progress', 'Finished']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(child: Text(value)),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





