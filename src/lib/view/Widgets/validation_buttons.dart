import 'package:flutter/material.dart';
import 'package:uni/controller/alert/alert_controller_interface.dart';

class ValidationButtons extends StatefulWidget {
  final MainAxisAlignment _mainAxisAlignment;
  final AlertControllerInterface _alertController;
  final String _spontaneousAlertId;
  const ValidationButtons(
      {Key key,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
      AlertControllerInterface alertController,
      String spontaneousAlertId})
      : _mainAxisAlignment = mainAxisAlignment,
        _alertController = alertController,
        _spontaneousAlertId = spontaneousAlertId,
        super(key: key);

  @override
  State<ValidationButtons> createState() => _ValidationButtonsState();
}

class _ValidationButtonsState extends State<ValidationButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget._mainAxisAlignment,
      children: [
        IconButton(
          iconSize: 30,
          onPressed: () => widget._alertController
              .likeAlert(widget._spontaneousAlertId),
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
        ),
        IconButton(
          onPressed: () => {},
          //widget._alertController.dislikeAlert(widget._spontaneousAlertId),
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
