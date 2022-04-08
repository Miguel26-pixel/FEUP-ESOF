import 'dart:math';

import 'package:flutter/material.dart';
import 'package:src/model/point.dart';

class PointOfInterestPage extends StatefulWidget {
  final PointOfInterest _poi;
  const PointOfInterestPage(this._poi, {Key? key}) : super(key: key);

  @override
  State<PointOfInterestPage> createState() => _PointOfInterestPageState();
}

class _PointOfInterestPageState extends State<PointOfInterestPage> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints.tightFor(
            height: max(400, MediaQuery.of(context).size.height)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white),
          height: 120,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Text(
            widget._poi.getName(),
          ),
        ));
  }
}
