import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:small_project/components/RoundButton.dart';
import 'package:small_project/utilities/constants.dart';
import 'package:small_project/screen/AutoScreen.dart';
import 'package:small_project/screen/HomeScreen.dart';
import 'package:small_project/screen/ManualScreen.dart';
import 'package:small_project/screen/SettingsScreen.dart';
import 'package:small_project/screen/ResultScreenManu.dart';

class ManualScreen extends StatefulWidget {
  static const String id = "ManualScreen";

  @override
  _ManualScreenState createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  int distance = 150;

  final textFieldController1 = TextEditingController();
  final textFieldController2 = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    textFieldController1.dispose();
    textFieldController2.dispose();
    super.dispose();
  }

  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
          title: Text("Time Dilation Manual Screen"),
          titleSpacing: NavigationToolbar.kMiddleSpacing,
          elevation: 20),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ItemCard(
            child: TextField(
              controller: textFieldController1,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 24,
                color: Colors.blue[400],
              ),
              decoration: InputDecoration(
                hintText: 'Enter Distance Traveled (in miles)',
                hintStyle: TextStyle(color: Colors.red, fontSize: 18),
                icon: Icon(
                  Icons.forward,
                  size: 40,
                  color: Colors.orange,
                ),
                errorText: _validate ? null : "Can't be empty!!",
              ),
            ),
          ),
          ItemCard(
            child: TextField(
              controller: textFieldController2,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 24,
                color: Colors.blue[400],
              ),
              decoration: InputDecoration(
                hintText: 'Enter Total Time (in minutes)',
                hintStyle: TextStyle(color: Colors.red, fontSize: 18),
                icon: Icon(
                  Icons.timer,
                  size: 40,
                  color: Colors.orange,
                ),
                errorText: _validate ? null : "Can't be empty!!",
              ),
            ),
          ),
          Expanded(flex: 1, child: Container()),
          Hero(
            tag: "manu",
            child: RoundButton(
              color: Colors.yellow,
              onPress: () {
                (textFieldController1.text.isNotEmpty &&
                        textFieldController2.text.isNotEmpty)
                    ? _validate = true
                    : _validate = false;
                setState(() {});

                _validate
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreenManu(
                            distance: double.parse(textFieldController1.text),
                            time: double.parse(textFieldController2.text),
                          ),
                        ))
                    : null;
              },
              text: Text("GO!", style: kCircleButtonTextStyle,),
            ),
          )
        ],
      ),
    );
  }
}
