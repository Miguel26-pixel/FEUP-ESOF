import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:src/controller/alert/alert_controller_interface.dart';
import 'package:src/controller/alert/alert_mock_controller.dart';
import 'package:src/controller/current_location.dart';
import 'package:src/controller/poi/poi_controller_interface.dart';
import 'package:src/controller/poi/poi_mock_controller.dart';
import 'package:src/model/point.dart';
import 'package:src/model/spontaneous_alert.dart';
import 'package:src/view/widget/alert_poi_marker.dart';
import 'package:src/view/widget/poi.dart';
import 'package:src/view/widget/spontaneous_alert.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  CurrentLocationController currentLocationController =
      CurrentLocationController();
  PointOfInterestControllerInterface pointOfInterestController =
      MockPointOfInterestController();
  AlertControllerInterface alertController = AlertMockController();

  LatLng? _currentLocation;
  bool _loaded = false;
  List<PointOfInterest> _pointsOfInterest = [];
  List<SpontaneousAlert> _spontaneousAlerts = [];

  @override
  void initState() {
    currentLocationController.getCurrentLocation().then((value) => {
          setState(() {
            _currentLocation = value;
            _loaded = value != null;
          })
        });

    currentLocationController.subscribeLocationUpdate((value) => setState(
          () {
            _currentLocation = value;
            if (value != null) {
              _loaded = true;
            }
          },
        ));

    pointOfInterestController.getNearbyPOI().then((value) => setState(() {
          _pointsOfInterest = value;
        }));

    alertController.getNearbySpontaneousAlerts().then((value) => setState(() {
          _spontaneousAlerts = value;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = _pointsOfInterest
        .map(
          (e) => AlertPoiMarker(
            context: context,
            point: e.getPosition(),
            pressedBuilder: ((context) => PointOfInterestPage(e)),
            iconData: Icons.room,
          ),
        )
        .toList();

    List<Marker> alertMarkers = _spontaneousAlerts
        .map((e) => AlertPoiMarker(
              context: context,
              size: 40,
              point: e.getPosition(),
              pressedBuilder: ((context) =>
                  SpontaneousAlertPage(e, currentLocationController)),
              iconData: Icons.warning_rounded,
            ))
        .toList();

    markers.addAll(alertMarkers);

    return _loaded
        ? FlutterMap(
            options: MapOptions(
              center: _currentLocation,
              zoom: 18.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 15.0,
                    height: 15.0,
                    point: _currentLocation!,
                    builder: (ctx) => Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              MarkerLayerOptions(
                markers: markers,
              )
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
