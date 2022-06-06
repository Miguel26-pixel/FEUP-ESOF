import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/live/point.dart';
import 'package:uni/model/entities/live/poi_type.dart';

abstract class PointOfInterestControllerInterface {
  Future<List<PointOfInterest>> getNearbyPOI(int floor, LatLng position);
  Future<bool> createPOI(
      String name, LatLng pos, int floor, PointOfInterestType type);
  Future<List<int>> getFloorLimits();
  Future<List<PointOfInterestType>> getTypesPOI();
}
