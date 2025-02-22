import 'package:fahrradworkshop/betreiberui/einnahme.dart';
import 'package:flutter/material.dart';

class CustomQuantityTile extends StatefulWidget {
  final String title;
  final int initialCount;
  final Function(int) onChanged;

  const CustomQuantityTile({
    Key? key,
    required this.title,
    this.initialCount = 0,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomQuantityTileState createState() => _CustomQuantityTileState();
}

class _CustomQuantityTileState extends State<CustomQuantityTile> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  if (_count > 0) _count--;
                  widget.onChanged(_count);
                });
              },
            ),
            Text(
              _count.toString(),
              style: TextStyle(fontSize: 18),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _count++;
                  widget.onChanged(_count);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QuantityList extends StatefulWidget {
  const QuantityList({Key? key}) : super(key: key);
  
  @override
  _QuantityListState createState() => _QuantityListState();
}

class _QuantityListState extends State<QuantityList> {

  List<Map<String, dynamic>> quantities = company.getAllSparePart();

  List<Map<String, dynamic>> tempQuantities = [];

  @override
  void initState() {
    super.initState();
    tempQuantities = List.from(quantities);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quantity List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: company.getAllSparePart().length,
              itemBuilder: (context, index) {
                return CustomQuantityTile(
                  title: company.getAllSparePart()[index]['name'],
                  initialCount: company.getAllSparePart()[index]['quantity'],
                  onChanged: (count) {
                    setState(() {
                      tempQuantities[index]["name"] = company.getAllSparePart()[index]['name'];
                      tempQuantities[index]['quantity'] = count;
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: _showConfirmationDialog,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // Make button larger
              ),
              child: const Text('Save'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Click the Speichern button to save the changes you made.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Order'),
          content: const Text(
            'The spare parts quantity will be updated, are you sure?'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  quantities = List.from(tempQuantities);
                  for(var items in tempQuantities){
                    company.changeQuantity(items["name"], items["quantity"]);
                  }
                });
    
                Navigator.of(context).pop(); // Dismiss the dialog
                print('Speichern button pressed');
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}