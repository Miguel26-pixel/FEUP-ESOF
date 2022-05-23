import 'package:flutter/material.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import '../../utils/constants.dart' as Constants;
import 'package:uni/view/Widgets/page_title.dart';


class AdminDashboardPage extends StatefulWidget {
  AdminDashboardPage(){}

  @override
  State<StatefulWidget> createState(){
    return _AdminDashboardPageState();
  }
}

class _AdminDashboardPageState extends GeneralPageViewState {
  
  _AdminDashboardPageState(){}


  List<String> buttons = [Constants.navCreatePoi, 
  Constants.navCreatePoiType, Constants.navCreateAlertType];

  selectPage(String key) {
    Navigator.pushNamed(context, '/' + key);
  }

  Widget createNavigationOption(String d) {
  return Container(
      child: ListTile(
        title: Container(
          padding: EdgeInsets.only(bottom: 3.0, left: 20.0),
          child: Text(d,
              style: TextStyle(
                  fontSize: 18.0,
                  color: Theme.of(context).toggleableActiveColor,
                  fontWeight: FontWeight.normal)),
        ),
        dense: true,
        contentPadding: EdgeInsets.all(0.0),
        onTap: () => selectPage(d),
      ));
  }

  Widget getButtons(){
    final List<Widget> buttonWidgets = [];

    for (var w in buttons) {
      buttonWidgets.add(createNavigationOption(w));
    }
  
    return Column(
      children: buttonWidgets);
  }

  @override
  Widget getBody(BuildContext context) {
    return Column(
      children: [ PageTitle(name: Constants.navAdmin),
      getButtons()],
    ); 
  }
}

