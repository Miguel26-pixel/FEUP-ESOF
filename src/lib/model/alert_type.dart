import 'package:flutter/material.dart';

class AlertType {
  final String _name;
  final String _message;
  final Duration _baseTime;
  final IconData _iconData;

  AlertType(this._name, this._message, this._baseTime, this._iconData);

  String getName() {
    return this._name;
  }

  String getMessage() {
    return this._message;
  }

  Duration getBaseTime() {
    return this._baseTime;
  }

  IconData getIconData() {
    return this._iconData;
  }
}
