import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class CurrentLocationController {
  Location location = Location();
  bool serviceEnabled = false;
  PermissionStatus permissionGranted;

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

  LatLng parseLocation(LocationData data) {
    if (data.latitude == null) {
      return null;
    }

    return LatLng(data.latitude, data.longitude);
  }

  Future<LatLng> getCurrentLocation() async {
    final bool authorized = await verifySetup();

    if (!authorized) {
      return null;
    }

    final LocationData data = await location.getLocation();

    return parseLocation(data);
  }

  void subscribeLocationUpdate(Function(LatLng) callback) async {
    final bool authorized = await verifySetup();

    if (!authorized) {
      return;
    }

    location.onLocationChanged.listen((data) => callback(parseLocation(data)));
  }
}
