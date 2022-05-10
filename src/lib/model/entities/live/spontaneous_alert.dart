import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/live/general_alert.dart';

class SpontaneousAlert extends GeneralAlert {
  final String _message;
  final LatLng _position;
  final int _floor;
  DateTime startTime;
  DateTime finishTime;

  SpontaneousAlert(
      int id,
    DateTime startTime,
    DateTime finishTime,
    this._message,
    this._position,
    this._floor,
  ) : super(id, startTime, finishTime);

  String getMessage() {
    return _message;
  }

  LatLng getPosition() {
    return _position;
  }

  int getFloor() {
    return _floor;
  }
}
