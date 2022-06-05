import 'dart:ffi';

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
  bool disabled = false;
  void initState() {
    disabled = false;
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget._mainAxisAlignment,
      children: [
        IconButton(
          iconSize: 30,
          onPressed: () => disabled ? widget._alertController
              .likeAlert(widget._alertId) .then( (value) => {
                  setState(() => {disabled = true})
          }) : null,
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
        ),
        IconButton(
          onPressed: () => widget._alertController
              .dislikeAlert(widget._alertId) .then( (value) => {
                if(value == true)
          }),
          iconSize: 30,
          icon: const Icon(
            Icons.cancel,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
