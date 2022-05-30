import 'package:uni/model/entities/live/alert.dart';
import 'package:uni/model/entities/live/alert_type.dart';
import 'package:uni/model/entities/live/general_alert.dart';
import 'package:uni/model/entities/live/point.dart';

abstract class AlertControllerInterface {
  Future<List<GeneralAlert>> getNearbySpontaneousAlerts(int floor);
  Future<List<Alert>> getAlertsOfPoi(PointOfInterest poi);
  Future<GeneralAlert> getAlert(String id);
  Future<AlertType> getAlertType(String id);
  void likeAlert(String alertId);
  bool dislikeAlert(String alertId);
}
