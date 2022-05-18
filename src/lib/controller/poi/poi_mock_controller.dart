import 'package:latlong2/latlong.dart';

import 'package:uni/controller/poi/poi_controller_interface.dart';
import 'package:uni/model/entities/live/point.dart';

class MockPointOfInterestController
    implements PointOfInterestControllerInterface {
  final _elements = <String, PointOfInterest>{
    '0': PointOfInterest(
        '0', 'Bar da biblioteca', LatLng(41.1774666, -8.5950153), 0),
    '1': PointOfInterest('1', 'Cantina da Faculdade de Engenharia',
        LatLng(41.176243, -8.595501), 0),
    '2': PointOfInterest('2', 'Grill da Faculdade de Engenharia',
        LatLng(41.176395, -8.595318), 0),
    '3': PointOfInterest('3', 'AEFEUP', LatLng(41.176159, -8.596887), 0),
    '4':
        PointOfInterest('4', 'Bar de minas', LatLng(41.1784362, -8.5972663), 0),
    '5': PointOfInterest('5', 'Biblioteca', LatLng(41.177546, -8.594634), 0),
    '6': PointOfInterest(
        '6',
        'Máquina de Café',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        1),
    '7': PointOfInterest(
        '7',
        'Vending',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        1),
    '8': PointOfInterest(
        '8',
        'Máquina de Café',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        2),
    '9': PointOfInterest(
        '9',
        'Vending',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        2),
  };

  MockPointOfInterestController() {
    _elements['0'].addAlert('2');
    _elements['0'].addAlert('3');
  }

  @override
  Future<List<PointOfInterest>> getNearbyPOI(int floor) {
    return Future.value(_elements.values
        .where((element) => element.getFloor() == floor)
        .toList());
  }

  @override
  Future<List<int>> getFloorLimits() {
    return Future.value([-1, 4]);
  }
}
