import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:small_project/utilities/constants.dart';
import 'package:small_project/screen/AutoScreen.dart';
import 'package:small_project/screen/HomeScreen.dart';
import 'package:small_project/screen/ManualScreen.dart';
import 'package:small_project/screen/SettingsScreen.dart';
import 'package:small_project/utilities/settings.dart';
import 'package:small_project/components/RoundButton.dart';

class ResultScreenManu extends StatefulWidget {
  static const String id = "ResultScreenManual";

  final double distance, time;

  const ResultScreenManu({Key key, this.distance, this.time}) : super(key: key);

  @override
  _ResultScreenManuState createState() => _ResultScreenManuState();
}

class _ResultScreenManuState extends State<ResultScreenManu> {
  double time, velocity, timeDilation;
  Utility utility = new Utility();
  List<double> results;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    time = widget.time * 60;
    velocity = (widget.distance * 1609.34) / time;
    results = utility.getTimeDilation(velocity, time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Results"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Hero(
                tag: "manu",
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: <Widget>[
                      Clock(),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("You Saved:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 45,
                                    color: Colors.deepPurple[600])),
                            Text(
                              results[2].toStringAsExponential(2),
                              style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple[600]),
                            ),
                            Text(
                              "ns",
                              style: TextStyle(
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple[600]),
                            ),
                          ],
                        ),
                      ),

                    ]
                  ),
                )),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              color: Colors.blue,
              child: DataTable(
                  columns: [
                    DataColumn(label: Text("Velocity", style: kDataTableTextStyle,)),
                    DataColumn(label: Text("Observer Time", style: kDataTableTextStyle,)),
                    DataColumn(label: Text("Proper Time", style: kDataTableTextStyle,)),
                    DataColumn(label: Text("Time Difference", style: kDataTableTextStyle,)),
                    DataColumn(label: Text("Lorenze Value", style: kDataTableTextStyle,))
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text(velocity.toString() + "m/s" )),
                        DataCell(Text(time.toString() + "s"  )),
                        DataCell(Text(results[1].toString() + "s")),
                        DataCell(Text(results[2].toString() + 's')),
                        DataCell(Text(results[0].toString())),
                      ]),

                  ]),
            ),
          )
        ],
      ),
    );
  }
}
