import 'dart:math';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/controller/alert/alert_mock_controller.dart';
import 'package:uni/model/entities/live/spontaneous_alert.dart';

class AlertController extends AlertMockController {
  DateTime parseDate(dynamic dataObj) {
    final seconds = dataObj['_seconds'];
    final nanoseconds = dataObj['_nanoseconds'];
    return DateTime.fromMicrosecondsSinceEpoch(
        (seconds * pow(10, 6) + nanoseconds / pow(10, 3)).toInt());
  }

  @override
  Future<List<SpontaneousAlert>> getNearbySpontaneousAlerts(
      int floor, LatLng currentPosition) async {
    final Response res = await get(Uri.parse(
        'https://us-central1-liveup-7c242.cloudfunctions.net/widgets/alerts/spontaneous?floor=${floor.toString()}'));

    if (res.statusCode != 200) {
      throw Exception('Network error');
    }

    final decoded = jsonDecode(res.body);

    final List<SpontaneousAlert> alerts =
        decoded['data'].map<SpontaneousAlert>((element) {
      final finishTime = this.parseDate(element['finish-time']);
      final startTime = this.parseDate(element['start-time']);
      final floor = element['floor'];

      final lat = element['position']['_latitude'];
      final lng = element['position']['_longitude'];
      final LatLng position = LatLng(lat, lng);

      final message = element['message'];
      final id = element['id'];

      return SpontaneousAlert(
          id, startTime, finishTime, message, position, floor);
    }).toList();

    return alerts;
  }
}
