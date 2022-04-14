import 'dart:math';

import 'package:flutter/material.dart';

class RoundedBottomModal extends StatelessWidget {
  final double _minHeight;
  final Widget? _child;
  const RoundedBottomModal({Key? key, double minHeight = 400, Widget? child})
      : _minHeight = minHeight,
        _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        height: min(_minHeight, MediaQuery.of(context).size.height),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.white,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 10,
        ),
        child: _child,
      ),
    );
  }
}
