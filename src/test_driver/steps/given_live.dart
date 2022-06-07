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

StepDefinitionGeneric thenViewSuccessAlertCreated() {
  return then<FlutterWorld>('I create the alert successfully',
      ((context) async {
    final location = find.byValueKey('create-alert-success');
    context.expectA(
      await FlutterDriverUtils.isPresent(context.world.driver, location),
      true,
    );
  }));
}

StepDefinitionGeneric whenTapLocation() {
  return when<FlutterWorld>('I tap a location icon', ((context) async {
    final location = find.byValueKey('location-icon-0');
    await FlutterDriverUtils.tap(context.world.driver, location);
  }));
}

StepDefinitionGeneric whenTapWarning() {
  return when<FlutterWorld>('I tap a warning icon', ((context) async {
    final location = find.byValueKey('warning-icon-0');
    await FlutterDriverUtils.tap(context.world.driver, location);
  }));
}

StepDefinitionGeneric whenTapCreateAlert() {
  return when<FlutterWorld>('I tap the create alert button', ((context) async {
    final location = find.byValueKey('create-alert-btn');
    await FlutterDriverUtils.tap(context.world.driver, location);
  }));
}

StepDefinitionGeneric createAlertChooseType() {
  return when<FlutterWorld>('I choose an alert type', ((context) async {
    final location = find.byValueKey('alert-type-1');
    await FlutterDriverUtils.tap(context.world.driver, location);
  }));
}

StepDefinitionGeneric whenTapConfirmCreateAlert() {
  return when<FlutterWorld>('I tap the confirm button', ((context) async {
    final location = find.byValueKey('confirm-button');
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

StepDefinitionGeneric thenViewAlertsPage() {
  return then<FlutterWorld>('I view all of the available alerts',
      ((context) async {
    final location = find.byValueKey('no-alerts');
    context.expectA(
      await FlutterDriverUtils.isPresent(context.world.driver, location),
      true,
    );
  }));
}
