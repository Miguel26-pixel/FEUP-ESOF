import 'package:flutter/material.dart';
import 'package:uni/model/entities/live/alert_type.dart';

class PointOfInterestType {
  final String _name;
  final List<AlertType> _alerts;
  final IconData _icon;

  PointOfInterestType(this._name, this._alerts, this._icon);

  String getName(){
    return _name;
  }

  IconData getIcon(){
    return _icon;
  }

  bool checkValidAlert(AlertType alert){
    _alerts.forEach((element) {
      if (element.getName() == alert.getName()){
        return true;
      }
    });

    return false;
  }

}
