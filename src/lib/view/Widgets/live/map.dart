import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:uni/assets/constants/map.dart';
import 'package:uni/controller/alert/alert_controller.dart';
import 'package:uni/controller/alert/alert_controller_interface.dart';
import 'package:uni/controller/alert/alert_mock_controller.dart';
import 'package:uni/controller/current_location.dart';
import 'package:uni/controller/poi/poi_controller_interface.dart';
import 'package:uni/controller/poi/point_controller.dart';
import 'package:uni/model/entities/live/point.dart';
import 'package:uni/model/entities/live/spontaneous_alert.dart';
import 'package:uni/view/Widgets/live/create_spontaneous_alert.dart';
import 'package:uni/view/Widgets/live/poi.dart';
import 'package:uni/view/Widgets/live/alert_poi_marker.dart';
import 'package:uni/view/Widgets/live/spontaneous_alert.dart';

import 'alert_poi_marker.dart';

class Map extends StatefulWidget {
  const Map({Key key, this.alertController, this.pointOfInterestController})
      : super(key: key);

  final PointOfInterestControllerInterface pointOfInterestController;
  final AlertControllerInterface alertController;

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  CurrentLocationController currentLocationController =
      CurrentLocationController();

  final double _initialZoom = 18.3;

  LatLng _currentLocation;

  int _currentFloor = 0;
  int _maxFloor;
  int _minFloor;
  LatLng _center = FEUP_POS;
  bool _locationLoaded;
  bool _floorsLoaded;
  bool _followingCurrentPosition;
  List<PointOfInterest> _pointsOfInterest = [];
  List<SpontaneousAlert> _spontaneousAlerts = [];
  StreamSubscription<LocationData> _subscription;

  final MapController _mapController = MapController();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void setMapCenter(LatLng center) {
    _center = center;
    _mapController.move(center, _initialZoom);
  }

  void followLocation() {
    if (_locationLoaded) {
      setState(() {
        _followingCurrentPosition = true;
      });
      setMapCenter(_currentLocation);
    }
  }

  void unfollowLocation(MapPosition position, bool hasGesture) {
    _center = position.center;
    if (_locationLoaded) {
      _followingCurrentPosition = !hasGesture;
    }
  }

  void incrementFloor() {
    if (_currentFloor != _maxFloor) {
      setState(() {
        _currentFloor++;
      });
      searchPOI();
      searchAlerts();
    }
  }

  void decrementFloor() {
    if (_currentFloor != _minFloor) {
      setState(() {
        _currentFloor--;
      });
      searchPOI();
      searchAlerts();
    }
  }

  void searchPOI() {
    widget.pointOfInterestController
        .getNearbyPOI(_currentFloor, _mapController.center)
        .then((value) => setState(() {
              _pointsOfInterest = value;
            }));
  }

  void searchAlerts() {
    widget.alertController
        .getNearbySpontaneousAlerts(_currentFloor, _mapController.center)
        .then((value) => setState(() {
              _spontaneousAlerts = [];
              for (var alert in value) {
                if (alert.getFinishTime().isAfter(DateTime.now())) {
                  _spontaneousAlerts.add(alert);
                }
              }
            }));
  }

  @override
  void initState() {
    _followingCurrentPosition = false;
    _locationLoaded = false;
    _floorsLoaded = false;

    widget.pointOfInterestController.getFloorLimits().then((value) {
      setState(() {
        _minFloor = value[0];
        _maxFloor = value[1];
        _floorsLoaded = true;
      });
    });

    _mapController.onReady?.then((_) => {
          currentLocationController.getCurrentLocation().then((value) {
            setState(() {
              _currentLocation = value;
              _locationLoaded = value != null;
            });

            searchPOI();
            searchAlerts();
          })
        });

    currentLocationController.subscribeLocationUpdate((value) {
      setState(
        () {
          _currentLocation = value;
          if (value != null) {
            _locationLoaded = true;
          }
        },
      );
      if (_locationLoaded && _followingCurrentPosition) {
        setMapCenter(_currentLocation);
      }
    }).then((value) => _subscription = value);

    super.initState();
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Marker> markers = _pointsOfInterest
        .asMap()
        .entries
        .map(
          (e) => AlertPoiMarker(
            key: Key('location-icon-' + e.key.toString()),
            context: context,
            point: e.value.getPosition(),
            pressedBuilder: ((context) =>
                PointOfInterestPage(e.value, widget.alertController)),
            iconData: Icons.room,
          ),
        )
        .toList();

    final List<Marker> alertMarkers = _spontaneousAlerts
        .asMap()
        .entries
        .map((e) => AlertPoiMarker(
              key: Key('warning-icon-' + e.key.toString()),
              context: context,
              size: 40,
              point: e.value.getPosition(),
              pressedBuilder: ((context) => SpontaneousAlertPage(
                    widget.alertController,
                    e.value,
                    currentLocationController,
                    _currentLocation,
                    key: Key('warning-' + e.key.toString() + '-page'),
                  )),
              iconData: Icons.warning_rounded,
            ))
        .toList();

    markers.addAll(alertMarkers);

    final Widget mapComponent = FlutterMap(
      key: Key('live-map'),
      mapController: _mapController,
      options: MapOptions(
        onPositionChanged: unfollowLocation,
        center: _center,
        zoom: _initialZoom,
        maxZoom: _initialZoom,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
          markers: _locationLoaded
              ? [
                  Marker(
                    width: 15.0,
                    height: 15.0,
                    point: _currentLocation,
                    builder: (ctx) => Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ]
              : [],
        ),
        MarkerLayerOptions(
          markers: markers,
        )
      ],
    );

    final Widget mapButtons = Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: IconButton(
                  splashRadius: 200,
                  splashColor: Colors.grey,
                  onPressed: incrementFloor,
                  icon: const Icon(Icons.arrow_upward),
                ),
              ),
              Text(_currentFloor.toString()),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  splashRadius: 200,
                  splashColor: Colors.grey,
                  onPressed: decrementFloor,
                  icon: const Icon(Icons.arrow_downward),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  splashRadius: 200,
                  splashColor: Colors.grey,
                  onPressed: followLocation,
                  icon: const Icon(Icons.my_location),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: 0,
          ),
        )
      ],
    );

    final Widget spontaneousCreateButton = Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 20, right: 20),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isDismissible: true,
            isScrollControlled: true,
            builder: (context) => Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  CreateSpontaneousAlert(
                    widget.alertController,
                    widget.pointOfInterestController,
                    currentLocationController,
                    _currentLocation,
                    onCreate: () => setState(() {}),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      key: Key('live-scaffold'),
      resizeToAvoidBottomInset: true,
      body: _floorsLoaded
          ? Stack(
              alignment: Alignment.topRight,
              children: [
                mapComponent,
                mapButtons,
                spontaneousCreateButton,
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
    );
  }
}
