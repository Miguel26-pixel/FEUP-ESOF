import 'package:latlong2/latlong.dart';
import 'package:src/model/alert.dart';

class PointOfInterest {
  final String _name;
  final LatLng _position;
  final int _floor;
  final List<Alert> _alerts = [];

  PointOfInterest(this._name, this._position, this._floor);

  List<Alert> getAlerts() {
    return _alerts;
  }

  void addAlert(Alert alert) {
    _alerts.add(alert);
  }

  String getName() {
    return _name;
  }

  LatLng getPosition() {
    return _position;
  }

  int getFloor() {
    return _floor;
  }
}
