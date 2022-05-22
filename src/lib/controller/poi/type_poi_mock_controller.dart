import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:uni/controller/poi/poi_mock_controller.dart';
import 'package:uni/controller/poi/type_poi_controller_interface.dart';

import 'package:uni/model/entities/live/poi_type.dart';


class MockTypePOIController
    implements TypeOfPOIControllerInterface {

  List<PointOfInterestType> types;

  MockTypePOIController(){

    MockPointOfInterestController().getTypesPOI().then((response){
      types = [... response];
    });

  }

  @override
  Future<String> getName(){
    return Future.value(types.first.getName());
  }

}