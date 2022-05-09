import 'package:flutter/material.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/map.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapPageState();
}

/// Tracks the state of home page.
class MapPageState extends GeneralPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return Map();
  }
}
