import 'package:flutter/widgets.dart';
import 'package:src/model/spontaneous_alert.dart';

class SpontaneousAlertPage extends StatefulWidget {
  final SpontaneousAlert _spontaneousAlert;
  const SpontaneousAlertPage(final this._spontaneousAlert, {Key? key})
      : super(key: key);

  @override
  State<SpontaneousAlertPage> createState() => _SpontaneousAlertPageState();
}

class _SpontaneousAlertPageState extends State<SpontaneousAlertPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
