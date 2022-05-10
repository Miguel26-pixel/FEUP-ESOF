import 'package:uni/model/entities/live/spontaneous_alert.dart';
import 'package:uni/model/entities/live/general_alert.dart';

abstract class AlertControllerInterface {
  Future<List<GeneralAlert>> getNearbySpontaneousAlerts(int floor);
  void likeAlert(int alertId);
  void dislikeAlert(int alertId);
}
