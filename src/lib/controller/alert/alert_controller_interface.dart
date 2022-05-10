import 'package:uni/model/entities/live/spontaneous_alert.dart';

abstract class AlertControllerInterface {
  Future<List<SpontaneousAlert>> getNearbySpontaneousAlerts(int floor);
}
