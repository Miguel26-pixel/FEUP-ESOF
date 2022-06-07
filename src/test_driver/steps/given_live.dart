import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric givenOpenSideDrawer() {
  return given<FlutterWorld>('I open the side drawer', (context) async {
    final location = find.byTooltip('Open navigation menu');
    await FlutterDriverUtils.tap(context.world.driver, location);
  });
}

StepDefinitionGeneric thenViewLocationIcon() {
  return then<FlutterWorld>('I view a location icon', ((context) async {
    final location = find.byValueKey('location-icon-0');
    context.expectA(
      await FlutterDriverUtils.isPresent(context.world.driver, location),
      true,
    );
  }));
}

StepDefinitionGeneric thenViewWarningIcon() {
  return then<FlutterWorld>('I view a warning icon', ((context) async {
    final location = find.byValueKey('warning-icon-0');
    context.expectA(
      await FlutterDriverUtils.isPresent(context.world.driver, location),
      true,
    );
  }));
}

StepDefinitionGeneric whenTapLocation() {
  final location = find.byValueKey('location-icon-0');

  return when<FlutterWorld>('I tap a location icon', ((context) async {
    await FlutterDriverUtils.tap(context.world.driver, location);
  }));
}

StepDefinitionGeneric whenTapNoAlerts() {
  final location2 = find.byValueKey('location-icon-1');

  return when<FlutterWorld>(
      'I tap a location icon of a point of interest with no alerts',
      ((context) async {
    await FlutterDriverUtils.tap(context.world.driver, location2);
  }));
}

StepDefinitionGeneric whenTapWithAlerts() {
  final location2 = find.byValueKey('location-icon-0');

  return when<FlutterWorld>(
      'I tap a location icon of a point of interest with alerts',
      ((context) async {
    await FlutterDriverUtils.tap(context.world.driver, location2);
  }));
}

StepDefinitionGeneric whenTapWarning() {
  return when<FlutterWorld>('I tap a warning icon', ((context) async {
    final location = find.byValueKey('warning-icon-0');
    await FlutterDriverUtils.tap(context.world.driver, location);
  }));
}

StepDefinitionGeneric thenViewSAlertPage() {
  return then<FlutterWorld>('I view the Spontaneous Alert page',
      ((context) async {
    final location = find.byValueKey('warning-0-page');
    context.expectA(
      await FlutterDriverUtils.isPresent(context.world.driver, location),
      true,
    );
  }));
}

StepDefinitionGeneric thenViewPoiPage() {
  return then<FlutterWorld>('I view the Point of Interest Page',
      ((context) async {
    final location = find.byValueKey('poi-page-0-page');
    context.expectA(
      await FlutterDriverUtils.isPresent(context.world.driver, location),
      true,
    );
  }));
}

StepDefinitionGeneric thenViewNoAlertsPage() {
  return then<FlutterWorld>('I view a no alerts page', ((context) async {
    final location = find.byValueKey('no-alerts');
    context.expectA(
      await FlutterDriverUtils.isPresent(context.world.driver, location),
      true,
    );
  }));
}

StepDefinitionGeneric thenViewAlertsPage() {
  return then<FlutterWorld>('I view the alerts of the point of interest',
      ((context) async {
    final location = find.byValueKey('alert-0-item');
    final location2 = find.byValueKey('alert-1-item');
    context.expectA(
      await FlutterDriverUtils.isPresent(context.world.driver, location),
      true,
    );
    context.expectA(
      await FlutterDriverUtils.isPresent(context.world.driver, location2),
      true,
    );
  }));
}

StepDefinitionGeneric thenViewAllAlertsPage() {
  return then<FlutterWorld>('I view all of the available alerts',
      ((context) async {
    final location = find.byValueKey('no-alerts');
    context.expectA(
      await FlutterDriverUtils.isPresent(context.world.driver, location),
      true,
    );
  }));
}
