import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:uni/controller/alert/alert_controller_interface.dart';
import 'package:uni/model/entities/live/alert.dart';
import 'package:uni/model/entities/live/alert_type.dart';
import 'package:uni/view/Widgets/live/alert_type_selector.dart';
import 'package:uni/view/Widgets/live/titled_bottom_modal.dart';
import 'package:uni/view/Widgets/live/validation_buttons.dart';
import 'package:uni/model/entities/live/point.dart';
import 'package:uni/model/entities/live/point_group.dart';

class PointOfInterestPage extends StatefulWidget {
  final PointOfInterest _poi;
  final AlertControllerInterface alertController;
  const PointOfInterestPage(final this._poi, final this.alertController,
      {Key key})
      : super(key: key);

  @override
  State<PointOfInterestPage> createState() => _PointOfInterestPageState();
}

class _PointOfInterestPageState extends State<PointOfInterestPage> {
  bool isCreatingAlert = false;
  final _formKey = GlobalKey<FormState>();
  int selectedType;
  List<AlertType> alertTypes;

  Widget buildAlertItem(BuildContext context, int i, List<Alert> alerts) {
    final AlertType alertType = alerts[i].getAlertType();

    return Container(
        key: Key('alert-${i}-item'),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        width: 200,
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
            Align(
              alignment: Alignment.centerRight,
              child: ValidationButtons(
                mainAxisAlignment: MainAxisAlignment.end,
                alertController: widget.alertController,
                alertId: alerts[i].getId(),
                isSpontaneous: false,
              ),
            ),
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
        ));
  }

  @override
  void initState() {
    super.initState();
    alertTypes = [];
    selectedType = -1;
    getPOITypes();
  }

  void getPOITypes() async {
    final temp = await widget.alertController.getAlertTypes();

    setState(() {
      alertTypes = temp;
      selectedType = -1;
    });
  }

  Future<void> getNewPage(BuildContext context) async {
    Navigator.of(context).pop();
  }

  void submitAlert(PointOfInterest poi) async {
    if (_formKey.currentState.validate()) {
      if (selectedType == -1) {
        return;
      }

      final result = await widget.alertController
          .createAlert(poi, alertTypes[selectedType]);
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context, rootNavigator: true).pop();
      if (result.item1 == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alert added!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error ')),
        );
      }
    }
  }

  Widget buildPointOfInterest(
      BuildContext context, PointOfInterest poi, bool multiple) {
    final String titleString = poi.getName();
    final Future<List<Alert>> alerts =
        widget.alertController.getAlertsOfPoi(poi);

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

    final Widget _createAlertPage = Container(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            SingleChildScrollView(
              child: AlertTypeSelector(
                types: alertTypes,
                callback: (index) {
                  setState(() {
                    selectedType = index;
                  });
                },
                selected: selectedType,
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                key: Key('confirm-button'),
                onPressed: () {
                  submitAlert(poi);
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(fontSize: 17),
                ),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                      horizontal: 100,
                    )),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))))),
              ),
            ),
          ],
        ),
      ),
      //),
    );

    Widget buildCreateAlertButton(BuildContext context) {
      final button = OutlinedButton(
        key: Key('create-alert-btn'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: SizedBox(
                height: 500,
                width: 500,
                child: _createAlertPage,
              ),
            ),
            //child: Text('Hello'),))
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
          primary: Theme.of(context).colorScheme.secondary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 200,
            child: Row(
              //alignment: Alignment.centerLeft,
              children: [
                Container(
                  child: Icon(
                    Icons.add_alert,
                    color: Theme.of(context).primaryColor,
                  ),
                  padding: const EdgeInsets.all(8.0),
                ),
                // alignment: Alignment.center,
                Text(
                  'CREATE ALERT',
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      return Container(
        width: 300,
        height: 60,
        margin: const EdgeInsets.only(bottom: 15),
        child: button,
      );
    }

    Widget layout(Widget content) => TitledBottomModal(
          multiple: multiple,
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
          children: <Widget>[
            Expanded(child: content),
            Container(child: buildCreateAlertButton(context)),
          ],
        );

    return FutureBuilder<List<Alert>>(
      future: alerts,
      builder: (context, AsyncSnapshot<List<Alert>> snapshot) {
        if (snapshot.hasData) {
          return layout(buildContent(context, snapshot.data));
        } else {
          return layout(
            Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget buildContent(BuildContext context, List<Alert> alerts) {
    return alerts.isEmpty
        ? Center(
            key: Key('no-alerts'),
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
    final List<PointOfInterest> pois = [];
    if (widget._poi is PointOfInterestGroup) {
      pois.addAll((widget._poi as PointOfInterestGroup).getPoints());
    } else {
      pois.add(widget._poi);
    }

    return ListView.builder(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, i) =>
          buildPointOfInterest(context, pois[i], pois.length > 1),
      itemCount: pois.length,
    );
  }
}
