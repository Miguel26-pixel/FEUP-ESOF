import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/alert/alert_controller_interface.dart';
import 'package:uni/model/entities/live/alert.dart';
import 'package:uni/model/entities/live/alert_type.dart';
import 'package:uni/model/entities/live/general_alert.dart';
import 'package:uni/model/entities/live/point.dart';
import 'package:uni/model/entities/live/spontaneous_alert.dart';

class AlertMockController implements AlertControllerInterface {
  int _alertCounter = 5;

  static final _alertTypes = {
    '0': AlertType('0', 'Full', 'This Location is Full',
        const Duration(days: 1), Icons.people_outline),
    '1': AlertType('1', 'Noisy', 'This Location is Noisy',
        const Duration(days: 1), Icons.volume_up_outlined),
    '2': AlertType('3', 'Cleaning', 'This Location is being cleaned',
        const Duration(days: 1), Icons.people_outline),
    '3': AlertType('4', 'Out of service', 'This Location is out of service',
        const Duration(days: 1), Icons.people_outline)
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
  Future<List<SpontaneousAlert>> getNearbySpontaneousAlerts(
      int floor, LatLng _) {
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
  Future<void> likeAlert(String alertId, bool _) async {
    if (_spontaneousAlerts[alertId] != null) {
      _spontaneousAlerts[alertId].finishTime.add(Duration(minutes: 2));
    } else if (_alerts[alertId] != null) {
      _alerts[alertId].addTime(2);
    }
  }

  @override
  Future<bool> dislikeAlert(String alertId, bool _) async {
    if (_spontaneousAlerts[alertId] != null) {
      _spontaneousAlerts[alertId].finishTime.subtract(Duration(minutes: 2));
      _spontaneousAlerts.remove(alertId);
      return Future.value(true);
    } else if (_alerts[alertId] != null) {
      _alerts[alertId].removeTime(2);
      _alerts.remove(alertId);
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Future<Tuple2<bool, String>> createSpontaneousAlert(
      String description, int floor, LatLng position) {
    if (position == null) {
      return Future.value(Tuple2(false, "Couldn't get current position"));
    }

    _spontaneousAlerts[_alertCounter.toString()] = SpontaneousAlert(
        _alertCounter.toString(),
        DateTime.now(),
        DateTime.now().add(Duration(seconds: 300)),
        description,
        position,
        floor);
    _alertCounter++;

    return Future.value(Tuple2(true, ''));
  }

  @override
  Future<Map<String, AlertType>> getAllAlertTypes() {
    return Future.value(_alertTypes);
  }

  @override
  Future<Tuple2<bool, String>> createAlert(
      PointOfInterest pointOfInterest, AlertType alertType) {
    return Future.value(Tuple2(true, ''));
  }

  @override
  Future<List<AlertType>> getAlertTypes() {
    return Future.value(_alertTypes.values.toList());
  }
}
