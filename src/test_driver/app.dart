import 'package:uni/controller/alert/alert_controller_interface.dart';
import 'package:uni/controller/alert/alert_mock_controller.dart';
import 'package:uni/controller/current_location.dart';
import 'package:uni/controller/mock_location_controller.dart.dart';
import 'package:uni/controller/poi/poi_controller_interface.dart';
import 'package:uni/controller/poi/poi_mock_controller.dart';
import 'package:uni/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  // This line enables the extension
  enableFlutterDriverExtension();

  // Call the `main()` function of your app or call `runApp` with any widget you
  // are interested in testing.
  final AlertControllerInterface alertController = AlertMockController();
  final PointOfInterestControllerInterface pointOfInterestController =
      MockPointOfInterestController();
  final CurrentLocationController currentLocationController =
      MockCurrentLocationController();
  runApp(MyApp(
      alertController: alertController,
      pointOfInterestController: pointOfInterestController,
      currentLocationController: currentLocationController));
}
