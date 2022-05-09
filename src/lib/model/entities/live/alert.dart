import 'package:uni/model/entities/live/alert_type.dart';
import 'package:uni/model/general_alert.dart';

class Alert extends GeneralAlert {
  final AlertType _alertType;

  Alert(DateTime startTime, DateTime finishTime, this._alertType)
      : super(startTime, finishTime);

  AlertType getType() {
    return _alertType;
  }
}
