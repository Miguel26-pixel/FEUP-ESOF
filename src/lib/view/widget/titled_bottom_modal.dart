import 'package:flutter/material.dart';
import 'package:src/view/widget/rounded_bottom_modal.dart';

class TitledBottomModal extends StatelessWidget {
  final Widget? _header;
  final List<Widget> _children;
  final double _minWidth;
  final double _headerHeight;
  const TitledBottomModal(
      {Key? key,
      Widget? header,
      required List<Widget> children,
      double minWidth = 400,
      double headerHeight = 62})
      : _header = header,
        _children = children,
        _minWidth = minWidth,
        _headerHeight = headerHeight,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Container(
        padding: const EdgeInsets.all(8),
        height: _headerHeight,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Color.fromARGB(255, 220, 220, 220),
              width: 1,
            ),
          ),
        ),
        child: _header,
      ),
    ];

    children.addAll(_children);

    return RoundedBottomModal(
      minWidth: _minWidth,
      child: Column(
        children: children,
      ),
    );
  }
}
