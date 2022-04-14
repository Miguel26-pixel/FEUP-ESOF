import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:src/controller/current_location.dart';
import 'package:src/model/spontaneous_alert.dart';
import 'package:src/view/widget/rounded_bottom_modal.dart';
import 'package:src/view/widget/validation_buttons.dart';

class SpontaneousAlertPage extends StatefulWidget {
  final SpontaneousAlert _spontaneousAlert;
  final CurrentLocationController _currentLocationController;

  const SpontaneousAlertPage(
      final this._spontaneousAlert, final this._currentLocationController,
      {Key? key})
      : super(key: key);

  @override
  State<SpontaneousAlertPage> createState() => _SpontaneousAlertPageState();
}

class _SpontaneousAlertPageState extends State<SpontaneousAlertPage> {
  int _distanceToAlert = -1;
  final Distance _distance = const Distance();
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();

    widget._currentLocationController
        .subscribeLocationUpdate((p0) => setState(() {
              if (p0 != null) {
                _distanceToAlert =
                    _distance(widget._spontaneousAlert.getPosition(), p0)
                        .floor();
              }
            }))
        .then((value) => {
              if (value != null) {_locationSubscription = value}
            });
  }

  @override
  void dispose() {
    super.dispose();

    var subscription = _locationSubscription;

    if (subscription != null) {
      subscription.cancel();
    }
  }

  String durationToString(Duration duration) {
    String output = "";
    int value = 0;
    if (duration.inDays > 0) {
      output += "${duration.inDays} day";
      value = duration.inDays;
    } else if (duration.inHours > 0) {
      output += "${duration.inHours} hour";
      value = duration.inDays;
    } else if (duration.inMinutes > 0) {
      output += "${duration.inMinutes} minute";
      value = duration.inMinutes;
    } else {
      output += "${duration.inSeconds} second";
      value = duration.inSeconds;
    }

    if (value > 1) {
      output += "s";
    }

    return output + " ago";
  }

  @override
  Widget build(BuildContext context) {
    return RoundedBottomModal(
      minHeight: 130,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget._spontaneousAlert.getMessage(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                      durationToString(DateTime.now()
                          .difference(widget._spontaneousAlert.getStartTime())),
                      style: TextStyle(color: Theme.of(context).hintColor)),
                  _distanceToAlert == -1
                      ? const SizedBox()
                      : Text(
                          "in $_distanceToAlert meters",
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: const ValidationButtons(),
          ),
        ],
      ),
    );
  }
}
