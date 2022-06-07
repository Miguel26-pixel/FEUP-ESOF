import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

import 'package:uni/controller/poi/poi_controller_interface.dart';
import 'package:uni/model/entities/live/point.dart';
import 'package:uni/model/entities/live/poi_type.dart';

import 'package:uni/model/entities/live/point_group.dart';

class MockPointOfInterestController
    implements PointOfInterestControllerInterface {
  static bool _init = false;

  static List<PointOfInterestType> _poiTypes = [];

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

  static Map<String, PointOfInterest> _elements = {};

  MockPointOfInterestController() {
    if (!_init) {
      _poiTypes = [
        PointOfInterestType(
            'Food',
            [
              '0',
              '1',
              '2',
              '3',
            ],
            Icons.restaurant),
        PointOfInterestType(
            'Study',
            [
              '0',
              '1',
            ],
            Icons.school_rounded),
        PointOfInterestType(
            'Vending',
            [
              '1',
              '3',
            ],
            Icons.local_convenience_store_rounded),
        PointOfInterestType('Parking', ['1'], Icons.local_parking_rounded),
        PointOfInterestType(
            'Printing',
            [
              '1',
              '3',
            ],
            Icons.local_print_shop_rounded),
        PointOfInterestType(
            'Material',
            [
              '1',
              '3',
            ],
            Icons.library_books_rounded),
        PointOfInterestType(
            'Other',
            [
              '0',
              '1',
              '2',
              '3',
            ],
            Icons.devices_other_rounded)
      ];

      _elements = {
        '0': PointOfInterest('0', 'Bar da biblioteca',
            LatLng(41.1774666, -8.5950153), 0, _poiTypes[0]),
        '1': PointOfInterest('1', 'Cantina da Faculdade de Engenharia',
            LatLng(41.176243, -8.595501), 0, _poiTypes[0]),
        '2': PointOfInterest('2', 'Grill da Faculdade de Engenharia',
            LatLng(41.176395, -8.595318), 0, _poiTypes[0]),
        '3': PointOfInterest(
            '3', 'AEFEUP', LatLng(41.176159, -8.596887), 0, _poiTypes[0]),
        '4': PointOfInterest('4', 'Bar de minas',
            LatLng(41.1784362, -8.5972663), 0, _poiTypes[0]),
        '5': PointOfInterest(
            '5', 'Biblioteca', LatLng(41.177546, -8.594634), 0, _poiTypes[1]),
        '7': PointOfInterest(
            '7',
            'Máquina de Café',
            LatLng(
              41.17727714163054,
              -8.595256805419924,
            ),
            1,
            _poiTypes[2]),
        '8': PointOfInterest(
            '8',
            'Vending',
            LatLng(
              41.17727714163054,
              -8.595256805419924,
            ),
            1,
            _poiTypes[2]),
        '9': PointOfInterest(
            '9',
            'Máquina de Café',
            LatLng(
              41.17727714163054,
              -8.595256805419924,
            ),
            2,
            _poiTypes[2]),
        '10': PointOfInterest(
            '10',
            'Vending',
            LatLng(
              41.17727714163054,
              -8.595256805419924,
            ),
            2,
            _poiTypes[2]),
        '11': PointOfInterest(
            '11',
            'Vending2',
            LatLng(
              41.17727714163054,
              -8.595256805419924,
            ),
            1,
            _poiTypes[2]),
        '12': PointOfInterest(
            '12',
            'Coffee2',
            LatLng(
              41.17727714163054,
              -8.595256805419924,
            ),
            1,
            _poiTypes[2]),
      };

      _elements['0'].addAlert('2');
      _elements['0'].addAlert('3');

      _init = !_init;
    }
  }

  @override
  Future<List<PointOfInterestType>> getTypesPOI() {
    return Future.value(_poiTypes);
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
  Future<bool> createPOI(
      String name, LatLng pos, int floor, PointOfInterestType type) {
    _elements[(_elements.length + 1).toString()] = PointOfInterest(
        (_elements.length + 1).toString(), name, pos, floor, type);

    return Future.value(true);
  }

  @override
  Future<List<int>> getFloorLimits() {
    return Future.value([-1, 4]);
  }
}
