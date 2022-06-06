import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'steps/given_live.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [RegExp('test_driver/features/.*\.feature')]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json'),
      StdoutReporter(),
    ]
    ..hooks = []
    ..stepDefinitions = [
      givenOpenSideDrawer(),
      whenTapWarning(),
      thenViewSAlertPage(),
      thenViewLocationIcon(),
      thenViewWarningIcon(),
      thenViewLocationIcon(),
    ]
    ..customStepParameterDefinitions = []
    ..restartAppBetweenScenarios = true
    ..targetAppPath = 'test_driver/app.dart';
  return GherkinRunner().execute(config);
}
