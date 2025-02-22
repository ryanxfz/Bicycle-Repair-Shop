import 'package:fahrradworkshop/classes/company.dart';
import 'package:fahrradworkshop/global.dart';
import 'package:fahrradworkshop/kundenui/components/mytimeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Company company = Globals.company;

class Progress extends StatefulWidget{
  const Progress({Key? key}) : super(key: key);

  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress>{
  String? selectedBuchung ;
  String newbuchungid = "";
  final List<String> buchungen = company.getAllBuchungId();
  Widget _dropDown({
    Widget? underline,
    Widget? icon,
    TextStyle? style,
    TextStyle? hintStyle,
    Color? dropdownColor,
    Color? iconEnabledColor,
  }) =>
      DropdownButton<String>(
          value: selectedBuchung,
          underline: underline,
          icon: icon,
          dropdownColor: dropdownColor,
          style: style,
          iconEnabledColor: iconEnabledColor,
          onChanged: (String? newvalue) {
            setState(() {
              selectedBuchung = newvalue;
              newbuchungid = selectedBuchung ?? '';
              print(newbuchungid);
            });
          },
          hint: Text("Choose a booking ID", style: hintStyle),
          items: buchungen
              .map((fruit) =>
                  DropdownMenuItem<String>(value: fruit, child: Text(fruit)))
              .toList());

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: ListView(
          children: [
             const SizedBox(height: 50,),
             Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: _dropDown(underline: Container())
              ),
            const SizedBox(height: 40,),


            MyTimeLineTile(isFirst: true, isLast: false, isPast: company.isPastforProgress(newbuchungid, "bestatigt"), eventCard: Text("Confirmed"),),

            MyTimeLineTile(isFirst: false, isLast: false, isPast: company.isPastforProgress(newbuchungid, "in Arbeit"), eventCard: Text("on Work")),

            MyTimeLineTile(isFirst: false, isLast: true, isPast: company.isPastforProgress(newbuchungid, "Fertig"), eventCard: Text("Order is Done"))

          ],
        ),
      ),
    );
  }
}
