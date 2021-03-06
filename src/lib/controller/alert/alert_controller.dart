import 'dart:math';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/alert/alert_controller_interface.dart';
import 'package:uni/model/entities/live/alert.dart';
import 'package:uni/model/entities/live/alert_type.dart';
import 'package:uni/model/entities/live/general_alert.dart';
import 'package:uni/model/entities/live/point.dart';
import 'package:uni/model/entities/live/spontaneous_alert.dart';

class AlertController implements AlertControllerInterface {
  DateTime parseDate(dynamic dataObj) {
    final seconds = dataObj['_seconds'];
    final nanoseconds = dataObj['_nanoseconds'];
    return DateTime.fromMicrosecondsSinceEpoch(
        (seconds * pow(10, 6) + nanoseconds / pow(10, 3)).toInt());
  }

  @override
  Future<List<Alert>> getAlertsOfPoi(PointOfInterest poi) async {
    final Response res = await get(Uri.parse(
        'https://us-central1-liveup-7c242.cloudfunctions.net/widgets/point/${poi.getId()}/alerts'));

    if (res.statusCode != 200) {
      throw Exception('Network error');
    }

    final decoded = jsonDecode(res.body);

    final List<Alert> alerts = decoded['data'].map<Alert>((element) {
      final finishTime = this.parseDate(element['finish-time']);
      final startTime = this.parseDate(element['start-time']);
      final id = element['id'];

      final typeElement = element['type'];
      final typeMessage = typeElement['message'];
      final typeName = typeElement['name'];
      final typeDuration = typeElement['base-duration-seconds'];
      final typeId = typeElement['id'];
      final typeIcon = int.parse(typeElement['icon']);
      final AlertType alertType = AlertType(
          typeId,
          typeName,
          typeMessage,
          Duration(seconds: typeDuration),
          IconData(typeIcon, fontFamily: 'MaterialIcons'));

      return Alert(id, startTime, finishTime, alertType);
    }).toList();

    return alerts;
  }

  @override
  Future<Tuple2<bool, String>> createSpontaneousAlert(
      String description, int floor, LatLng position) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final body = {
      'floor': floor,
      'location': {
        'latitude': position.latitude,
        'longitude': position.longitude
      },
      'message': description
    };

    final Response res = await post(
      Uri.parse(
          'https://us-central1-liveup-7c242.cloudfunctions.net/widgets/alerts/spontaneous/new'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      return Tuple2(false, 'Unknown error');
    }

    return Tuple2(true, '');
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

  @override
  Future<void> likeAlert(String alertId, bool spontaneous) async {
    final Response res = await post(Uri.parse(
        'https://us-central1-liveup-7c242.cloudfunctions.net/widgets/alerts/${spontaneous ? "spontaneous/" : ""}${alertId}/accept'));

    if (res.statusCode != 200) {
      throw Exception('Network error');
    }
  }

  @override
  Future<bool> dislikeAlert(String alertId, bool spontaneous) async {
    final Response res = await post(Uri.parse(
        'https://us-central1-liveup-7c242.cloudfunctions.net/widgets/alerts/${spontaneous ? "spontaneous/" : ""}${alertId}/reject'));

    if (res.statusCode != 200) {
      throw Exception('Network error');
    }

    final decoded = jsonDecode(res.body);

    return decoded['deleted'];
  }

  @override
  Future<Tuple2<bool, String>> createAlert(
      PointOfInterest pointOfInterest, AlertType alert) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final body = {'type': alert.getId()};
    final Response res = await post(
      Uri.parse(
          'https://us-central1-liveup-7c242.cloudfunctions.net/widgets/points/${pointOfInterest.getId()}/alerts/new'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception('Network error');
    }

    return Tuple2(true, '');
  }

  @override
  Future<GeneralAlert> getAlert(String id) {
    // TODO: implement getAlert
    throw UnimplementedError();
  }

  @override
  Future<AlertType> getAlertType(String id) {
    // TODO: implement getAlertType
    throw UnimplementedError();
  }

  @override
  Future<List<AlertType>> getAlertTypes() async {
    final Response res = await get(Uri.parse(
        'https://us-central1-liveup-7c242.cloudfunctions.net/widgets//alert/types'));

    if (res.statusCode != 200) {
      throw Exception('Network error');
    }

    final decoded = jsonDecode(res.body);

    final List<AlertType> alertTypes =
        decoded['data'].map<AlertType>((element) {
      final id = element['id'];
      final name = element['name'];
      final duration = Duration(seconds: element['base-duration-seconds']);
      final message = element['message'];
      final icon = int.parse(element['icon']);

      return AlertType(id, name, message, duration,
          IconData(icon, fontFamily: 'MaterialIcons'));
    }).toList();

    return alertTypes;
  }

  @override
  Future<Map<String, AlertType>> getAllAlertTypes() {
    // TODO: implement getAllAlertTypes
    throw UnimplementedError();
  }
}
