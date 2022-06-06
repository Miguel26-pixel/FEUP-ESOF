import 'package:flutter/material.dart';
import 'package:uni/controller/alert/alert_controller_interface.dart';

class ValidationButtons extends StatefulWidget {
  final MainAxisAlignment _mainAxisAlignment;
  final AlertControllerInterface _alertController;
  final String _alertId;
  const ValidationButtons(
      {Key key,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
      AlertControllerInterface alertController,
      String alertId})
      : _mainAxisAlignment = mainAxisAlignment,
        _alertController = alertController,
        _alertId = alertId,
        super(key: key);

  @override
  State<ValidationButtons> createState() => _ValidationButtonsState();
}

class _ValidationButtonsState extends State<ValidationButtons> {
  bool _disabled;

  @override
  // ignore: must_call_super
  void initState() {
    _disabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget._mainAxisAlignment,
      children: [
        IconButton(
          iconSize: 30,
          onPressed: !_disabled
              ? () {
                  setState(() {
                    _disabled = true;
                  });

                  widget._alertController.likeAlert(widget._alertId);
                }
              : null,
          icon: Icon(
            Icons.check_circle,
            color: !_disabled ? Colors.green : Colors.grey,
          ),
        ),
        IconButton(
          onPressed: !_disabled
              ? () {
                  setState(() {
                    _disabled = true;
                  });

                  widget._alertController.dislikeAlert(widget._alertId);
                }
              : null,
          iconSize: 30,
          icon: Icon(
            Icons.cancel,
            color: !_disabled ? Colors.red : Colors.grey,
          ),
        ),
      ],
    );
  }
}
