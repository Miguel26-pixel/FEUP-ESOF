import 'package:flutter/material.dart';
import 'package:src/view/widget/rounded_bottom_modal.dart';

class TitledBottomModal extends StatelessWidget {
  final Widget? _header;
  final List<Widget> _children;
  const TitledBottomModal(
      {Key? key, Widget? header, required List<Widget> children})
      : _header = header,
        _children = children,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Container(
        padding: const EdgeInsets.all(8),
        height: 62,
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
      child: Column(
        children: children,
      ),
    );
  }
}
