import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class SearchProvider extends ChangeNotifier {
  String? loc;

  Future<void> fetchDataFromPrefs() async {
    String? storedLoc = prefs.getString('City');
    if (storedLoc != null) {
      loc = storedLoc;
      print(loc);
      notifyListeners(); // Notify listeners about the change
    } else {
      loc = "Rajkot";
      notifyListeners();
    }
  }

  Future<void> searchloc(String value) async {
    String baseUrl =
        "https://api.weatherapi.com/v1/forecast.json?key=e09f03988e1048d2966132426232205&q=";
    String endUrl = "$value&aqi=no";
    String api = baseUrl + endUrl;
    http.Response res = await http.get(Uri.parse(api));
    if (res.statusCode == 200) {
      loc = value;
      prefs.setString("City", value);
    } else {
      print("NO DATA FOUND");
    }
    notifyListeners();
  }
}