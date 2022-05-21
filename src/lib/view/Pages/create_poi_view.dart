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
    print(floorLimits.first);

  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController floorController = TextEditingController();

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

  int getMinFloor(){
    int minFloor;
    MockPointOfInterestController().getFloorLimits().then((response){
      print("MIN FLOOR");
      print(response.first );
      minFloor = response.first;
      return 0;
    });

    return 0;

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
          children: <Widget>[getTitle(" Select Floor:", Icon(
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
      );/*TextField(
      decoration: InputDecoration(
        labelText: 'name',
        hintText: 'Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
      controller: floorController,
  );*/

  Widget getForm(){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          getTitle("Select Point's name: ", Icon(
            Icons.add_business_rounded,
            color: Theme.of(context).accentColor,
          )),
          getPOIName(),
          getTitle("Select Point's latitude:",Icon(
            Icons.add_location,
            color: Theme.of(context).accentColor,
          )),
          getPOILatitude(),
          getTitle("Select Point's longitude:",Icon(
            Icons.add_location,
            color: Theme.of(context).accentColor,
          )),
          getPOILongitude(),
          getPOIFloor(),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,
                horizontal:  15),
            child: ElevatedButton(
              onPressed: () {
                final PointOfInterestType poi =
                MockPointOfInterestController().getTypesPOI()[0];
                print('here');
                print(nameController.text);

                final double latitude = double.parse(latitudeController.text);
                final double longitude = double.parse(longitudeController.text);
                final int floor = int.parse(floorController.text);

                final createPOI = MockPointOfInterestController().createPOI(
                    nameController.text, LatLng(latitude, longitude),floor, poi);

                createPOI.then((response) {
                  if (response){
                    print('added poi');
                  }
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