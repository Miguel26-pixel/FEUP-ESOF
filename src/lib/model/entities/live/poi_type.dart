import 'package:uni/model/entities/live/alert_type.dart';

class PointOfInterestType {
  final String _name;
  final List<AlertType> _alerts;

  PointOfInterestType(this._name, this._alerts);

  String getName(){
    return _name;
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
