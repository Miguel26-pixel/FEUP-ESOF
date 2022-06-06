import 'package:flutter/material.dart';
import 'package:uni/controller/alert/alert_controller_interface.dart';
import 'package:uni/controller/poi/poi_controller_interface.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/live/map.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key, this.alertController, this.pointOfInterestController})
      : super(key: key);

  final AlertControllerInterface alertController;
  final PointOfInterestControllerInterface pointOfInterestController;

  @override
  State<StatefulWidget> createState() => MapPageState(
        alertController: alertController,
        pointOfInterestController: pointOfInterestController,
      );
}

/// Tracks the state of home page.
class MapPageState extends GeneralPageViewState {
  MapPageState({this.alertController, this.pointOfInterestController})
      : super();

  final AlertControllerInterface alertController;
  final PointOfInterestControllerInterface pointOfInterestController;

  @override
  Widget getBody(BuildContext context) {
    return Map(
      alertController: alertController,
      pointOfInterestController: pointOfInterestController,
    );
  }
}
