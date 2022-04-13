import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:src/controller/poi/poi_controller_interface.dart';
import 'package:src/model/alert.dart';
import 'package:src/model/alert_type.dart';
import 'package:src/model/point.dart';

class MockPointOfInterestController
    implements PointOfInterestControllerInterface {
  final List<PointOfInterest> elements = [
    PointOfInterest("Bar da biblioteca", LatLng(41.1774666, -8.5950153), 0),
    PointOfInterest(
        "Cantina da Faculdade de Engenharia", LatLng(41.176243, -8.595501), 0),
    PointOfInterest(
        "Grill da Faculdade de Engenharia", LatLng(41.176395, -8.595318), 0),
    PointOfInterest("AEFEUP", LatLng(41.176159, -8.596887), 0),
    PointOfInterest("Bar de minas", LatLng(41.1784362, -8.5972663), 0),
    PointOfInterest("Biblioteca", LatLng(41.177546, -8.594634), 0),
    PointOfInterest(
        "Máquina de Café",
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        1),
    PointOfInterest(
        "Vending",
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        1),
    PointOfInterest(
        "Máquina de Café",
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        2),
    PointOfInterest(
        "Vending",
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        2),
  ];

  MockPointOfInterestController() {
    AlertType type1 = AlertType("Full", "This Location is Full",
        const Duration(days: 1), Icons.people_outline);
    AlertType type2 = AlertType("Noisy", "This Location is Noisy",
        const Duration(days: 1), Icons.volume_up_outlined);

    Alert alert1 = Alert(
        DateTime.now(), DateTime.now().add(const Duration(days: 1)), type1);

    Alert alert2 = Alert(DateTime.now().subtract(const Duration(minutes: 1)),
        DateTime.now().add(const Duration(hours: 1)), type2);

    elements[0].addAlert(alert1);
    elements[0].addAlert(alert2);
  }

  @override
  Future<List<PointOfInterest>> getNearbyPOI(int floor) {
    return Future.value(
        elements.where((element) => element.getFloor() == floor).toList());
  }
}
