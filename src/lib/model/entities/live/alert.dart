import 'package:uni/model/entities/live/alert_type.dart';
import 'package:uni/model/entities/live/general_alert.dart';

class Alert extends GeneralAlert {
  final int _alertTypeId;

  Alert(int id, DateTime startTime, DateTime finishTime, this._alertTypeId)
      : super(id, startTime, finishTime);

  int getAlertTypeId() {
    return _alertTypeId;
  }
}
