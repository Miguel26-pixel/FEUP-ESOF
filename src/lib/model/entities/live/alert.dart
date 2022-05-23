import 'package:uni/model/entities/live/alert_type.dart';
import 'package:uni/model/entities/live/general_alert.dart';

class Alert extends GeneralAlert {
  final AlertType _alertType;

  Alert(String id, DateTime startTime, DateTime finishTime, this._alertType)
      : super(id, startTime, finishTime);


  AlertType getAlertType() {
    return _alertType;
  }
}
