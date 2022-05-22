
import 'package:flutter/material.dart';
import 'package:uni/model/entities/live/poi_type.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import '../../utils/constants.dart' as Constants;
import 'package:uni/view/Widgets/page_title.dart';
import 'package:uni/controller/poi/poi_mock_controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:numberpicker/numberpicker.dart';


class CreatePOIPage extends StatefulWidget {

  CreatePOIPage(){}

  @override
  State<StatefulWidget> createState(){
    return _CreatePOIPageState();
  }
}


class _CreatePOIPageState extends GeneralPageViewState {
  
  _CreatePOIPageState(){
  }
  @override
  void initState() {
    getFloorLimit();
    print("herea aa");
    getPOITypes();
    print(poiTypes.length);
   {
  }}

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController floorController = TextEditingController();

  List<bool> isSelected = [];
  List<PointOfInterestType> poiTypes = [];
  List<int> floorLimits = [];
  int currvalue = 0;
  int pressed = 0;

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

  void getFloorLimit() {
    MockPointOfInterestController().getFloorLimits().then((response){
      print("HERE");
      print(response.first);
      floorLimits = [... response];
      print(floorLimits.first);
    }
    );
  }
  void getPOITypes() {
    MockPointOfInterestController().getTypesPOI().then((response){

      isSelected = List<bool>.generate(response.length, (index) => false);
      print(isSelected.length);
      poiTypes = [... response];
      print("SIZE OF POITUPE");
      print(poiTypes.length);
      pressed = poiTypes.length -1;
      if (poiTypes.first.getIcon() != null){
        print("YES ICON");
      }
    }
    );
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
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.normal))
        )
      ],
    )
    );
  }

  Widget getPOIName() => TextFormField(
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
  );

  Widget getPOILatitude() => TextFormField(
      decoration: InputDecoration(
        labelText: 'Latitude',
        hintText: 'Latitude',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    validator: (value) {
      if (value == null || value.isEmpty || !(value.runtimeType == double || value.runtimeType == int) ||
          value as double <=  -90 || value as double >=90) {
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
      if (value == null || value.isEmpty || !(value.runtimeType == double || value.runtimeType == int) ||
          value as double <=  -90 || value as double >=90) {
        return 'Invalid input, please enter a number between -90 and 90';
      }
      return null;
    },
  );
  
  Widget getPOIFloor(){
    return Align(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[getTitle("Select Floor:", Icon(
            Icons.elevator_rounded ,
            color: Theme.of(context).accentColor,
          )),
            NumberPicker(
              value: currvalue,
              minValue: floorLimits.first,
              maxValue: floorLimits.last,
              axis: Axis.horizontal,
              onChanged: (value) => setState(() => currvalue = value),
            ),
          ],
        )
    );

  }

    setWidgetColor(int i){
    if (isSelected[i]){
      return Theme.of(context).accentColor;
    }
    return Colors.black;
  }

  List<Widget> getTypesPoiWidgets(){
    final List<Widget> widgets= [];

    print('in poi widget');

    print(poiTypes.length);

    for (int i = 0 ; i<poiTypes.length ; i++){
      widgets.add(
          Column(
            children: [
              Icon(
                poiTypes[i].getIcon(),
                //color: setWidgetColor(i),
                size: 40,
              ),
              Expanded(child: Text(
                poiTypes[i].getName(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis, // and this
              )),
            ],
          ));
    }


    print("sizes");
    print(isSelected.length);
    print(poiTypes.length);
    return widgets;
  }

  void onControlPress(int index){
    isSelected[index] = true;
    print(index);
    pressed = index;
    for (int buttonIndex = 0; buttonIndex <
        isSelected.length; buttonIndex++) {
      if (buttonIndex == index) {
        print("SLECTED ");
        print(buttonIndex);

        isSelected[buttonIndex] = true;
      } else {
        isSelected[buttonIndex] = false;
      }
    }
    int s = 0;
    for( bool a in isSelected){
      print(s);
      s++;
      if (a){
        print('true');
      }
    }
  }

  Widget getTypesPOI(){
    var counter = 0;
    getPOITypes();

    return GridView.count(
        primary: false,
        padding: EdgeInsets.fromLTRB(40, 30, 40, 0),
        shrinkWrap: true,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 3,
        children: getTypesPoiWidgets().map((widget) {
          final index = ++counter - 1;

          print("selected");
          print(index);
          print(isSelected[index]);

          return ToggleButtons(
            onPressed: (_) => onControlPress(index),
            fillColor: Colors.white60,
            renderBorder: false,
            children: [widget],
            isSelected: [isSelected[index]],
            selectedColor: Theme.of(context).accentColor,


          );
        }).toList());
/*
    List<bool> selected = [false, false, false, false];

    return GridView.count(
        crossAxisCount: 2,
        children: [
          Icon(Icons.info),
          Icon(Icons.title),
          Icon(Icons.info),
          Icon(Icons.title)
        ]);


    return GridView.count(
        crossAxisCount: 2,
        children: getTypesPoiWidgets().map((widget) {
          final index = ++counter - 1;

          return ToggleButtons(
            selectedColor: Colors.red,
            isSelected: [isSelected[index]],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0; buttonIndex <
                      isSelected.length; buttonIndex++) {
                    if (buttonIndex == index) {
                      print("SLECTED ");
                      print(buttonIndex);

                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
                },
            children: [widget],
          );
        }).toList());
      return ToggleButtons(
      children: getTypesPoiWidgets(),
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
            if (buttonIndex == index) {
              print("SLECTED ");
              print(buttonIndex);

              isSelected[buttonIndex] = true;

            } else {
              isSelected[buttonIndex] = false;
            }
          }
        });
      },
      selectedColor: Theme.of(context).accentColor,
      fillColor: Colors.white60,
      renderBorder: false,
      isSelected: isSelected,
    );*/
  }


  Widget getForm(){
    return Form(
      key: _formKey,
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            getTitle("Select name: ", Icon(
          Icons.add_business_rounded,
          color: Theme.of(context).accentColor,
        )),
        getPOIName(),
        getTitle("Select latitude:",Icon(
          Icons.add_location,
          color: Theme.of(context).accentColor,
        )),
        getPOILatitude(),
        getTitle("Select longitude:",Icon(
          Icons.add_location,
          color: Theme.of(context).accentColor,
        )),
        getPOILongitude(),
        getPOIFloor(),
        getTitle("Select type:", Icon(
          Icons.add_location,
          color: Theme.of(context).accentColor,
        )),
    ]
    )
    );
  }

  bool submit(){
    if (_formKey.currentState.validate()) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    }
    int index = isSelected.indexOf(true);
    PointOfInterestType poi = poiTypes[index];
    print('type');
    print(index);
    print('name');
    print(nameController.text);
    print('floor');
    final double latitude = double.parse(latitudeController.text);
    final double longitude = double.parse(longitudeController.text);
    final int floor = currvalue;
    print(floor);
    bool submited = false;

    MockPointOfInterestController().createPOI(
        nameController.text, LatLng(latitude, longitude),floor, poi)
        .then((response) {
      if (response){
        print('added poi');
        submited = true;
      }
    });

    return submited;
  }

  Widget getButton(){

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20,
          horizontal:  100),
      child: ElevatedButton(
        onPressed: () {
            if (submit()){
              Navigator.of(context).pop();
              Navigator.of(context).pop();

              Navigator.pushNamed(context, '/' + Constants.navLive);
            }
            else{
              print('ERROR');
            }

          },
        child: const Text('Create Point of interest'),
      ),
    );
  }

  
  @override
  Widget getBody(BuildContext context) {
/*
    return Container(
        child: PageView(
          children: [getMockGrid()],
        )
    );*/


    return  Container(
      child:  Align(
        alignment: AlignmentDirectional.center,
          child: ListView(
            children: [ PageTitle(name: Constants.navCreatePoi),
              getForm(), getTypesPOI(), getButton()],
          )
      )
    );
  }

}
