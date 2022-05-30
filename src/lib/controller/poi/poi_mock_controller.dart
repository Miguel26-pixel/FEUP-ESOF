import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

import 'package:uni/controller/poi/poi_controller_interface.dart';
import 'package:uni/model/entities/live/point.dart';
import 'package:uni/model/entities/live/point_group.dart';

class MockPointOfInterestController
    implements PointOfInterestControllerInterface {
  static bool _init = false;
  static final _groups = <String, PointOfInterestGroup>{
    '6': PointOfInterestGroup(
      '6',
      LatLng(
        41.17727714163054,
        -8.595256805419924,
      ),
      1,
      [
        _elements['7'],
        _elements['8'],
        _elements['11'],
        _elements['12'],
      ],
    ),
  };

  static final _elements = <String, PointOfInterest>{
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
    '7': PointOfInterest(
        '7',
        'Máquina de Café',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        1),
    '8': PointOfInterest(
        '8',
        'Vending',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        1),
    '9': PointOfInterest(
        '9',
        'Máquina de Café',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        2),
    '10': PointOfInterest(
        '10',
        'Vending',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        2),
    '11': PointOfInterest(
        '11',
        'Vending2',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        1),
    '12': PointOfInterest(
        '12',
        'Coffee2',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        1),
  };

  MockPointOfInterestController() {
    if (!_init) {
      _elements['0'].addAlert('2');
      _elements['0'].addAlert('3');

      _init = !_init;
    }
  }

  @override
  Future<List<PointOfInterest>> getNearbyPOI(int floor, LatLng _) {
    final List<PointOfInterestGroup> groups =
        _groups.values.where((element) => element.getFloor() == floor).toList();
    final Set<String> loadedIDs = groups
        .expand((element) => element.getPoints().map((e) => e.getId()))
        .toSet();
    final result = _elements.values
        .where((element) =>
            !loadedIDs.contains(element.getId()) && element.getFloor() == floor)
        .toList();
    result.addAll(groups);

    return Future.value(result);
  }

  @override
  Future<List<int>> getFloorLimits() {
    return Future.value([-1, 4]);
  }
}
