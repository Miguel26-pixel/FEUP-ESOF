import 'package:latlong2/latlong.dart';

class PointOfInterest {
  final String _name;
  final LatLng _position;
  final int _floor;
  final List<int> _alertIds = [];

  PointOfInterest(this._name, this._position, this._floor);

  List<int> getAlertIds() {
    return _alertIds;
  }

  void addAlert(int alertId) {
    _alertIds.add(alertId);
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
