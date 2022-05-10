import 'package:uni/model/entities/live/alert_type.dart';
import 'package:uni/model/entities/live/general_alert.dart';

abstract class AlertControllerInterface {
  Future<List<GeneralAlert>> getNearbySpontaneousAlerts(int floor);
  GeneralAlert getAlert(int id);
  AlertType getAlertType(int id);
  void likeAlert(int alertId);
  void dislikeAlert(int alertId);
}
