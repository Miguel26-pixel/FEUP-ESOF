import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:src/controller/current_location.dart';
import 'package:src/model/spontaneous_alert.dart';
import 'package:src/view/widget/rounded_bottom_modal.dart';

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

  @override
  Widget build(BuildContext context) {
    return RoundedBottomModal(
      minWidth: 200,
      child: Text("Distance $_distanceToAlert"),
    );
  }
}
