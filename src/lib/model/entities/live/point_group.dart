import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/live/point.dart';

class PointOfInterestGroup extends PointOfInterest {
  final List<PointOfInterest> _points;

  PointOfInterestGroup(_position, _floor, this._points)
      : super('', _position, _floor);

  List<PointOfInterest> getPoints() {
    return _points;
  }
}
