import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uni/model/entities/live/poi_type.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/type_selector.dart';
import '../../utils/constants.dart' as Constants;
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/controller/poi/poi_mock_controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:numberpicker/numberpicker.dart';

class CreatePOIPage extends StatefulWidget {
  MockPointOfInterestController _pointOfInterestController;
  CreatePOIPage(MockPointOfInterestController pointOfInterestController) {
    _pointOfInterestController = pointOfInterestController;
  }

  @override
  _CreatePOIPageState createState() {
    return _CreatePOIPageState(_pointOfInterestController);
  }
}

class _CreatePOIPageState extends GeneralPageViewState {
  _CreatePOIPageState(MockPointOfInterestController pointOfInterestController) {
    _pointOfInterestController = pointOfInterestController;
  }

  MockPointOfInterestController _pointOfInterestController;

  final _formKey = GlobalKey<FormState>();
  final _scrollKey = GlobalKey<ScaffoldState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController floorController = TextEditingController();

  int selectedType;
  List<PointOfInterestType> poiTypes;
  List<int> floorLimits;
  int floor = 0;

  @override
  void initState() {
    super.initState();
    poiTypes = [];
    selectedType = -1;
    floorLimits = [-1, 3];
    floor = 0;
    getPOITypes();
    getFloorLimit();
  }

  void getFloorLimit() async {
    setState(() async {
      floorLimits = await _pointOfInterestController.getFloorLimits();
    });
  }

  void getPOITypes() async {
    final temp = await _pointOfInterestController.getTypesPOI();

    setState(() {
      poiTypes = temp;
      selectedType = -1;
    });
    log(poiTypes.length.toString());
  }

  Widget getTitle(String text, Icon icon) {
    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
        child: Row(
          children: [
            icon,
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ));
  }

  InputDecoration getFormBorder(String hint) {
    return InputDecoration(
      labelText: hint,
      hintText: hint,
      labelStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
    );
  }

  Widget getPOIName() => TextFormField(
        decoration: getFormBorder('Name'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        controller: nameController,
      );

  Widget getPOILatitude() => TextFormField(
        decoration: getFormBorder('Latitude'),
        validator: (value) {
          final double lat = double.tryParse(value);
          if (lat == null || value.isEmpty || lat <= -90 || lat >= 90) {
            latitudeController.clear();
            return 'Invalid input, please enter a number between -90 and 90';
          }
          return null;
        },
        controller: latitudeController,
      );

  Widget getPOILongitude() => TextFormField(
        decoration: getFormBorder('Longitude'),
        controller: longitudeController,
        validator: (value) {
          final double long = double.tryParse(value);
          if (long == null || value.isEmpty || long <= -90 || long >= 90) {
            longitudeController.clear();
            return 'Invalid input, please enter a number between -90 and 90';
          }
          return null;
        },
      );

  Widget getPOIFloor() {
    return Align(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            getTitle(
                'Select Floor:',
                Icon(
                  Icons.elevator_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                )),
            NumberPicker(
              value: floor,
              minValue: floorLimits.first,
              maxValue: floorLimits.last,
              axis: Axis.horizontal,
              selectedTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
              onChanged: (value) => setState(() => floor = value),
            ),
          ],
        ));
  }

  void onControlPress(int index) {
    setState(() {
      selectedType = index;
    });
  }

  Widget getForm() {
    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getTitle(
                  'Select name: ',
                  Icon(
                    Icons.add_business_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                  )),
              getPOIName(),
              getTitle(
                  'Select latitude:',
                  Icon(
                    Icons.add_location,
                    color: Theme.of(context).colorScheme.secondary,
                  )),
              getPOILatitude(),
              getTitle(
                  'Select longitude:',
                  Icon(
                    Icons.add_location,
                    color: Theme.of(context).colorScheme.secondary,
                  )),
              getPOILongitude(),
              getPOIFloor(),
              getTitle(
                  'Select type:',
                  Icon(
                    Icons.add_location,
                    color: Theme.of(context).colorScheme.secondary,
                  )),
            ]));
  }

  Future<bool> submit() {
    if (_formKey.currentState.validate()) {
      if (selectedType == -1) {
        selectedType = poiTypes.length - 1;
      }
      final String name = nameController.value.text;
      final double latitude = double.parse(latitudeController.value.text);
      final double longitude = double.parse(longitudeController.value.text);

      return _pointOfInterestController.createPOI(
          name, LatLng(latitude, longitude), floor, poiTypes[selectedType]);
    } else {
      return Future.value(false);
    }
  }

  Widget getButton() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
        child: Hero(
          tag: 'btn1',
          child: ElevatedButton(
            onPressed: () {
              submit().then((response) {
                if (response) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Created POI successfully')),
                  );
                  Navigator.pushNamed(context, '/' + Constants.navLive);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error. Please try again.')),
                  );
                  latitudeController.clear();
                  longitudeController.clear();
                  nameController.clear();
                }
              });
              if (!mounted) return;
            },
            child: const Text('Create Point of interest'),
          ),
        ));
  }

  @override
  Widget getBody(BuildContext context) {
    return Container(
        child: Align(
            alignment: AlignmentDirectional.center,
            child: ListView(
              key: _scrollKey,
              children: [
                PageTitle(name: Constants.navCreatePoi),
                getForm(),
                TypeSelector(
                  types: poiTypes,
                  callback: onControlPress,
                  selected: selectedType,
                ),
                getButton(),
              ],
            )));
  }
}
