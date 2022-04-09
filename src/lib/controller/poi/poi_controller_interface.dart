import 'package:src/model/point.dart';

abstract class PointOfInterestControllerInterface {
  Future<List<PointOfInterest>> getNearbyPOI();
}
