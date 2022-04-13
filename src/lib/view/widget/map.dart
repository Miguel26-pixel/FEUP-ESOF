import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:src/assets/constants/map.dart';
import 'package:src/controller/current_location.dart';
import 'package:src/controller/poi/poi_mock_controller.dart';
import 'package:src/model/point.dart';
import 'package:src/view/widget/poi.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  CurrentLocationController currentLocationController =
      CurrentLocationController();
  MockPointOfInterestController pointOfInterestController =
      MockPointOfInterestController();

  final double _initialZoom = 18.3;

  LatLng? _currentLocation;
  late bool _loaded;
  late bool _followingCurrentPosition;
  List<PointOfInterest> _pointsOfInterest = [];

  MapController? _mapController;

  void setMapCenter(LatLng? center) {
    _mapController?.move(center!, _initialZoom);
  }

  void followLocation() {
    if (_loaded) {
      setState(() {
        _followingCurrentPosition = true;
      });
      setMapCenter(_currentLocation);
    }
  }

  void unfollowLocation(MapPosition _, bool hasGesture) {
    if (_loaded) {
      setState(() {
        _followingCurrentPosition = !hasGesture;
      });
    }
  }

  @override
  void initState() {
    _followingCurrentPosition = false;
    _loaded = false;

    currentLocationController.getCurrentLocation().then((value) => {
          setState(() {
            _currentLocation = value;
            _loaded = value != null;
          })
        });

    currentLocationController.subscribeLocationUpdate((value) {
      setState(
        () {
          _currentLocation = value;
          if (value != null) {
            _loaded = true;
          }
        },
      );
      if (_loaded && _followingCurrentPosition) {
        setMapCenter(_currentLocation);
      }
    });

    pointOfInterestController.getNearbyPOI().then((value) => setState(() {
          _pointsOfInterest = value;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> poiMarkers = _pointsOfInterest
        .map((e) => Marker(
              point: e.getPosition(),
              width: 45,
              height: 45,
              anchorPos: AnchorPos.align(AnchorAlign.top),
              builder: (ctx) => IconButton(
                padding: EdgeInsets.zero,
                iconSize: 35,
                icon: const Icon(
                  Icons.room,
                ),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  enableDrag: false,
                  builder: (context) {
                    return PointOfInterestPage(e);
                  },
                ),
              ),
            ))
        .toList();

    Widget mapComponent = FlutterMap(
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
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
          markers: _loaded
              ? [
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
                ]
              : [],
        ),
        MarkerLayerOptions(
          markers: poiMarkers,
        )
      ],
    );

    Widget mapButtons = Column(
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
                  onPressed: () => {},
                  icon: const Icon(Icons.arrow_upward),
                ),
              ),
              Text("1"),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  splashRadius: 200,
                  splashColor: Colors.grey,
                  onPressed: () => {},
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

    return Stack(
      alignment: Alignment.topRight,
      children: [
        mapComponent,
        mapButtons,
      ],
    );
  }
}
