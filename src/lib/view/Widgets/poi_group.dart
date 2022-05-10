import 'package:flutter/widgets.dart';
import 'package:uni/model/entities/live/point_group.dart';

class PointOfInterestGroupWidget extends StatefulWidget {
  final PointOfInterestGroup _group;
  const PointOfInterestGroupWidget(final this._group, {Key key})
      : super(key: key);

  @override
  State<PointOfInterestGroupWidget> createState() =>
      _PointOfInterestGroupWidgetState();
}

class _PointOfInterestGroupWidgetState
    extends State<PointOfInterestGroupWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
