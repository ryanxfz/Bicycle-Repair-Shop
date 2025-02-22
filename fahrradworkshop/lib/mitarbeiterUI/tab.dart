import 'package:fahrradworkshop/mitarbeiterui/buchungbearbeiten.dart';
import 'package:flutter/material.dart';

class TabBarmitarbeiter extends StatelessWidget {

  const TabBarmitarbeiter({
    Key? key,
  }) : super(key: key);

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
                Tab(icon: Icon(Icons.shopping_cart), text: 'Buchungen'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              BuchungArbeit(),
            ],
          ),
        ),
      ),
    );
  }
}
