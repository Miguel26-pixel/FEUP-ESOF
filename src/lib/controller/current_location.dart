import 'dart:async';

import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class CurrentLocationController {
  Location location = Location();
  bool serviceEnabled = false;
  late PermissionStatus permissionGranted;

  Future<bool> verifySetup() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  LatLng? parseLocation(LocationData data) {
    var lat = data.latitude;
    var long = data.longitude;

    if (lat != null && long != null) {
      return LatLng(lat, long);
    }

    return null;
  }

  Future<LatLng?> getCurrentLocation() async {
    bool authorized = await verifySetup();

    if (!authorized) {
      return null;
    }

    LocationData data = await location.getLocation();

    return parseLocation(data);
  }

  Future<StreamSubscription<LocationData>?> subscribeLocationUpdate(
      Function(LatLng?) callback) async {
    bool authorized = await verifySetup();

    if (!authorized) {
      return null;
    }

    return location.onLocationChanged
        .listen((data) => callback(parseLocation(data)));
  }
}
