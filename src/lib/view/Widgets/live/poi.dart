import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:uni/controller/alert/alert_controller_interface.dart';
import 'package:uni/model/entities/live/alert.dart';
import 'package:uni/model/entities/live/alert_type.dart';
import 'package:uni/view/Widgets/live/titled_bottom_modal.dart';
import 'package:uni/view/Widgets/live/validation_buttons.dart';
import 'package:uni/model/entities/live/point.dart';
import 'package:uni/model/entities/live/point_group.dart';
import 'package:flutter/cupertino.dart';

class PointOfInterestPage extends StatefulWidget {
  final PointOfInterest _poi;
  final AlertControllerInterface _alertController;
  const PointOfInterestPage(final this._poi, final this._alertController,
      {Key key})
      : super(key: key);

  @override
  State<PointOfInterestPage> createState() => _PointOfInterestPageState();
}


class _PointOfInterestPageState extends State<PointOfInterestPage> {
  bool isCreatingAlert = false;
  Widget buildAlertItem(BuildContext context, int i, List<Alert> alerts) {
    final AlertType alertType = alerts[i].getAlertType();

    return Container(
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
        )
    );
  }

  Future<void> getNewPage(BuildContext context) async {
    Navigator.of(context).pop();
  }

  Widget buildPointOfInterest(BuildContext context, PointOfInterest poi, bool multiple) {
    final String titleString = poi.getName();
    final Future<List<Alert>> alerts = widget._alertController.getAlertsOfPoi(
        poi);

    final Future<Map<String, AlertType>> alertNames = widget._alertController.getAllAlertTypes();


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

    final Widget _selectAlertType = Container(
      width: 300,
      height: 280,
      color: Color.fromARGB(235, 235, 235, 235),

      child: SingleChildScrollView(
          child: Container(
              child: (
                    buildAlertTypesBox(context, alertNames)
              ),
          ),
      ),
    );

    final Widget _createAlertPage =
    Container(
      child: Wrap(
        spacing:20, // to apply margin in the main axis of the wrap
        runSpacing: 20, // to apply margin in the cross axis of the wrap
        alignment: WrapAlignment.center,
      children: [
          Container(
            width: 300,
            height:85,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(
                      Icons.edit,
                      color: Color.fromARGB(255, 0x75, 0x17, 0x1e),
                      size: 30,
                    ),
                    hintText: 'Type Alert Name',
                    labelText: 'Alert Name',
                  ),
                )
            ),
          ),
          SingleChildScrollView(
            child: _selectAlertType,
          ),
          Container(
            width: 150,
            height: 40,
           // margin: const EdgeInsets.only(bottom: 20),
            child: Stack(
              alignment: Alignment.center,
              children:[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                Text(
                  "CONFIRM",
                  style:
                  const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      //),
    );

    Widget buildCreateAlertButton(BuildContext context) {
      final button = OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                Dialog(
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
          primary: Colors.grey,
          shape: const RoundedRectangleBorder(
            borderRadius:BorderRadius.all(Radius.circular(5)),
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child:Container(
            width: 200,
            child:Row(
              //alignment: Alignment.centerLeft,
              children:[
                IconButton(
                  icon: const Icon(Icons.add_alert),
                  color: Colors.white,
                  onPressed: () {},
                ),
                // alignment: Alignment.center,
                Text(
                  "CREATE ALERT",
                  style:
                  const TextStyle(
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
        child:button,
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
      children:  <Widget>[

        Expanded(child:  content),

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

  Widget buildAlertTypesBox(BuildContext context, Future<Map<String, AlertType>> alertNames){

    Widget selectAlertType(@required BuildContext context, @required List<String> alertTypeNames, {bool bottomBorder = true}) {
      return Container(
          child: Row(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    child: StatefulBuilder(
                        builder: (context, setState) {
                          return Align(
                              alignment: Alignment.centerLeft,
                              child: RadioButtonGroup(

                                labels: <String>[
                                  for(var alertTypeName in alertTypeNames)
                                    alertTypeName,
                                ],
                                onSelected: (String selected) => print(selected),
                              ),
                          );
                        }
                    )
                ),
              ]
          )
      );
    }



    return FutureBuilder <Map<String,AlertType>>(
      future: alertNames,
      builder: (context, AsyncSnapshot<Map<String, AlertType>> snapshot) {
        if (snapshot.hasData) {
            List<String> alertTypeNames = [];
            for(var alertType in snapshot.data.values ){
              alertTypeNames.add(alertType.getName());
            }
          return selectAlertType(context, alertTypeNames);
        }
        else {
          return SizedBox();
        }
      }

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