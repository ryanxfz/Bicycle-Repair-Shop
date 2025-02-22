class Company{
  List<Map<String, dynamic>> Buchung = [];
  List<Map<String, dynamic>> BookingInfo = [{
      "bookingID" : 0,
      "nachricht": " ",
      "responseFromCustomer": "noInfo", // Possible values: approved, rejected, pending, noInfo
      "nachrichtVonKunden": " ", // Initially empty
      "responseCheck": false,
      "statusNachricht": "notSent"
    }
  ];
  List<Map<String, String>> alleKunden = [    
    {'username': '1234', 'password': '1234'},
  ];
  List<Map<String, String>> alleMitarbeiter = [
    {'username': '1234', 'password': '1234'},
  ];
  List<Map<String, String>> alleBetreiber = [
    {'username': '1234', 'password': '1234'},
  ];

List<Map<String, dynamic>> allSparepart = [
  {'name': 'Road Bike Tires', 'quantity': 20, 'price': 60, "isRequested": false},
  {'name': 'Mountain Bike Tires', 'quantity': 50, 'price': 20, "isRequested": false},
  {'name': 'Brake Levers', 'quantity': 200, 'price': 10, "isRequested": false},
  {'name': 'Handlebar Grips', 'quantity': 200, 'price': 10, "isRequested": false},
  {'name': 'Saddles', 'quantity': 30, 'price': 40, "isRequested": false},
  {'name': 'front Lights', 'quantity': 15, 'price': 17, "isRequested": false},
  {'name': 'rear Lights', 'quantity': 0, 'price': 17, "isRequested": false},
];


List<Map<String, dynamic>> allService = [
  {'name': 'Brake Adjustment', 'price': 20},
  {'name': 'Basic Tune-Up', 'price': 30},
  {'name': 'Tire Inflation', 'price': 10},
  {'name': 'Frame Allignment', 'price': 30},
];
List<String> buchungid= [];

  void addBuchungen(Map<String, dynamic> buchung) {
    Buchung.add(buchung);
  }
  void addKunden(Map<String, String> kunden) {
    alleKunden.add(kunden);
  }
  void addMitarbeiter(Map<String, String> mitarbeiter){
    alleMitarbeiter.add(mitarbeiter);
  }
  void addBuchungId(int id){
    String newid = id.toString();
    buchungid.add(newid);
  }
  void setStatusBuchung(int id, String status){
    getBuchung(id)["stat"] = status;
  }

  List<Map<String, String>> getAlleKunden(){
    return alleKunden;
  }
  List<Map<String, dynamic>> getAllSparePart(){
    return allSparepart;
  }
  List<Map<String, dynamic>> getallService(){
    return allService;
  }
  List<Map<String, String>> getAllMitarbeiter(){
    return alleMitarbeiter;
  }  
  List<Map<String, String>> getAllBetreiber(){
    return alleBetreiber;
  }
    List<Map<String, dynamic>> getAllBuchung(){
    return Buchung;
  }
  List<String> getAllBuchungId(){
    return buchungid;
  }
  
  String getStatusfromBuchungID(String id){
  int parsedId;
  try {
    parsedId = int.parse(id); // Attempt to parse the string to an int
  } catch (e) {
    print('Error: Invalid ID format');
    return ""; // Return an empty string or handle the error as needed
  }

  for (var items in Buchung) {
    if (items["id"] == parsedId) {
      return items["stat"];
    }
  }
  return "";
  }

  String getStatusfromBuchungIDwithString(int id){
    for (var items in Buchung) {
        if (items["id"] == id) {
          return items["stat"];
        }
    }
    return "";
  }

  bool isPastforProgress(String id, String status){
    String statusfromBuchung = this.getStatusfromBuchungID(id);

    if(statusfromBuchung == "bestatigt" && status == "bestatigt"){
      return true;
    }else if(statusfromBuchung != "bestatigt" && status == "bestatigt"){
      return true;
    }


    if(statusfromBuchung == "in Arbeit" && status == "in Arbeit"){
      return true;
    }else if(statusfromBuchung == "Fertig" && status == "in Arbeit"){
      return true;
    }

    if(statusfromBuchung == "Fertig" && status == "Fertig"){
      return true;
    }
    return false;
  }

  String getTypeProduct(String product){
    for(var items in allSparepart){
      if(items["name"] == product){
        return "Spare Part";
      }
    }
    return "Service";
  }
Map<String, dynamic> getBuchung(int id) {
  Map<String, dynamic> emptyMap = {}; // Creating an empty map

  for (var items in Buchung) {
    if (items["id"] == id) {
      return items; // Return the found item
    }
  }
  
  return emptyMap; // Return the empty map if no matching id is found
}

List<Map<String, dynamic>> getSelectedItem(int id) {
  List<Map<String, dynamic>> emptyList = []; // Creating an empty list

  for (var items in Buchung) {
    if (items["id"] == id) {
      return items["items"]; // Return the items associated with the matching id
    }
  }
  
  return emptyList; // Return the empty list if no matching id is found
}
bool isInStock(String name){
  for(var sparepart in allSparepart){
    if(sparepart['name'] == name){
      if(sparepart['quantity'] <= 0){
        return false;
      }
    }
  }
  return true;
}

void changeQuantity(String productName, int newStock){
  for(var items in allSparepart){
    if(items["name"] == productName){
      items["quantity"] = newStock;
    }
  }
}
void decreaseStock(String name){
  for(var sparepart in allSparepart){
    if(sparepart['name'] == name){
      sparepart['quantity'] -= 1;
    }
  }
}

void addBookinginfo(Map<String, dynamic> bookingInfo){
  BookingInfo.add(bookingInfo);
}
Map<String, dynamic> getBookingInfo(int id){
  Map<String, dynamic> emptyMap = {};
  for(var info in BookingInfo){
    if(info["bookingID"] == id){
      return info;
    }
  }
  return emptyMap;
}
Map<String, dynamic> getBookingInfowithString(String id){
  Map<String, dynamic> emptyMap = {};
  int idString = int.parse(id); 
  for(var info in BookingInfo){
    if(info["bookingID"] == idString){
      return info;
    }
  }
  return emptyMap;
}
void setRequestedtoTrue(String name){
  for(var items in allSparepart){
    if(items["name"] == name){
      items["isRequested"] = true;
    }
  }
}
}
