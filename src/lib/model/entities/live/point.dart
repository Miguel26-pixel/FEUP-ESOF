import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/live/alert.dart';
import 'package:uni/model/entities/live/poi_type.dart';


class PointOfInterest {
  final String _name;
  final LatLng _position;
  final int _floor;
  final PointOfInterestType _type;
  final List<Alert> _alerts = [];

  PointOfInterest(this._id,this._name, this._position, this._floor, this._type);
  final List<String> _alertIds = [];
  final String _id;

  List<String> getAlertIds() {
    return _alertIds;
  }

  bool addAlert(Alert alert) {
    if (_type.checkValidAlert(alert.getAlertType())) {
      _alerts.add(alert);
      return true;
    }
    return false;
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

  PointOfInterestType getType(){
    return _type;
  }
}
