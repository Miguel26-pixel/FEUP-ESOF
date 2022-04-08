import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:src/model/alert.dart';
import 'package:src/model/point.dart';
import 'package:src/model/alert_type.dart';
import 'package:src/view/widget/map.dart';
import 'package:src/view/widget/poi.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PointOfInterest _poiTest = PointOfInterest("B103", LatLng(1, 2), 1);

  @override
  void initState() {
    AlertType type1 =
        AlertType("Full", "This Location is Full", Duration(days: 1));
    AlertType type2 =
        AlertType("Noisy", "This Location is Noisy", Duration(days: 1));

    Alert alert1 =
        Alert(DateTime.now(), DateTime.now().add(Duration(days: 1)), type1);

    Alert alert2 = Alert(DateTime.now().subtract(Duration(minutes: 1)),
        DateTime.now().add(Duration(hours: 1)), type2);

    this._poiTest.addAlert(alert1);
    this._poiTest.addAlert(alert2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Map(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            enableDrag: false,
            builder: (context) {
              return PointOfInterestPage(this._poiTest);
            }),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
