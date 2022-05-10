import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/controller/alert/alert_controller_interface.dart';
import 'package:uni/model/entities/live/alert.dart';
import 'package:uni/model/entities/live/alert_type.dart';
import 'package:uni/model/entities/live/general_alert.dart';
import 'package:uni/model/entities/live/spontaneous_alert.dart';

class AlertMockController implements AlertControllerInterface {
  final List<GeneralAlert> _alerts = [
    SpontaneousAlert(
      0,
      DateTime.now().subtract(const Duration(hours: 1)),
      DateTime.now().add(const Duration(hours: 1)),
      'Spilt Coffee',
      LatLng(41.1775666, -8.5955153),
      0,
    ),
    SpontaneousAlert(
      1,
      DateTime.now().subtract(const Duration(minutes: 10)),
      DateTime.now().add(const Duration(hours: 1)),
      'Really Long Message, Yeah you should probably look into this now :)',
      LatLng(41.1779666, -8.5955153),
      0,
    ),
    Alert(2, DateTime.now(), DateTime.now().add(const Duration(days: 1)), 0),
    Alert(
        3,
        DateTime.now().subtract(
          const Duration(minutes: 1),
        ),
        DateTime.now().add(
          const Duration(hours: 1),
        ),
        1),
    SpontaneousAlert(
      4,
      DateTime.now().subtract(const Duration(hours: 1)),
      DateTime.now().subtract(const Duration(minutes: 10)),
      """
This alert shouldn't appear!""", // maybe this filtering should be done by the controller
      LatLng(41.1784666, -8.5955153),
      0,
    ),
  ];

  final List<AlertType> _alertTypes = [
    AlertType(0, 'Full', 'This Location is Full', const Duration(days: 1),
        Icons.people_outline),
    AlertType(1, 'Noisy', 'This Location is Noisy', const Duration(days: 1),
        Icons.volume_up_outlined),
  ];

  @override
  Future<List<GeneralAlert>> getNearbySpontaneousAlerts(int floor) {
    return Future.value(_alerts
        .where((element) =>
            element is SpontaneousAlert && element.getFloor() == floor)
        .toList());
  }

  @override
  void likeAlert(int alertId) {
    for (var alert in _alerts) {
      if (alert.getId() == alertId) {
        alert.setFinishTime(5);
      }
    }
  }

  @override
  void dislikeAlert(int alertId) {
    for (var alert in _alerts) {
      if (alert.getId() == alertId) {
        alert.setFinishTime(-5);
        print(alert.getFinishTime());
        if (DateTime.now().isAfter(alert.getFinishTime())) {
          _alerts.remove(alert);
        }
      }
    }
  }

  @override
  GeneralAlert getAlert(int id) {
    return _alerts[id];
  }

  @override
  AlertType getAlertType(int id) {
    return _alertTypes[id];
  }
}
