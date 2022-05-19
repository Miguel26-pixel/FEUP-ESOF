import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:uni/controller/alert/alert_controller_interface.dart';
import 'package:uni/model/entities/live/alert.dart';
import 'package:uni/model/entities/live/alert_type.dart';
import 'package:uni/view/Widgets/titled_bottom_modal.dart';
import 'package:uni/view/Widgets/validation_buttons.dart';
import 'package:uni/model/entities/live/point.dart';

class PointOfInterestPage extends StatefulWidget {
  final PointOfInterest _poi;
  final AlertControllerInterface _alertControllerInterface;
  const PointOfInterestPage(
      final this._poi, final this._alertControllerInterface,
      {Key key})
      : super(key: key);

  @override
  State<PointOfInterestPage> createState() => _PointOfInterestPageState();
}

class _PointOfInterestPageState extends State<PointOfInterestPage> {
  Widget buildAlertItem(BuildContext context, int i, List<Alert> alerts) {
    final AlertType alertType = alerts[i].getAlertType();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(50, 0, 0, 0),
              offset: Offset(0, 1),
              blurRadius: 1,
              spreadRadius: 0,
            )
          ]),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Align(
              alignment: Alignment.centerRight,
              child: ValidationButtons(
                mainAxisAlignment: MainAxisAlignment.end,
              )),
          Align(
            alignment: Alignment.center,
            child: Text(
              alertType.getName(),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 60,
              child: Icon(
                alertType.getIconData(),
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent(BuildContext context, List<Alert> alerts) {
    return alerts.isEmpty
        ? Center(
            child: SizedBox(
              width: 200,
              child: Text(
                'There are no active alerts here at this moment.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          )
        : ListView.builder(
            itemBuilder: (context, index) =>
                buildAlertItem(context, index, alerts),
            itemCount: alerts.length,
          );
  }

  @override
  Widget build(BuildContext context) {
    final String titleString = widget._poi.getName();
    final Future<List<Alert>> alerts =
        widget._alertControllerInterface.getAlertsOfPoi(widget._poi);

    final Widget _title = AutoSizeText(
      titleString.toUpperCase(),
      textAlign: TextAlign.center,
      maxLines: 2,
      style: const TextStyle(
        fontSize: 17,
        color: Colors.black,
        fontWeight: FontWeight.w800,
      ),
    );

    Widget layout(Widget content) => TitledBottomModal(
          header: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_on),
                onPressed: () {},
              ),
              Expanded(
                child: _title,
              ),
              IconButton(
                iconSize: 30,
                icon: const Icon(Icons.bar_chart),
                onPressed: () {},
              ),
            ],
          ),
          children: [
            Expanded(child: content),
          ],
        );

    return FutureBuilder<List<Alert>>(
      future: alerts,
      builder: (context, AsyncSnapshot<List<Alert>> snapshot) {
        if (snapshot.hasData) {
          return layout(buildContent(context, snapshot.data));
        } else {
          return layout(Center(
            child: CircularProgressIndicator(),
          ));
        }
      },
    );
  }
}
