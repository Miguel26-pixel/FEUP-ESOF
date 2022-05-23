import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/rounded_bottom_modal.dart';

class TitledBottomModal extends StatelessWidget {
  final Widget _header;
  final List<Widget> _children;
  final double _minHeight;
  final double _headerHeight;
  final bool _multiple;
  const TitledBottomModal(
      {Key key,
      Widget header,
      List<Widget> children,
      bool multiple,
      double minHeight = 400,
      double headerHeight = 62})
      : _header = header,
        _children = children,
        _minHeight = minHeight,
        _headerHeight = headerHeight,
        _multiple = multiple,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Container(
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

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: RoundedBottomModal(
        width: MediaQuery.of(context).size.width - (_multiple ? 40 : 20),
        minHeight: _minHeight,
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
