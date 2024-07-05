import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';
import 'package:weather_app_tutorial/consts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_app_tutorial/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late SharedPreferences _prefs;
  TextEditingController controller = TextEditingController();
  bool _prefsInitialized = false;

  @override
  void initState() {
    super.initState();
    initSharedPreferences().then((_) {
      setState(() {
        _prefsInitialized = true;
        controller.text = _prefs.getStringList('cities')?.isNotEmpty == true
            ? _prefs.getStringList('cities')![0]
            : '';
      });
    });
  }

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Future<void> _fetchWeather() async {
    try {
      Weather? weather = await _wf.currentWeatherByCityName(controller.text);
      setState(() {});
    } catch (e) {
      print('Error fetching weather: $e');

      // Check if the error is due to city not found
      if (e is OpenWeatherAPIException) {
        Fluttertoast.showToast(
          msg: 'City not found. Please enter a valid city name.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to fetch weather data. Please try again later.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _prefsInitialized
            ? Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: 'Enter a City Name',
                              labelText: 'City Name',
                            ),
                            validator: (value) {
                              RegExp cityRegex = RegExp(r'^[a-zA-Z\s]+$');

                              if (value!.isEmpty) {
                                return 'City Name is Mandatory';
                              } else if (!cityRegex.hasMatch(value)) {
                                return 'Enter a valid City Name';
                              }
                            },
                          ),
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, setState) => _prefs
                                    .getStringList('cities')
                                    ?.isNotEmpty ==
                                true
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      _prefs.getStringList('cities')!.length,
                                  itemBuilder: (context, index) {
                                    return Text(
                                        _prefs.getStringList('cities')![index]);
                                  },
                                ),
                              )
                            : Container(),
                      ),
                      Flexible(
                        flex: 3,
                        child: Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            child: Text('See Weather Report'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await _addCityToList(controller.text);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(city: controller.text),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _addCityToList(String city) async {
    List<String> cities = _prefs.getStringList('cities') ?? [];
    cities.add(city);
    await _prefs.setStringList('cities', cities);
    setState(() {}); // Update the StatefulBuilder to reflect the new city
  }
}
