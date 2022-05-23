import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric GivenLive() {
  return given('Given I am in the Live@UP app', (context) async {
    await FlutterDriverUtils.waitUntil(
        context.world.driver, () => Future.delayed(Duration(seconds: 20)));
  });
}
