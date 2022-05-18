import 'package:uni/model/entities/live/general_alert.dart';

class Alert extends GeneralAlert {
  final String _alertTypeId;

  Alert(String id, DateTime startTime, DateTime finishTime, this._alertTypeId)
      : super(id, startTime, finishTime);

  String getAlertTypeId() {
    return _alertTypeId;
  }
}
