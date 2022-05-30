import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/live/point.dart';

abstract class PointOfInterestControllerInterface {
  Future<List<PointOfInterest>> getNearbyPOI(int floor, LatLng position);
  Future<List<int>> getFloorLimits();
}
