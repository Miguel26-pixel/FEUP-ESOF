import 'dart:convert';

import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/controller/poi/poi_mock_controller.dart';
import 'package:uni/model/entities/live/poi_type.dart';
import 'package:uni/model/entities/live/point.dart';
import 'package:uni/model/entities/live/point_group.dart';

class PointOfInterestController extends MockPointOfInterestController {
  @override
  Future<List<int>> getFloorLimits() async {
    final Response res = await get(Uri.parse(
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
    final Response res = await get(Uri.parse(
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
          PointOfInterest(id, name, position, floor, null);
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
            PointOfInterest(id, name, position, floor, null);
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

  @override
  Future<bool> createPOI(
      String name, LatLng pos, int floor, PointOfInterestType type) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final body = {
      'floor': floor,
      'location': {'latitude': pos.latitude, 'longitude': pos.longitude},
      'name': name
    };

    final Response res = await post(
      Uri.parse(
          'https://us-central1-liveup-7c242.cloudfunctions.net/widgets/points/new'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      return false;
    }

    return true;
  }
}
