import 'package:fahrradworkshop/betreiberui/einnahme.dart';
import 'package:fahrradworkshop/betreiberui/ersatzteile.dart';
import 'package:fahrradworkshop/betreiberui/request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabBarBetreiber extends StatelessWidget {
  const TabBarBetreiber({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Einnahmen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.receipt), text: 'Einnahmen'),
                Tab(icon: Icon(Icons.handyman), text: 'Ersatzteile'),
                Tab(icon: Icon(Icons.send), text: "Requests")
              ],
            ),
          ),
          body:  TabBarView(
            children: [
              Einnahme(),
              QuantityList(),
              RequestBetreiber(),
            ],
          ),
        ),
      ),
    );
  }
}