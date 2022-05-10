import 'package:flutter/material.dart';

class ValidationButtons extends StatefulWidget {
  final MainAxisAlignment _mainAxisAlignment;
  const ValidationButtons(
      {Key key, MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center})
      : _mainAxisAlignment = mainAxisAlignment,
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
          onPressed: () {},
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
        ),
        IconButton(
          onPressed: () {},
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
