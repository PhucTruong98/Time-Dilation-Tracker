import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:small_project/components/RoundButton.dart';
import 'package:small_project/screen/WidgetTest.dart';
import 'package:small_project/utilities/constants.dart';
import 'package:small_project/screen/AutoScreen.dart';
import 'package:small_project/screen/HomeScreen.dart';
import 'package:small_project/screen/ManualScreen.dart';
import 'package:small_project/screen/SettingsScreen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "HomeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  AnimationController controller;
  Animation<double> animation;
  Tween<double> flashingTween = Tween(begin: 0, end: 232);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: 5));

    animation = flashingTween.animate(controller);
    animation.addListener(() {
      setState(() {

      });
    });

    animation.addStatusListener((status) { if (status == AnimationStatus.completed)
    {
      controller.reverse();
    }
    else if (status == AnimationStatus.dismissed)
    {
      controller.forward();
    }});

    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Time Dilation Home Screen"),
      ),
      body: Container(
        decoration: BoxDecoration(
//          image: DecorationImage(
//            image: AssetImage("assets/images/backgroundapp.jpg"),
//            fit: BoxFit.cover,
//          ),
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, animation.value.toInt(), 100, 100-animation.value.toInt()),
          Color.fromARGB(255, 100, animation.value.toInt(), 100- animation.value.toInt()),
          Color.fromARGB(255, 100-animation.value.toInt(),  animation.value.toInt(), 100),
          Color.fromARGB(255, animation.value.toInt(), 100, 100),
        ],

        ),),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(30),
                  child: SizedBox(
                    width: 400.0,
                    child: RichText(text: TextSpan(
                      text: 'TIME ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          color: Colors.cyanAccent,
                          shadows: [
                        Shadow(
                            color: Colors.green,
                            blurRadius: 10,
                            offset: Offset(10,10),
                        ),
                            Shadow(
                              color: Colors.blue,
                              blurRadius: 10,
                              offset: Offset(20,20),
                            )]),
                      children: <TextSpan>[
                        TextSpan(text: 'DILATION ', style: TextStyle(
                            fontWeight: FontWeight.bold,
                          fontSize: 40 + animation.value / 232 * 10,
                          color: Colors.yellow

                        )),
                        TextSpan(text: 'TRACKER'),
                      ],
                    ),)
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Tooltip(
                    height: 50,
                    verticalOffset: 100,
                    message: "Uses GPS for live location tracking to automaticcally calculate velocity",
                    child: new RoundButton(
                      color: Colors.blue,
                      text: Text("AUTO", style: kCircleButtonTextStyle,),
                      onPress: () {
                        setState(() {

                        });
                        Navigator.pushNamed(context, AutoScreen.id);
                      },
                    ),
                  ),
                  Hero(
                    tag: "manu",
                    child: Tooltip(
                      height: 24,
                      verticalOffset: 24,
                      message: "Enter value manually to calculate",
                      child: new RoundButton(
                        color: Colors.blue,
                        text: Text("MANU", style: kCircleButtonTextStyle,),
                        onPress: () {
                          Navigator.pushNamed(context, ManualScreen.id);
                        },
                      ),
                    ),
                  ),
                ],
              ),
//              Expanded(
//                  flex: 1,
//                  child: Container(
//                    child: RoundButton(
//                      text: "GET SETTINGS",
//                      onPress: () {
//                        Navigator.pushNamed(context, WidgetTest.id);
//                      },
//                    ),
//                  )),

            ]),
      ),
    );
  }
}
