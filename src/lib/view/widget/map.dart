import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:src/controller/current_location.dart';
import 'package:src/controller/poi/poi_mock_controller.dart';
import 'package:src/model/point.dart';

class Map extends StatefulWidget {
  Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  CurrentLocationController currentLocationController =
      CurrentLocationController();
  MockPointOfInterestController pointOfInterestController =
      MockPointOfInterestController();

  LatLng? _currentLocation;
  bool _loaded = false;
  late List<PointOfInterest> _pointsOfInterest;

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> poiMarkers = _pointsOfInterest
        .map((e) => Marker(
              point: e.position,
              builder: (ctx) => const Icon(
                Icons.room,
                size: 35.0,
              ),
            ))
        .toList();

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
                markers: poiMarkers,
              )
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
