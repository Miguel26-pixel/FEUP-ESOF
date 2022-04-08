import 'dart:math';

import 'package:flutter/material.dart';
import 'package:src/model/point.dart';

class PointOfInterestPage extends StatefulWidget {
  final PointOfInterest _poi;
  const PointOfInterestPage(final this._poi, {Key? key}) : super(key: key);

  @override
  State<PointOfInterestPage> createState() => _PointOfInterestPageState();
}

class _PointOfInterestPageState extends State<PointOfInterestPage> {
  Widget buildAlertList(BuildContext context, int i) {
    return Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(50, 0, 0, 0),
                offset: Offset(0, 2),
                blurRadius: 1,
                spreadRadius: 0,
              )
            ]),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget._poi.getAlerts()[i].getGeneralAlert().getName(),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ));
  }

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
          // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(
                      bottom: BorderSide(
                          color: Color.fromARGB(255, 220, 220, 220), width: 1)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget._poi.getName().toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: buildAlertList,
                  itemCount: widget._poi.getAlerts().length,
                ),
              )
            ],
          ),
        ));
  }
}
