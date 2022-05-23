import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/live/titled_bottom_modal.dart';

class CreateSpontaneousAlert extends StatefulWidget {
  const CreateSpontaneousAlert({Key key}) : super(key: key);

  @override
  State<CreateSpontaneousAlert> createState() => _CreateSpontaneousAlertState();
}

class _CreateSpontaneousAlertState extends State<CreateSpontaneousAlert> {
  @override
  Widget build(BuildContext context) {
    return TitledBottomModal(
      header: Row(
        children: [
          Expanded(
            child: AutoSizeText(
              "What's happening?".toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      multiple: false,
      children: [Expanded(child: SizedBox())],
    );
  }
}
