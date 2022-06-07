import 'dart:async';

import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'current_location.dart';

class MockCurrentLocationController extends CurrentLocationController {
  @override
  Future<bool> verifySetup() async {
    return Future.value(true);
  }

  @override
  LatLng parseLocation(LocationData data) {
    if (data.latitude == null) {
      return null;
    }

    return LatLng(data.latitude, data.longitude);
  }

  @override
  Future<LatLng> getCurrentLocation() async {
    return Future.value(LatLng(41.17763561079476, -8.595533340337024));
  }

  @override
  // ignore: missing_return
  Future<StreamSubscription<LocationData>> subscribeLocationUpdate(
      Function(LatLng) callback) async {}
}
