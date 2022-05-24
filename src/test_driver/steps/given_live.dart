import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric openSideDrawerStep() {
  return given<FlutterWorld>('I open the side drawer', (context) async {
    final location = find.byTooltip('Open navigation menu');
    await FlutterDriverUtils.tap(context.world.driver, location);
  });
}

StepDefinitionGeneric viewsLocationIcon() {
  return then<FlutterWorld>('I view a location icon', ((context) async {
    final location = find.byValueKey('location-icon-0');
    await FlutterDriverUtils.isPresent(context.world.driver, location);
  }));
}

StepDefinitionGeneric clickLocation() {
  return then<FlutterWorld>('I view a location icon', ((context) async {
    final location = find.byValueKey('location-icon-0');
    await FlutterDriverUtils.isPresent(context.world.driver, location);
  }));
}
