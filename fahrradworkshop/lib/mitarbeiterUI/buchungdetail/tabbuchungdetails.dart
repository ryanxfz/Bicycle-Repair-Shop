import 'package:fahrradworkshop/mitarbeiterUI/buchungdetail/requestMitarbeiterTab.dart';
import 'package:fahrradworkshop/mitarbeiterui/buchungdetail/buchungdetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fahrradworkshop/classes/company.dart';
import 'package:fahrradworkshop/global.dart';
    Company company = Globals.company;

class TabBuchungdetails extends StatelessWidget {
  final int buchungID;
  final String status;

  const TabBuchungdetails({Key? key, required this.buchungID, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.shopping_cart), text: 'Details'),
                Tab(icon: Icon(Icons.hourglass_bottom), text: 'Requests'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              BuchungDetail(
                buchungId: buchungID,
                Status: status,
              ),
              RequestMitarbeiterTab(
                buchungid: buchungID,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
