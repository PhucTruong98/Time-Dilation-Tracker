import 'package:flutter/material.dart';
import 'package:small_project/utilities/import.dart';
import 'package:small_project/screen/AutoScreen.dart';
import 'package:small_project/screen/HomeScreen.dart';
import 'package:small_project/screen/ManualScreen.dart';
import 'package:small_project/screen/SettingsScreen.dart';
import 'package:small_project/screen/ResultScreenManu.dart';
import 'package:small_project/screen/WidgetTest.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Dilation Tracker',
      theme: ThemeData.dark().copyWith(
          primaryColor: Color(0xFF0A0E21), //tab bar, top bar color
          accentColor: Color(0xFF3E3C3E),
          scaffoldBackgroundColor: Color(0xFF0A0E21),
          textTheme: TextTheme(body1: TextStyle(color: Colors.white)),
          sliderTheme: SliderTheme.of(context).copyWith(
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
            thumbColor: Colors.pink,
            activeTrackColor: Colors.pink,
            overlayColor: Color(0x29EB1555),
          )),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        AutoScreen.id: (context) => AutoScreen(),
        ManualScreen.id: (context) => ManualScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
        ResultScreenManu.id: (context) => ResultScreenManu(),
        WidgetTest.id: (context) => WidgetTest()
      },
    );
  }
}
