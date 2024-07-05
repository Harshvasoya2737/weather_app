import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/controller/theme_provider.dart';
import 'package:weather_app/model/api_helper.dart';
import '../controller/search.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    var sp = Provider.of<SearchProvider>(context, listen: false);
    sp.fetchDataFromPrefs();
    super.initState();
  }

  http.Response? res;
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var sp = Provider.of<SearchProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          sp.loc ?? "",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        actions: [
          Consumer<ThemeProvider>(builder: (context, tp, child) {
            return IconButton(
              onPressed: () {
                tp.setTheme();
              },
              icon: tp.isDark == false
                  ? Icon(Icons.dark_mode_outlined)
                  : Icon(Icons.light_mode_outlined),
            );
          })
        ],
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: ApiHelper().getApiData(sp.loc ?? ""),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error : ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            Wether? detail = snapshot.data;
            String inputString = detail!.location!.localtime!;
            DateFormat inputFormat = DateFormat("yyyy-MM-dd H:mm");
            DateTime dateTime = inputFormat.parse(inputString);

            DateFormat outputFormat = DateFormat("MMMM dd, yyyy", 'en_US');
            String formattedDate = outputFormat.format(dateTime);

            DateTime now = DateTime.now();
            double hour = now.hour.toDouble();

            return Consumer<SearchProvider>(builder: (context, sp, child) {
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                        height: 1050,
                        width: double.infinity,
                        child:
                            Provider.of<ThemeProvider>(context, listen: false)
                                        .isDark ==
                                    false
                                ? Image.asset(
                                    "assets/images/sky-2.jpg",
                                    fit: BoxFit.fitHeight,
                                  )
                                : Image.asset(
                                    "assets/images/night-2.jpg",
                                    fit: BoxFit.fitHeight,
                                  )),
                    Container(
                      margin: EdgeInsets.only(top: 40, left: 10, right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.transparent),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: TextFormField(
                          controller: search,
                          decoration: InputDecoration(
                            hintText: "Search Your Location",
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  search.clear();
                                },
                                icon: Icon(Icons.close_outlined)),
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          onFieldSubmitted: (value) async {
                            sp.searchloc(value);
                            String baseUrl =
                                "https://api.weatherapi.com/v1/forecast.json?key=e09f03988e1048d2966132426232205&q=";
                            String endUrl = "$value&aqi=no";
                            String api = baseUrl + endUrl;
                            res = await http.get(Uri.parse(api));
                            search.clear();
                          },
                        ),
                      ),
                    ),
                    res?.statusCode == 400
                        ? Center(
                            child: Text(
                                "\t\t\t\t\t\t\t\t\t\tNo matching location found\n(you can search only search city weather)"),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 150),
                                  height: 280,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 50),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${detail.current!.tempC}°",
                                                style: TextStyle(
                                                  fontSize: 60,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                "C",
                                                style: TextStyle(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      Provider.of<ThemeProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .isDark
                                                          ? Colors.white54
                                                          : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "${detail.current?.condition?.text}",
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          formattedDate,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.thermostat,
                                            size: 30,
                                          ),
                                          Text(
                                            "Feels Like",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: 150,
                                          ),
                                          Text(
                                            "${detail.current!.feelslikeC}°",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(Icons.wind_power, size: 30),
                                          Text(
                                            "Air pressure",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 135,
                                          ),
                                          Text(
                                            "${detail.current!.pressureMb} km/h",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(Icons.light_mode_outlined,
                                              size: 30),
                                          Text(
                                            "UV",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                          ),
                                          Text(
                                            "${detail.current!.uv}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(Icons.visibility, size: 30),
                                          Text(
                                            "Visibility",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 160,
                                          ),
                                          Text(
                                            "${detail.current!.visKm}km",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(Icons.air, size: 30),
                                          Text(
                                            "SW wind",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 160,
                                          ),
                                          Text(
                                            "${detail.current!.windKph} km/h",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(Icons.water_drop, size: 30),
                                          Text(
                                            "Humidity",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 155,
                                          ),
                                          Text(
                                            "${detail.current!.humidity}%",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50,
                                    width: 300,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Center(
                                        child: Text(
                                      "Timing Info",
                                      style: TextStyle(fontSize: 25),
                                    )),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 10, right: 10),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                      detail.forecast!.forecastday![0].hour!
                                          .length,
                                      (index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 28),
                                          child: Column(
                                            children: [
                                              (detail
                                                              .forecast!
                                                              .forecastday![0]
                                                              .hour![
                                                                  DateTime.now()
                                                                      .hour]
                                                              .time!
                                                              .split(
                                                                  "${DateTime.now().day}")[
                                                          1] ==
                                                      detail
                                                          .forecast!
                                                          .forecastday![0]
                                                          .hour![index]
                                                          .time!
                                                          .split(
                                                              "${DateTime.now().day}")[1])
                                                  ? Text(
                                                      "Now",
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    )
                                                  : Text(
                                                      detail
                                                          .forecast!
                                                          .forecastday![0]
                                                          .hour![index]
                                                          .time!
                                                          .split(
                                                              "${DateTime.now().day}")[1],
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Image.network(
                                                "http:${detail.forecast!.forecastday![0].hour![index].condition!.icon}",
                                                height: 50,
                                                width: 50,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "${detail.forecast!.forecastday![0].hour![index].tempC}°",
                                                style: TextStyle(fontSize: 15),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Image.asset(
                                  "assets/images/seasson-removebg-preview.png")
                            ],
                          ),
                  ],
                ),
              );
            });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
