import 'package:uni/model/entities/live/point.dart';

abstract class PointOfInterestControllerInterface {
  Future<List<PointOfInterest>> getNearbyPOI(int floor);
  Future<List<int>> getFloorLimits();
}
