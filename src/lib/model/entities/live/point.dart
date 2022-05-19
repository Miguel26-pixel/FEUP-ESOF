import 'package:latlong2/latlong.dart';

class PointOfInterest {
  final String _name;
  final LatLng _position;
  final int _floor;
  final List<String> _alertIds = [];
  final String _id;

  PointOfInterest(this._id, this._name, this._position, this._floor);

  List<String> getAlertIds() {
    return _alertIds;
  }

  void addAlert(String alertId) {
    _alertIds.add(alertId);
  }

  String getName() {
    return _name;
  }

  String getId() {
    return _id;
  }

  LatLng getPosition() {
    return _position;
  }

  int getFloor() {
    return _floor;
  }
}
