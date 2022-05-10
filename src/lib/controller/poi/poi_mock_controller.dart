import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:uni/controller/poi/poi_controller_interface.dart';
import 'package:uni/model/entities/live/alert.dart';
import 'package:uni/model/entities/live/alert_type.dart';
import 'package:uni/model/entities/live/point.dart';

class MockPointOfInterestController
    implements PointOfInterestControllerInterface {
  final List<PointOfInterest> elements = [
    PointOfInterest('Bar da biblioteca', LatLng(41.1774666, -8.5950153), 0),
    PointOfInterest(
        'Cantina da Faculdade de Engenharia', LatLng(41.176243, -8.595501), 0),
    PointOfInterest(
        'Grill da Faculdade de Engenharia', LatLng(41.176395, -8.595318), 0),
    PointOfInterest('AEFEUP', LatLng(41.176159, -8.596887), 0),
    PointOfInterest('Bar de minas', LatLng(41.1784362, -8.5972663), 0),
    PointOfInterest('Biblioteca', LatLng(41.177546, -8.594634), 0),
    PointOfInterest(
        'Máquina de Café',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        1),
    PointOfInterest(
        'Vending',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        1),
    PointOfInterest(
        'Máquina de Café',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        2),
    PointOfInterest(
        'Vending',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        2),
  ];

  MockPointOfInterestController() {
    elements[0].addAlert(2);
    elements[0].addAlert(3);
  }

  @override
  Future<List<PointOfInterest>> getNearbyPOI(int floor) {
    return Future.value(
        elements.where((element) => element.getFloor() == floor).toList());
  }

  @override
  Future<List<int>> getFloorLimits() {
    return Future.value([-1, 4]);
  }
}
