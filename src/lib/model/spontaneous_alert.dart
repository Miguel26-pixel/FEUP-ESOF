import 'package:latlong2/latlong.dart';
import 'package:src/model/general_alert.dart';

class SpontaneousAlert extends GeneralAlert {
  final String _message;
  final LatLng _position;

  SpontaneousAlert(
    DateTime startTime,
    DateTime finishTime,
    this._message,
    this._position,
  ) : super(startTime, finishTime);

  String getMessage() {
    return _message;
  }

  LatLng getPosition() {
    return _position;
  }
}
