import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/assets/constants/map.dart';
import 'package:uni/controller/alert/alert_controller_interface.dart';
import 'package:uni/controller/alert/alert_mock_controller.dart';
import 'package:uni/controller/current_location.dart';
import 'package:uni/controller/poi/poi_mock_controller.dart';
import 'package:uni/model/entities/live/point.dart';
import 'package:uni/model/entities/live/spontaneous_alert.dart';
import 'package:uni/view/Widgets/poi.dart';
import 'package:uni/view/Widgets/alert_poi_marker.dart';
import 'package:uni/view/Widgets/spontaneous_alert.dart';

class Map extends StatefulWidget {
  const Map({Key key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  CurrentLocationController currentLocationController =
      CurrentLocationController();
  MockPointOfInterestController pointOfInterestController =
      MockPointOfInterestController();
  AlertControllerInterface alertController = AlertMockController();

  final double _initialZoom = 18.3;

  LatLng _currentLocation;

  int _currentFloor = 0;
  int _maxFloor;
  int _minFloor;
  bool _locationLoaded;
  bool _floorsLoaded;
  bool _followingCurrentPosition;
  List<PointOfInterest> _pointsOfInterest = [];
  List<SpontaneousAlert> _spontaneousAlerts = [];

  MapController _mapController;

  void setMapCenter(LatLng center) {
    _mapController?.move(center, _initialZoom);
  }

  void followLocation() {
    if (_locationLoaded) {
      setState(() {
        _followingCurrentPosition = true;
      });
      setMapCenter(_currentLocation);
    }
  }

  void unfollowLocation(MapPosition _, bool hasGesture) {
    if (_locationLoaded) {
      setState(() {
        _followingCurrentPosition = !hasGesture;
      });
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
    pointOfInterestController
        .getNearbyPOI(_currentFloor)
        .then((value) => setState(() {
              _pointsOfInterest = value;
            }));
  }

  void searchAlerts() {
    alertController
        .getNearbySpontaneousAlerts(_currentFloor)
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

    pointOfInterestController.getFloorLimits().then((value) {
      _minFloor = value[0];
      _maxFloor = value[1];
      _floorsLoaded = true;
    });

    currentLocationController.getCurrentLocation().then((value) => {
          setState(() {
            _currentLocation = value;
            _locationLoaded = value != null;
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
    });

    searchPOI();
    searchAlerts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Marker> markers = _pointsOfInterest
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
              pressedBuilder: ((context) => SpontaneousAlertPage(
                  e, currentLocationController, _currentLocation)),
              iconData: Icons.warning_rounded,
            ))
        .toList();

    markers.addAll(alertMarkers);

    final Widget mapComponent = FlutterMap(
      options: MapOptions(
        onMapCreated: ((mapController) => _mapController = mapController),
        onPositionChanged: unfollowLocation,
        controller: _mapController,
        center: FEUP_POS,
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

    return _floorsLoaded
        ? Stack(
            alignment: Alignment.topRight,
            children: [
              mapComponent,
              mapButtons,
            ],
          )
        : const CircularProgressIndicator();
  }
}
