import 'package:src/model/general_alert.dart';
import 'package:src/model/alert_type.dart';

class Alert extends GeneralAlert {
  final AlertType _alertType;

  Alert(DateTime startTime, DateTime finishTime, this._alertType)
      : super(startTime, finishTime);

  AlertType getGeneralAlert() {
    return _alertType;
  }
}
