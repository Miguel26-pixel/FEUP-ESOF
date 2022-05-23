import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/live/titled_bottom_modal.dart';

class CreateSpontaneousAlert extends StatefulWidget {
  const CreateSpontaneousAlert({Key key}) : super(key: key);

  @override
  State<CreateSpontaneousAlert> createState() => _CreateSpontaneousAlertState();
}

class _CreateSpontaneousAlertState extends State<CreateSpontaneousAlert>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  AnimationController _controller;
  Animation _animation;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    _animation = Tween(begin: 0.0, end: 120.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  Widget getTitle() {
    return AutoSizeText(
      "What's happening?".toUpperCase(),
      textAlign: TextAlign.center,
      maxLines: 2,
      style: const TextStyle(
        fontSize: 17,
        color: Colors.black,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets _insets = MediaQuery.of(context).viewInsets;

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: max(0, _insets.bottom - 150)),
      child: TitledBottomModal(
        header: Row(
          children: [
            Expanded(child: getTitle()),
          ],
        ),
        multiple: false,
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      //focusNode: _focusNode,
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
