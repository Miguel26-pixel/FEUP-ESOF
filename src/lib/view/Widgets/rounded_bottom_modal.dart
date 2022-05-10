import 'dart:math';

import 'package:flutter/material.dart';

class RoundedBottomModal extends StatelessWidget {
  final double _minHeight;
  final Widget _child;
  final double _width;
  const RoundedBottomModal(
      {Key key, double minHeight = 400, Widget child, double width})
      : _minHeight = minHeight,
        _child = child,
        _width = width,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        height: min(_minHeight, MediaQuery.of(context).size.height),
      ),
      child: Container(
        width: _width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.white,
        ),
        margin: EdgeInsets.all(_width == null ? 10 : 0),
        child: _child,
      ),
    );
  }
}
