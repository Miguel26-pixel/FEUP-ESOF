
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
    getFloorLimit();
    print("herea aa");
    getPOITypes();
    print(poiTypes.length);

  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController floorController = TextEditingController();

  List<bool> isSelected = [];
  List<PointOfInterestType> poiTypes = [];
  List<int> floorLimits = [0,9];
  int currvalue = 0;

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

  Widget getPOIName() => TextField(
    decoration: InputDecoration(
      labelText: 'Name',
      hintText: 'Name',
      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    ),
      controller: nameController,
  );

  Widget getPOILatitude() => TextField( 
      decoration: InputDecoration(
        labelText: 'Latitude',
        hintText: 'Latitude',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
      controller: latitudeController,
  );
  
  Widget getPOILongitude() => TextField( 
      decoration: InputDecoration(
        labelText: 'Longitude',
        hintText: 'Longitude',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
      controller: longitudeController,
  );
  
  Widget getPOIFloor() =>
      Align(
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

  List<Widget> getTypesPoiWidgets(){
    final List<Widget> widgets= [];

    print('in poi widget');

    print(poiTypes.length);

    poiTypes.forEach((type) {
      print('add widget');
      widgets.add(
          Column(
            children: [
              Icon(
                  type.getIcon()
              ),
              Text(type.getName())
            ],
          ));

      print("here");
      /*print("there is a poi");
      if ( type.getIcon() != null){
        print("there is icon ");
      }
      if (num < 3) {
        row.add(Icon(
            type.getIcon()
        ));
      }
      else{
        widgets.add(Row(
          children: row,
        ));

        row = [];
        row.add(Icon(
            type.getIcon()
        ));
        num = 1;
      }
      num++;*/
    });

   /* if (widgets.isEmpty){
      throw Exception("NO types of points of interest");
    }*/
    print("sizes");
    print(isSelected.length);
    print(poiTypes.length);
    return widgets;
  }

  Widget getTypesPOI(){

    /*return GridView.count(
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
        }).toList());*/
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
    );
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
          getTypesPOI(),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,
                horizontal:  15),
            child: ElevatedButton(
              onPressed: () {
                print("here");


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

                final createPOI = MockPointOfInterestController().createPOI(
                    nameController.text, LatLng(latitude, longitude),floor, poi);

                createPOI.then((response) {
                  if (response){
                    print('added poi');
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();

                  Navigator.pushNamed(context, '/' + Constants.navLive);


                });
              },
              child: const Text('Create Point of interest'),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget getBody(BuildContext context) {
/*
    return Container(
        child: Align(
          alignment: Alignment.topLeft,
          child: Text("Hello")
      )
    );
  }*/

    return  Container(
      child:  Align(
        alignment: AlignmentDirectional.center,
          child: ListView(
            children: [ PageTitle(name: Constants.navCreatePoi),
              getForm()],
          )
      )
    );
  }

}
