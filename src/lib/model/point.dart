import 'package:latlong2/latlong.dart';
import 'package:src/model/alert.dart';

class PointOfInterest {
  LatLng position;
  List<Alert> alerts = [];

  String name;

  PointOfInterest(this.name, this.position);
}
