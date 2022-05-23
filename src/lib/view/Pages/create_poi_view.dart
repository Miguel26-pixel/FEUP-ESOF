
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uni/model/entities/live/poi_type.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import '../../utils/constants.dart' as Constants;
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/controller/poi/poi_mock_controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:numberpicker/numberpicker.dart';


class CreatePOIPage extends StatefulWidget {


  CreatePOIPage(){
  }


  @override
  _CreatePOIPageState createState(){
    return _CreatePOIPageState();
  }
}


class _CreatePOIPageState extends GeneralPageViewState {

  _CreatePOIPageState(){

  }


  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController floorController = TextEditingController();

  int isSelected = -1;
  List<PointOfInterestType> poiTypes = [];
  List<int> floorLimits = [0,9];
  int floor = 0;

  void getFloorLimit() async{
    setState( () async {
      floorLimits = await MockPointOfInterestController().getFloorLimits();
    });

  }
  void getPOITypes() async{
    setState( () async {
      poiTypes = await MockPointOfInterestController().getTypesPOI();
      isSelected = poiTypes.length - 1;

    });
    log("" + poiTypes.length.toString());

  }

  InputDecoration textFieldDecoration(String placeholder) {
    return InputDecoration(
        hintStyle: TextStyle(color: Colors.white),
        errorStyle: TextStyle(
          color: Colors.white70,
        ),
        hintText: placeholder,
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        border: UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 3)));
  }



  Widget getTitle(String text, Icon icon){
    return Padding(padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
        child:  Row(
          children: [
            icon,
            Padding(padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                child: Text(text,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).toggleableActiveColor,
                        fontWeight: FontWeight.normal))
            )
          ],
        )
    );
  }

  Widget getPOIName() => Theme(
      data: Theme.of(context).copyWith(
        accentColor: Theme.of(context).toggleableActiveColor,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Name',
          hintText: 'Name',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        controller: nameController,
      )
  );

  Widget getPOILatitude() => TextFormField(
    decoration: InputDecoration(
      labelText: 'Latitude',
      hintText: 'Latitude',
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    ),
    validator: (value) {
      final double lat = double.tryParse(value);
      if (lat == null || value.isEmpty || lat <= -90 || lat >= 90 ) {
        latitudeController.clear();
        return 'Invalid input, please enter a number between -90 and 90';
      }
      return null;
    },
    controller: latitudeController,
  );

  Widget getPOILongitude() => TextFormField(
    decoration: InputDecoration(
      labelText: 'Longitude',
      hintText: 'Longitude',
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    ),
    controller: longitudeController,
    validator: (value) {
      final double long = double.tryParse(value);
      if (long == null || value.isEmpty || long <= -90 || long >= 90 ) {
        longitudeController.clear();
        return 'Invalid input, please enter a number between -90 and 90';
      }
      return null;
    },
  );

  Widget getPOIFloor(){
    return Align(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[getTitle('Select Floor:', Icon(
            Icons.elevator_rounded ,
            color: Theme.of(context).toggleableActiveColor,
          )),
        Theme(
          data: Theme.of(context).copyWith(
            accentColor: Theme.of(context).toggleableActiveColor,
          ),
          child:  NumberPicker(
            value: floor,
            minValue: floorLimits.first,
            maxValue: floorLimits.last,
            axis: Axis.horizontal,
            onChanged: (value) => setState(() => floor = value),
          ),
        )
          ],
        )
    );

  }

  Text getPOITypeTitle(int i){
    return Text(
      poiTypes[i].getName(),
      maxLines: 2,
      overflow: TextOverflow.ellipsis, // and this
    );
  }

  List<Widget> getTypesPoiWidgets(){
    final List<Widget> widgets= [];


    for (int i = 0 ; i<poiTypes.length ; i++){
      widgets.add(
          Column(
            children: [
              Icon(
                poiTypes[i].getIcon(),
                size: 40,
              ),
              Expanded(child: getPOITypeTitle(i)),
            ],
          ));
    }


    return widgets;
  }

  void onControlPress(int index){
    setState(() {
      isSelected = index;
    });
  }

  Widget getTypesPOI() {
    var counter = 0;

    return GridView.count(
        primary: false,
        padding: EdgeInsets.fromLTRB(70, 30, 25, 0),
        shrinkWrap: true,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 3,
        children: getTypesPoiWidgets().map((widget) {
          final index = ++counter - 1;


          return Hero(
              tag: index.toString(),
              child: ToggleButtons(
                onPressed: (_) => onControlPress(index),
                fillColor: Colors.white60,
                renderBorder: false,
                children: [widget],
                isSelected: [ isSelected == index],
                selectedColor: Theme.of(context).toggleableActiveColor,

              )
          );
        }).toList());
  }


  Widget getForm(){
    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getTitle('Select name: ', Icon(
                Icons.add_business_rounded,
                color: Theme.of(context).toggleableActiveColor,
              )),
              getPOIName(),
              getTitle('Select latitude:', Icon(
                Icons.add_location,
                color: Theme.of(context).toggleableActiveColor,
              )),
              getPOILatitude(),
              getTitle('Select longitude:',Icon(
                Icons.add_location,
                color: Theme.of(context).toggleableActiveColor,
              )),
              getPOILongitude(),
              getPOIFloor(),
              getTitle('Select type:', Icon(
                Icons.add_location,
                color: Theme.of(context).toggleableActiveColor,
              )),
            ]
        )
    );
  }

  Future<bool> submit() {
    if (_formKey.currentState.validate()) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Created POI successfully')),
      );
    }
    if (isSelected == -1){
      isSelected = poiTypes.length -1;
    }
    final String name = nameController.text;
    final double latitude = double.parse(latitudeController.text);
    final double longitude = double.parse(longitudeController.text);

    return MockPointOfInterestController().createPOI(
        name, LatLng(latitude, longitude),floor, poiTypes[isSelected]);

  }


  Widget getButton(){

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20,
            horizontal:  100),
        child: Hero(
          tag: 'btn1',
          child: ElevatedButton(
            onPressed: () {

              submit().then((response) {
                if (response){
                  Navigator.pushNamed(context, '/' + Constants.navLive);
                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error. Please try again.')),
                  );
                  latitudeController.clear();
                  longitudeController.clear();
                  nameController.clear();

                }

              });
              if(!mounted) return ;

            },
            child: const Text('Create Point of interest'),
          ),
        )
    );
  }


  @override
  Widget getBody(BuildContext context) {

    getPOITypes();
    getFloorLimit();


    return  Container(
        child:  Align(
            alignment: AlignmentDirectional.center,
            child: ListView(
              children: [
                PageTitle(name: Constants.navCreatePoi),
                getForm(),
                getTypesPOI(),
                getButton(),
              ],
            )
        )
    );
  }
}