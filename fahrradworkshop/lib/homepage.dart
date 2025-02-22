import 'package:fahrradworkshop/betreiberui/loginbetreiber.dart';
import 'package:fahrradworkshop/kundenui/logincustomer.dart';
import 'package:fahrradworkshop/mitarbeiterui/loginmitarbeiter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  //static const Color beige = Color(0xFFF5F5DC);
  HomePage({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 70,),
              const Icon(
                Icons.directions_bike,
                size: 100
              ),
              const SizedBox(height: 70,),
              Text(
                'Welcome!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 30,
                ),
              ),
              Text(                
                'Login as',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreenCustomer(userType: 'Kunden')),
                    );
                  },
                  child: const Text('Customer', style: TextStyle(fontSize: 24)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 47.0),
                  ),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreenMitarbeiter(userType: 'Mitarbeiter')),
                    );
                  },
                  child: const Text('Employee', style: TextStyle(fontSize: 24)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 31.0),
                  ),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreenBetreiber(userType: 'Betreiber')),
                    );
                  },
                  child: const Text('Manager', style: TextStyle(fontSize: 24)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 42.0),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}