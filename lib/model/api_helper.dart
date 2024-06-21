import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';

class ApiHelper {
  static ApiHelper obj = ApiHelper._();

  ApiHelper._();

  factory ApiHelper() {
    return obj;
  }

  Future<Wether?> getApiData(String location) async {
    String baseUrl =
        "https://api.weatherapi.com/v1/forecast.json?key=e09f03988e1048d2966132426232205&q=";
    String endUrl = "$location&aqi=no";
    String api = baseUrl + endUrl;

    http.Response res = await http.get(Uri.parse(api));
    if (res.statusCode == 200) {
      Map decodedData = jsonDecode(res.body);
      var response = WetherFromJson(res.body);

      return response;
    }
    return null;
  }
}