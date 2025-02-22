import 'package:fahrradworkshop/kundenui/order.dart';
import 'package:fahrradworkshop/kundenui/progress.dart';
import 'package:fahrradworkshop/kundenui/request.dart';
import 'package:flutter/material.dart';

class TabBarDemo extends StatelessWidget {
  final String kunden;
  TabBarDemo({super.key, required this.kunden});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.shopping_cart), text: 'Order'),
                Tab(icon: Icon(Icons.hourglass_bottom), text: 'Progress'),     
                Tab(icon: Icon(Icons.hourglass_bottom), text: 'Requests'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Order(kunden: kunden,),
              Progress(),
              RequestCustomer()
            ],
          ),
        ),
      ),
    );
  }
}