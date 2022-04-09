import 'package:latlong2/latlong.dart';
import 'package:src/model/alert.dart';

class PointOfInterest {
  final String _name;
  final LatLng _position;
  final int _floor;
  final List<Alert> _alerts = [];

  PointOfInterest(this._name, this._position, this._floor);

  List<Alert> getAlerts() {
    return this._alerts;
  }

  void addAlert(Alert alert) {
    this._alerts.add(alert);
  }

  String getName() {
    return this._name;
  }

  LatLng getPosition() {
    return this._position;
  }

  int getFloor() {
    return this._floor;
  }
}
