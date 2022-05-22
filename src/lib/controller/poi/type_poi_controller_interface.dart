import 'package:uni/model/entities/live/alert_type.dart';
import 'package:uni/model/entities/live/poi_type.dart';
import 'package:uni/model/entities/live/point.dart';
import 'package:latlong2/latlong.dart';


abstract class TypeOfPOIControllerInterface {
  Future<String> getName();
}
