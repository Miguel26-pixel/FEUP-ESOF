import 'package:flutter/material.dart';

class AlertType {
  final String _name;
  final String _message;
  final Duration _baseTime;
  final ImageIcon _icon;

  AlertType(this._name, this._message, this._baseTime, this._icon);

  String getName() {
    return this._name;
  }

  String getMessage() {
    return this._message;
  }

  Duration getBaseTime() {
    return this._baseTime;
  }

  ImageIcon getIcon() {
    return this._icon;
  }
}
