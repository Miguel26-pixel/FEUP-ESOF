import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/controller/alert/alert_controller_interface.dart';
import 'package:uni/model/entities/live/alert.dart';
import 'package:uni/model/entities/live/alert_type.dart';
import 'package:uni/model/entities/live/general_alert.dart';
import 'package:uni/model/entities/live/point.dart';
import 'package:uni/model/entities/live/spontaneous_alert.dart';

class AlertMockController implements AlertControllerInterface {
  static final _alertTypes = {
    '0': AlertType('0', 'Full', 'This Location is Full',
        const Duration(days: 1), Icons.people_outline),
    '1': AlertType('1', 'Noisy', 'This Location is Noisy',
        const Duration(days: 1), Icons.volume_up_outlined),
  };

  static final _alerts = <String, Alert>{
    '2': Alert(
      '2',
      DateTime.now(),
      DateTime.now().add(
        const Duration(days: 1),
      ),
      _alertTypes['0'],
    ),
    '3': Alert(
      '3',
      DateTime.now().subtract(
        const Duration(minutes: 1),
      ),
      DateTime.now().add(
        const Duration(hours: 1),
      ),
      _alertTypes['1'],
    ),
  };

  static final _spontaneousAlerts = <String, SpontaneousAlert>{
    '0': SpontaneousAlert(
      '0',
      DateTime.now().subtract(const Duration(hours: 1)),
      DateTime.now().add(const Duration(hours: 1)),
      'Spilt Coffee',
      LatLng(41.1775666, -8.5955153),
      0,
    ),
    '1': SpontaneousAlert(
      '1',
      DateTime.now().subtract(const Duration(minutes: 10)),
      DateTime.now().add(const Duration(hours: 1)),
      'Really Long Message, Yeah you should probably look into this now :)',
      LatLng(41.1779666, -8.5955153),
      0,
    ),
    '4': SpontaneousAlert(
      '4',
      DateTime.now().subtract(const Duration(hours: 1)),
      DateTime.now().subtract(const Duration(minutes: 10)),
      """
This alert shouldn't appear!""", // maybe this filtering should be done by the controller
      LatLng(41.1784666, -8.5955153),
      0,
    ),
  };

  @override
  Future<List<SpontaneousAlert>> getNearbySpontaneousAlerts(int floor) {
    return Future.value(
      _spontaneousAlerts.values
          .where(
            (element) => element.getFloor() == floor,
          )
          .toList(),
    );
  }

  @override
  Future<GeneralAlert> getAlert(String id) {
    if (_alerts.containsKey(id)) {
      return Future.value(_alerts[id]);
    }

    return Future.value(_spontaneousAlerts[id]);
  }

  @override
  Future<AlertType> getAlertType(String id) {
    return Future.value(_alertTypes[id]);
  }

  @override
  Future<List<Alert>> getAlertsOfPoi(PointOfInterest poi) {
    return Future.value(poi.getAlertIds().map((e) => _alerts[e]).toList());
  }


  @override
  void likeAlert(int spontaneousId) {
    if (_spontaneousAlerts[spontaneousId.toString()] != null) {
      _spontaneousAlerts[spontaneousId.toString()].finishTime
          .add(Duration(minutes:2));
    }
    else if (_alerts[spontaneousId.toString()] != null) {
      _alerts[spontaneousId.toString()].setFinishTime(2);
    }
  }



  @override
  bool dislikeAlert(int spontaneousId) {
    if (_spontaneousAlerts[spontaneousId.toString()] != null) {
      _spontaneousAlerts[spontaneousId.toString()].finishTime
          .subtract(Duration(minutes:2));
      _spontaneousAlerts.remove(spontaneousId.toString());
      return true;
    }
    else if (_alerts[spontaneousId.toString()] != null) {
      _alerts[spontaneousId.toString()].setFinishTime(-2);
      _alerts.remove(spontaneousId.toString());
      return true;
    }
    return false;
  }
}
