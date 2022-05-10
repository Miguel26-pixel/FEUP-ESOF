import 'package:flutter/material.dart';

class AlertType {
  final String _name;
  final String _message;
  final Duration _baseTime;
  final IconData _iconData;
  final int _id;

  AlertType(
      this._id, this._name, this._message, this._baseTime, this._iconData);

  String getName() {
    return _name;
  }

  String getMessage() {
    return _message;
  }

  Duration getBaseTime() {
    return _baseTime;
  }

  IconData getIconData() {
    return _iconData;
  }

  int getId() {
    return _id;
  }
}
