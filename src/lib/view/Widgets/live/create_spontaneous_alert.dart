import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uni/controller/alert/alert_controller_interface.dart';
import 'package:uni/controller/current_location.dart';
import 'package:uni/controller/poi/poi_controller_interface.dart';
import 'package:uni/view/Widgets/live/titled_bottom_modal.dart';

class CreateSpontaneousAlert extends StatefulWidget {
  static const _maxDescriptionSize = 50;
  final PointOfInterestControllerInterface _poiController;
  final CurrentLocationController _currentLocationController;
  final LatLng _position;
  final AlertControllerInterface _alertController;
  final Function() onCreate;

  const CreateSpontaneousAlert(this._alertController, this._poiController,
      this._currentLocationController, this._position,
      {Key key, this.onCreate})
      : super(key: key);

  @override
  State<CreateSpontaneousAlert> createState() => _CreateSpontaneousAlertState();
}

class _CreateSpontaneousAlertState extends State<CreateSpontaneousAlert> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  int _floor = 0;
  LatLng _position;
  StreamSubscription<LocationData> _locationSubscription;

  @override
  void initState() {
    _position = widget._position;

    widget._currentLocationController
        .subscribeLocationUpdate((p0) => setState(() {
              if (p0 != null) {
                _position = p0;
              }
            }))
        .then((value) => {
              if (value != null) {_locationSubscription = value}
            });

    super.initState();
  }

  @override
  void dispose() {
    final subscription = _locationSubscription;

    if (subscription != null) {
      subscription.cancel();
    }

    super.dispose();
  }

  Widget getTitle() {
    return AutoSizeText(
      "What's happening?".toUpperCase(),
      textAlign: TextAlign.center,
      maxLines: 2,
      style: const TextStyle(
        fontSize: 17,
        color: Colors.black,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget getLayout(List<Widget> content) {
    final EdgeInsets _insets = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.only(bottom: max(0, _insets.bottom - 100)),
      child: TitledBottomModal(
        minHeight: 320,
        header: Row(
          children: [
            Expanded(child: getTitle()),
          ],
        ),
        multiple: false,
        children: content,
      ),
    );
  }

  void submit() async {
    if (_position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't get current position.")),
      );
    }

    if (_formKey.currentState.validate()) {
      final result = await widget._alertController.createSpontaneousAlert(
          _descriptionController.value.text, _floor, _position);

      if (result.item1 == true) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alert added!')),
        );

        widget.onCreate.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.item2)),
        );
      }
    }
  }

  Widget getForm(BuildContext context, List<int> floorLimits) {
    return getLayout(
      [
        Expanded(
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(fontSize: 17),
                    decoration: InputDecoration(
                      labelText: 'Description',
                      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    ),
                    controller: _descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description must not be empty.';
                      } else if (value.length >
                          CreateSpontaneousAlert._maxDescriptionSize) {
                        return 'Description length must be lesser or equal' +
                            'to ${CreateSpontaneousAlert._maxDescriptionSize}';
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'SELECT FLOOR',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  NumberPicker(
                    value: _floor,
                    minValue: floorLimits.first,
                    maxValue: floorLimits.last,
                    axis: Axis.horizontal,
                    onChanged: (value) => setState(() => _floor = value),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      submit();
                    },
                    child: Text(
                      'Add Alert',
                      style: TextStyle(fontSize: 17),
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 100)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5))))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Future<List<int>> _floorLimits =
        widget._poiController.getFloorLimits();

    return FutureBuilder(
      future: _floorLimits,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return getForm(context, snapshot.data);
        } else {
          return getLayout(
            [
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
