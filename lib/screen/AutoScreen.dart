import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:small_project/utilities/constants.dart';
import 'package:small_project/utilities/locations.dart' as locations;
import 'package:small_project/components/RoundButton.dart';
import 'package:geolocator/geolocator.dart';
import 'package:small_project/utilities/settings.dart';

class AutoScreen extends StatefulWidget {
  static const String id = "AutoScreen";

  @override
  _AutoScreenState createState() => _AutoScreenState();
}

class _AutoScreenState extends State<AutoScreen> {
  int _currIndex = 0;
  bool animatedText = false;

  Utility utility = new Utility();
  double clockValue = 0.0; // the value of the time calculation on clock
  double velocityValue = 0.0;

  StreamSubscription<Position> _locationSubscription;
  Marker marker;
  Circle circle;
  var geolocator = Geolocator();
  var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high, distanceFilter: 10, timeInterval: 3000);
  bool tracking = false;
  List<Position> locationDataList = new List();
  Set<Polyline> _polylines = new Set();

  GoogleMapController _controller;
  final Map<String, Marker> _markers = {};
  Set<Marker> nudes = Set();

  List<Widget> getWidgetList() {
    return <Widget>[
      Stack(children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: const LatLng(0, 0),
            zoom: 2,
          ),
          //markers: _markers.values.toSet(),
          markers: nudes,
          polylines: _polylines,

//                markers: Set.of((marker != null) ? [marker] : []),
//                circles: Set.of((circle != null) ? [circle] : []),
        ),
        Positioned(

          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                boxShadow: [BoxShadow(color: Colors.green, blurRadius: 7)],
              color: Colors.blue.withOpacity(0.7),
            ),
            child: Text("  "+ velocityValue.toStringAsPrecision(2) + "\n m/s", style: TextStyle( fontSize: 40),),
          ),
        ),
      ]),
      CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(children: <Widget>[
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
                        clockValue.toStringAsExponential(2),
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

//                      RichText(
//                        text: TextSpan(
//                            text: clockValue.toStringAsExponential(2),
//                            style: TextStyle(
//                                fontSize: 80,
//                                fontWeight: FontWeight.bold,
//                                color: Colors.deepPurple[600]),
//                            children: [
//                              TextSpan(
//                                text: "ns",
//                                style: TextStyle(
//                                    fontSize: 45,
//                                    fontWeight: FontWeight.bold,
//                                    color: Colors.deepPurple[600]),
//                              )
//                            ]),
//                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
//          SliverGrid(
//            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//              maxCrossAxisExtent: 300.0,
//              mainAxisSpacing: 30.0,
//              crossAxisSpacing: 30.0,
//              childAspectRatio: 8.0,
//            ),
//            delegate: SliverChildBuilderDelegate(
//                  (BuildContext context, int index) {
//                return Container(
//                  alignment: Alignment.center,
//                  color: Colors.teal[100 * (index % 9)],
//                  child: Text('Grid Item $index'),
//                );
//              },
//              childCount: 20,
//            ),
//          ),

          SliverFixedExtentList(
            itemExtent: 70,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return FlatButton(
                  child: Container(
                      alignment: Alignment.center,
                      color: Colors.lightBlue[100 * (index % 9)],
                      child: locationDataList.length > index  + 1
                          ? Text(
                              locationDataList[index].toString() +
                                  ", Velocity: " +
                                  locationDataList[index]
                                      .speed
                                      .toStringAsPrecision(3) +
                                  " m/s",
                            )
                          : Text("Info Not Available :)")
                  ),
                  onPressed: () {
                    _currIndex = 0;
                    setState(() {
                    });
                    _controller.animateCamera(CameraUpdate.newCameraPosition(
                        new CameraPosition(
                            bearing: 192.8334901395799,
                            target: LatLng(locationDataList[index].latitude, locationDataList[index].longitude),
                            tilt: 0,
                            zoom: 18.00)));


                  },
                );
              },
            ),
          ),
        ],
      ),
    ];
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  void _onTap(int index) {
    setState(() {
      _currIndex = index;
    });
  }

  @override
  void initState() {
    //put widget list here because it needs to access other varibles in th class
    // TODO: implement initState

    super.initState();
    setUpStream();
    locationDataList.add(Position(speed: 0.0));
  }

  //Return the car icon as uint8list
  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/images/caricon2.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(Position newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  void setUpStream() async {
    try {
      Uint8List imageData = await getMarker();
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print("debug geolocation: " + position.toString());
      updateMarkerAndCircle(position, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription = geolocator
          .getPositionStream(locationOptions)
          .listen((Position position) {
        if (locationDataList.isEmpty) {
          locationDataList.add(position);
        }

        Position lastPosition = locationDataList[locationDataList.length - 1];
        locationDataList.add(position);
        updateClockHandler(position.speed);
        int colorValue = (position.speed / 100 * 255).toInt();
        print("Color debug" + colorValue.toString());

        _polylines.add(Polyline(
          polylineId: PolylineId(lastPosition.toString()),
          color: Color.fromRGBO(colorValue, 255, colorValue, 1.0),
          onTap: () {
            debugPrint("Polyline tapped");
          },
          points: [
            LatLng(lastPosition.latitude, lastPosition.longitude),
            LatLng(position.latitude, position.longitude)
          ],
        ));
        setState(() {});
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(position.latitude, position.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(position, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void updateClockHandler(double velocity) {
    List<double> result = utility.getTimeDilation(velocity, 3);
    clockValue += result[02];
    velocityValue = velocity;
    animatedText = true;
    setState(() {});
    animatedText = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Time Dilation Tracker'),
          backgroundColor: Colors.green[700],
        ),
        body: IndexedStack(
          //Using indexedStack to ensure the pages dont get destroy when sitching tab
          children: getWidgetList(),
          index: _currIndex,
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(tracking ? Icons.play_arrow : Icons.pause),
            onPressed: () {
              tracking = !tracking;
              tracking
                  ? _locationSubscription.pause()
                  : _locationSubscription.resume();
              setState(() {});
            }),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text("Map"),
            ),
            BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("List"))
          ],
          selectedItemColor: Colors.redAccent,
          currentIndex: _currIndex,
          onTap: _onTap,
        ),
      ),
    );
  }
}
