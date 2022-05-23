import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:uni/controller/poi/poi_controller_interface.dart';
import 'package:uni/model/entities/live/alert.dart';
import 'package:uni/model/entities/live/alert_type.dart';
import 'package:uni/model/entities/live/point.dart';
import 'package:uni/model/entities/live/poi_type.dart';


class MockPointOfInterestController
    implements PointOfInterestControllerInterface {
  
  List<PointOfInterest> elements;
  List<AlertType> alertTypes;
  List<PointOfInterestType> poiTypes ;
  

  MockPointOfInterestController() {

    alertTypes = [
    AlertType('Noisy', 'This Location is Noisy',
      const Duration(days: 1), Icons.volume_up_outlined),
    AlertType('Full', 'This Location is Full',
      const Duration(days: 1), Icons.people_outline),
    AlertType('Cleaning', 'This Location is being cleaned',
      const Duration(days: 1), Icons.people_outline),
    AlertType('Out of service', 'This Location is out of service',
      const Duration(days: 1), Icons.people_outline)
  ];

  poiTypes = [ 
    PointOfInterestType('Food', alertTypes,Icons.restaurant),
    PointOfInterestType('Study', [alertTypes[0], alertTypes[1]], Icons.library_books_rounded),
    PointOfInterestType('Vending', [alertTypes[1], alertTypes[3]], Icons.local_convenience_store_rounded),
    PointOfInterestType('Parking', [alertTypes[1]],Icons.local_parking_rounded),
    PointOfInterestType('Printing', [alertTypes[1], alertTypes[3]], Icons.local_print_shop_rounded),
    PointOfInterestType('Material', [alertTypes[1], alertTypes[3]], Icons.school_rounded),
    PointOfInterestType('Other', alertTypes,  Icons.devices_other_rounded),];


    final Alert alert1 = Alert(
        DateTime.now(), DateTime.now().add(const Duration(days: 1))
        , alertTypes[0]);

    final Alert alert2 = Alert(
        DateTime.now().subtract(
          const Duration(minutes: 1),
        ),
        DateTime.now().add(const Duration(hours: 1)),
        alertTypes[1]);
    
    elements = [
    PointOfInterest(
      'Bar da biblioteca', LatLng(41.1774666, -8.5950153), 0, poiTypes[0]),
    PointOfInterest(
        'Cantina da Faculdade de Engenharia', LatLng(41.176243, -8.595501)
        , 0, poiTypes[0]),
    PointOfInterest(
        'Grill da Faculdade de Engenharia', LatLng(41.176395, -8.595318),
         0, poiTypes[0]),
    PointOfInterest('AEFEUP', LatLng(41.176159, -8.596887), 0, poiTypes[0]),
    PointOfInterest('Bar de minas', LatLng(41.1784362, -8.5972663),
     0, poiTypes[0]),
    PointOfInterest('Biblioteca', LatLng(41.177546, -8.594634), 0, poiTypes[2]),
    PointOfInterest(
        'Máquina de Café',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        1, poiTypes[1]),
    PointOfInterest(
        'Vending',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        1, poiTypes[1]),
    PointOfInterest(
        'Máquina de Café',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        2, poiTypes[1]),
    PointOfInterest(
        'Vending',
        LatLng(
          41.17727714163054,
          -8.595256805419924,
        ),
        2, poiTypes[1]),
  ];


    elements[0].addAlert(alert1);
    elements[0].addAlert(alert2);
  }

  @override
  Future<List<PointOfInterestType>> getTypesPOI(){
    return Future.value(poiTypes);
  }
  

  @override
  Future<List<PointOfInterest>> getNearbyPOI(int floor) {
    return Future.value(
        elements.where((element) => element.getFloor() == floor).toList());
  }

  @override
  Future<bool> createPOI(String name, LatLng pos, int floor,
   PointOfInterestType type){

    print(elements.length);
    elements.add(PointOfInterest(name, pos, floor, type));
    print("added");
    print(elements.length);


    return Future.value(true);

  }

  @override
  Future<List<int>> getFloorLimits() {
    return Future.value([-1, 4]);
  }
}
