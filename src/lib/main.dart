import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry/sentry.dart';
import 'package:redux/redux.dart';
import 'package:uni/controller/alert/alert_controller.dart';
import 'package:uni/controller/alert/alert_controller_interface.dart';
import 'package:uni/controller/current_location.dart';
import 'package:uni/controller/middleware.dart';
import 'package:uni/controller/poi/poi_controller_interface.dart';
import 'package:uni/controller/poi/point_controller.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/reducers.dart';
import 'package:uni/utils/constants.dart' as Constants;
import 'package:uni/view/Pages/about_page_view.dart';
import 'package:uni/view/Pages/bug_report_page_view.dart';
import 'package:uni/view/Pages/bus_stop_next_arrivals_page.dart';
import 'package:uni/view/Pages/exams_page_view.dart';
import 'package:uni/view/Pages/home_page_view.dart';
import 'package:uni/view/Pages/logout_route.dart';
import 'package:uni/view/Pages/map_view.dart';
import 'package:uni/view/Pages/admin_dashboard_view.dart';
import 'package:uni/view/Pages/create_poi_view.dart';
import 'package:uni/view/Pages/splash_page_view.dart';
import 'package:uni/view/Pages/useful_contacts_card_page_view.dart';
import 'package:uni/view/Widgets/page_transition.dart';
import 'package:uni/view/navigation_service.dart';
import 'package:uni/view/theme.dart';

import 'controller/on_start_up.dart';
import 'model/schedule_page_model.dart';

/// Stores the state of the app
final Store<AppState> state = Store<AppState>(appReducers,
    /* Function defined in the reducers file */
    initialState: AppState(null),
    middleware: [generalMiddleware]);

SentryEvent beforeSend(SentryEvent event) {
  return event.level == SentryLevel.info ? event : null;
}

Future<void> main() async {
  OnStartUp.onStart(state);

  runApp(MyApp());
}

/// Manages the state of the app
///
/// This class is necessary to track the app's state for
/// the current execution
class MyApp extends StatefulWidget {
  const MyApp(
      {this.alertController,
      this.pointOfInterestController,
      this.currentLocationController});

  final AlertControllerInterface alertController;
  final PointOfInterestControllerInterface pointOfInterestController;
  final CurrentLocationController currentLocationController;

  @override
  State<StatefulWidget> createState() {
    return MyAppState(
        alertController: alertController,
        pointOfInterestController: pointOfInterestController,
        currentLocationController: currentLocationController,
        state: Store<AppState>(appReducers,
            /* Function defined in the reducers file */
            initialState: AppState(null),
            middleware: [generalMiddleware]));
  }
}

/// Manages the app depending on its current state
class MyAppState extends State<MyApp> {
  MyAppState(
      {@required this.state,
      this.alertController,
      this.pointOfInterestController,
      this.currentLocationController}) {
    if (this.alertController == null) {
      this.alertController = AlertController();
    }
    if (this.pointOfInterestController == null) {
      this.pointOfInterestController = PointOfInterestController();
    }
    if (this.currentLocationController == null) {
      this.currentLocationController = CurrentLocationController();
    }
  }

  final Store<AppState> state;
  PointOfInterestControllerInterface pointOfInterestController;
  AlertControllerInterface alertController;
  CurrentLocationController currentLocationController;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return StoreProvider(
      store: state,
      child: MaterialApp(
          title: 'uni',
          theme: applicationLightTheme,
          home: SplashScreen(),
          navigatorKey: NavigationService.navigatorKey,
          // ignore: missing_return
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/' + Constants.navPersonalArea:
                return PageTransition.makePageTransition(
                    page: HomePageView(), settings: settings);
              case '/' + Constants.navSchedule:
                return PageTransition.makePageTransition(
                    page: SchedulePage(), settings: settings);
              case '/' + Constants.navExams:
                return PageTransition.makePageTransition(
                    page: ExamsPageView(), settings: settings);
              case '/' + Constants.navStops:
                return PageTransition.makePageTransition(
                    page: BusStopNextArrivalsPage(), settings: settings);
              case '/' + Constants.navLive:
                return PageTransition.makePageTransition(
                    page: MapPage(
                        alertController: alertController,
                        pointOfInterestController: pointOfInterestController,
                        currentLocationController: currentLocationController),
                    settings: settings);
              case '/' + Constants.navAdmin:
                return PageTransition.makePageTransition(
                    page: AdminDashboardPage(), settings: settings);
              case '/' + Constants.navCreatePoi:
                return PageTransition.makePageTransition(
                    page: CreatePOIPage(pointOfInterestController),
                    settings: settings);
              case '/' + Constants.navUsefulContacts:
                return PageTransition.makePageTransition(
                    page: UsefulContactsCardView(), settings: settings);
              case '/' + Constants.navAbout:
                return PageTransition.makePageTransition(
                    page: AboutPageView(), settings: settings);
              case '/' + Constants.navBugReport:
                return PageTransition.makePageTransition(
                    page: BugReportPageView(),
                    settings: settings,
                    maintainState: false);
              case '/' + Constants.navLogOut:
                return LogoutRoute.buildLogoutRoute();
            }
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    // Timer.periodic(Duration(seconds: 60),
    //     (Timer t) => state.dispatch(SetCurrentTimeAction(DateTime.now())));
  }
}
