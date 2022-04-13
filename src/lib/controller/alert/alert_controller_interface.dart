import 'package:src/model/spontaneous_alert.dart';

abstract class AlertControllerInterface {
  Future<List<SpontaneousAlert>> getNearbySpontaneousAlerts();
}
