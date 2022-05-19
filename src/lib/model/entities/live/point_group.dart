import 'package:uni/model/entities/live/point.dart';

class PointOfInterestGroup extends PointOfInterest {
  final List<PointOfInterest> _points;

  PointOfInterestGroup(_id, _position, _floor, this._points)
      : super(_id, '', _position, _floor);

  List<PointOfInterest> getPoints() {
    return _points;
  }
}
