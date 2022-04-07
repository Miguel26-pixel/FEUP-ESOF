import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:src/controller/current_location.dart';

class Map extends StatefulWidget {
  Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  CurrentLocationController currentLocationController =
      CurrentLocationController();

  LatLng? currentLocation;
  bool loaded = false;

  @override
  void initState() {
    currentLocationController.getCurrentLocation().then((value) => {
          setState(() {
            currentLocation = value;
            loaded = value != null;
          })
        });

    currentLocationController.subscribeLocationUpdate((value) => setState(
          () {
            currentLocation = value;
            if (value != null) {
              loaded = true;
            }
          },
        ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? FlutterMap(
            options: MapOptions(
              center: currentLocation,
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
                    point: currentLocation!,
                    builder: (ctx) => Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
