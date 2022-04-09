import 'package:latlong2/latlong.dart';
import 'package:src/controller/poi/poi_controller_interface.dart';
import 'package:src/model/point.dart';

class MockPointOfInterestController
    implements PointOfInterestControllerInterface {
  final List<PointOfInterest> elements = [
    PointOfInterest("Bar da biblioteca", LatLng(41.1774666, -8.5950153)),
    PointOfInterest(
        "Cantina da Faculdade de Engenharia", LatLng(41.176243, -8.595501)),
    PointOfInterest(
        "Grill da Faculdade de Engenharia", LatLng(41.176395, -8.595318)),
    PointOfInterest("AEFEUP", LatLng(41.176159, -8.596887)),
    PointOfInterest("Bar de minas", LatLng(41.1784362, -8.5972663)),
    PointOfInterest("Biblioteca", LatLng(41.177546, -8.594634)),
  ];

  @override
  Future<List<PointOfInterest>> getNearbyPOI() {
    return Future.value(elements);
  }
}
