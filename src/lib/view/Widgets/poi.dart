import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/live/point.dart';
import 'package:uni/model/entities/live/point_group.dart';

class PointOfInterestPage extends StatefulWidget {
  final PointOfInterest _poi;
  const PointOfInterestPage(final this._poi, {Key key}) : super(key: key);

  @override
  State<PointOfInterestPage> createState() => _PointOfInterestPageState();
}

class _PointOfInterestPageState extends State<PointOfInterestPage> {
  Widget buildAlertItem(BuildContext context, PointOfInterest poi, int i) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(50, 0, 0, 0),
                offset: Offset(0, 1),
                blurRadius: 1,
                spreadRadius: 0,
              )
            ]),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    iconSize: 30,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    iconSize: 30,
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                poi.getAlerts()[i].getGeneralAlert().getName(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 60,
                child: Icon(
                  poi.getAlerts()[i].getGeneralAlert().getIconData(),
                  size: 35,
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildPointOfInterest(BuildContext context, PointOfInterest poi) {
    final String titleString = poi.getName();

    final Widget _title = AutoSizeText(
      titleString.toUpperCase(),
      textAlign: TextAlign.center,
      maxLines: 2,
      style: const TextStyle(
        fontSize: 17,
        color: Colors.black,
        fontWeight: FontWeight.w800,
      ),
    );

    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      height: 120,
      width: MediaQuery.of(context).size.width - 20,
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 20,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 220, 220, 220),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_on),
                  onPressed: () {},
                ),
                Expanded(
                  child: _title,
                ),
                IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.bar_chart),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
              child: poi.getAlerts().isEmpty
                  ? const Center(
                      child: SizedBox(
                        width: 200,
                        child: Text(
                          'There are no active alerts here at this moment.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : ListView(
                      children: poi
                          .getAlerts()
                          .asMap()
                          .map((i, a) =>
                              MapEntry(i, buildAlertItem(context, poi, i)))
                          .values
                          .toList(),
                    )),
        ],
      ),
    );
  }

  List<PointOfInterest> pois = [];

  @override
  Widget build(BuildContext context) {
    final List<PointOfInterest> pois = [];

    if (widget._poi is PointOfInterestGroup) {
      pois.addAll((widget._poi as PointOfInterestGroup).getPoints());
    } else {
      pois.add(widget._poi);
    }

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          height: min(400, MediaQuery.of(context).size.height)),
      child: ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        children:
            pois.map((poi) => buildPointOfInterest(context, poi)).toList(),
      ),
    );
  }
}
