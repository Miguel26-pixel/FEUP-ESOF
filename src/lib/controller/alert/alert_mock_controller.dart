import 'package:latlong2/latlong.dart';
import 'package:src/controller/alert/alert_controller_interface.dart';
import 'package:src/model/spontaneous_alert.dart';

class AlertMockController implements AlertControllerInterface {
  final List<SpontaneousAlert> _spontaneousAlerts = [
    SpontaneousAlert(
      DateTime.now().subtract(const Duration(hours: 1)),
      DateTime.now().add(const Duration(hours: 1)),
      "Spilt Coffee",
      LatLng(41.1775666, -8.5955153),
    ),
    SpontaneousAlert(
      DateTime.now().subtract(const Duration(minutes: 10)),
      DateTime.now().add(const Duration(hours: 1)),
      "Really Long Message, Yeah you should probably look into this now :)",
      LatLng(41.1779666, -8.5955153),
    ),
    SpontaneousAlert(
      DateTime.now().subtract(const Duration(hours: 1)),
      DateTime.now().subtract(const Duration(minutes: 10)),
      "This alert shouldn't appear!", // maybe this filtering should be done by the controller
      LatLng(41.1784666, -8.5955153),
    )
  ];

  @override
  Future<List<SpontaneousAlert>> getNearbySpontaneousAlerts() {
    return Future.value(_spontaneousAlerts);
  }
}
