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
    )
  ];

  @override
  Future<List<SpontaneousAlert>> getNearbySpontaneousAlerts() {
    return Future.value(_spontaneousAlerts);
  }
}
