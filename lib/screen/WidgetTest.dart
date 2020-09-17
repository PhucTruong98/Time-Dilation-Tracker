import 'package:flutter/material.dart';
import 'package:small_project/components/RoundButton.dart';

class WidgetTest extends StatefulWidget {
  static String id = "WidgetTestScreen";

  @override
  _WidgetTestState createState() => _WidgetTestState();
}

class _WidgetTestState extends State<WidgetTest> {
  int _selectedIndex = 1;
  static List<Widget> widgetList = <Widget>[
    Table(
      children: [
        TableRow(children: [
          RoundButton(text: Text("MANU"), onPress: null, color: Colors.redAccent),
          RoundButton(text: Text("MANU"), onPress: null, color: Colors.redAccent),
          RoundButton(text: Text("MANU"), onPress: null, color: Colors.redAccent),
        ]),
        TableRow(children: [
          Card(color: Colors.green),
          Container(),
          Container(),
        ]),
        TableRow(children: [
          ItemCard(
            child: TextField(
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
              ),
            ),
          ),
          Container(),
          Container(),
        ]),
      ],
    ),
    CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Demo'),
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 4.0,
          ),
              delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
              return Container(
              alignment: Alignment.center,
                color: Colors.teal[100 * (index % 9)],
                child: Text('Grid Item $index'),
              );
            },
            childCount: 20,
          ),
        ),
        SliverFixedExtentList(
          itemExtent: 50.0,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.lightBlue[100 * (index % 9)],
                child: Text('List Item $index'),
              );
            },
          ),
        ),
      ],
    ),
    Text(
      "Hello13",
      style: TextStyle(color: Colors.redAccent),
    ),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Widget Test Screen"),
      ),
      body: widgetList.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Business'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('School'),
          ),
        ],
        selectedItemColor: Colors.amber,
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}
