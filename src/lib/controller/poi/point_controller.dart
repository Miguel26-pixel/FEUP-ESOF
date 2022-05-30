import 'dart:convert';

import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/controller/poi/poi_controller_interface.dart';
import 'package:uni/model/entities/live/point.dart';
import 'package:uni/model/entities/live/point_group.dart';

class PointOfInterestController implements PointOfInterestControllerInterface {
  @override
  Future<List<int>> getFloorLimits() async {
    Response res = await get(Uri.parse(
        'https://us-central1-liveup-7c242.cloudfunctions.net/widgets/points/limits'));

    if (res.statusCode != 200) {
      throw Exception('Failed to get floor limits');
    }

    final Map<String, dynamic> decoded = jsonDecode(res.body);

    return List.from(decoded['data']);
  }

  @override
  Future<List<PointOfInterest>> getNearbyPOI(
      int floor, LatLng currentPosition) async {
    final double latitude = currentPosition.latitude;
    final double longitude = currentPosition.longitude;

    Response res = await get(Uri.parse(
        'https://us-central1-liveup-7c242.cloudfunctions.net/widgets/points?floor=${floor.toString()}'));

    if (res.statusCode != 200) {
      throw Exception('Network error');
    }

    final decoded = jsonDecode(res.body);

    final List<PointOfInterest> points =
        decoded['points'].map<PointOfInterest>((element) {
      final lat = element['position']['_latitude'];
      final lng = element['position']['_longitude'];
      final LatLng position = LatLng(lat, lng);

      final name = element['name'];
      final floor = element['floor'];
      final alertIds = element['alerts'];
      final id = element['id'];

      final PointOfInterest pointOfInterest =
          PointOfInterest(id, name, position, floor);
      alertIds.forEach((element) {
        pointOfInterest.addAlert(id);
      });

      return pointOfInterest;
    }).toList();

    final List<PointOfInterestGroup> groups =
        decoded['groups'].map<PointOfInterestGroup>((element) {
      final lat = element['position']['_latitude'];
      final lng = element['position']['_longitude'];
      final LatLng position = LatLng(lat, lng);
      final floor = element['floor'];

      final List<PointOfInterest> points =
          element['points'].map<PointOfInterest>((element) {
        final name = element['name'];
        final alertIds = element['alerts'];
        final id = element['id'];

        final PointOfInterest pointOfInterest =
            PointOfInterest(id, name, position, floor);
        alertIds.forEach((element) {
          pointOfInterest.addAlert(id);
        });

        return pointOfInterest;
      }).toList();

      return PointOfInterestGroup('', position, floor, points);
    }).toList();

    points.addAll(groups);
    return points;
  }
}
