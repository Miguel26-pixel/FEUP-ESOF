import 'dart:developer';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric GivenOpenSideDrawer() {
  return given<FlutterWorld>('I open the side drawer', (context) async {
    final location = find.byTooltip('Open navigation menu');
    await FlutterDriverUtils.tap(context.world.driver, location);
  });
}

StepDefinitionGeneric ThenViewLocationIcon() {
  return then<FlutterWorld>('I view a location icon', ((context) async {
    final location = find.byValueKey('location-icon-0');
    context.expectA(
      await FlutterDriverUtils.isPresent(context.world.driver, location),
      true,
    );
  }));
}

StepDefinitionGeneric ThenViewWarningIcon() {
  return then<FlutterWorld>('I view a warning icon', ((context) async {
    final location = find.byValueKey('warning-icon-0');
    context.expectA(
      await FlutterDriverUtils.isPresent(context.world.driver, location),
      true,
    );
  }));
}

StepDefinitionGeneric WhenTapWarning() {
  return when<FlutterWorld>('I tap a warning icon', ((context) async {
    final location = find.byValueKey('warning-icon-0');
    await FlutterDriverUtils.tap(context.world.driver, location);
  }));
}

StepDefinitionGeneric ThenViewSAlertPage() {
  return then<FlutterWorld>('I view the Spontaneous Alert page',
      ((context) async {
    final location = find.byValueKey('warning-0-page');
    await FlutterDriverUtils.tap(context.world.driver, location);
  }));
}
