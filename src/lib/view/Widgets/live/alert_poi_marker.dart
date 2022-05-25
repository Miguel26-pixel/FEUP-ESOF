import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AlertPoiMarker extends Marker {
  AlertPoiMarker({
    Key key,
    LatLng point,
    WidgetBuilder pressedBuilder,
    BuildContext context,
    IconData iconData,
    double size = 45,
  }) : super(
          width: size,
          height: size,
          anchorPos: AnchorPos.align(AnchorAlign.top),
          point: point,
          builder: (ctx) => IconButton(
            key: key,
            padding: EdgeInsets.zero,
            iconSize: size - 10,
            icon: Icon(
              iconData,
            ),
            onPressed: () => showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              enableDrag: false,
              builder: pressedBuilder,
            ),
          ),
        );
}
