import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uni/controller/poi/poi_controller_interface.dart';
import 'package:uni/view/Widgets/live/titled_bottom_modal.dart';

class CreateSpontaneousAlert extends StatefulWidget {
  const CreateSpontaneousAlert(this._poiController, {Key key})
      : super(key: key);
  static const _maxDescriptionSize = 50;
  final PointOfInterestControllerInterface _poiController;

  @override
  State<CreateSpontaneousAlert> createState() => _CreateSpontaneousAlertState();
}

class _CreateSpontaneousAlertState extends State<CreateSpontaneousAlert> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  int floor = 0;

  @override
  void initState() {
    super.initState();
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

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: max(0, _insets.bottom - 100)),
      child: TitledBottomModal(
          minHeight: 300,
          header: Row(
            children: [
              Expanded(child: getTitle()),
            ],
          ),
          multiple: false,
          children: content),
    );
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
                      if (value.length >
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
                    value: floor,
                    minValue: floorLimits.first,
                    maxValue: floorLimits.last,
                    axis: Axis.horizontal,
                    onChanged: (value) => setState(() => floor = value),
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
            return getLayout([
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ]);
          }
        });
  }
}
