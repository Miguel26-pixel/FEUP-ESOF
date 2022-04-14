import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:src/model/point.dart';
import 'package:src/view/widget/titled_bottom_modal.dart';
import 'package:src/view/widget/validation_buttons.dart';

class PointOfInterestPage extends StatefulWidget {
  final PointOfInterest _poi;
  const PointOfInterestPage(final this._poi, {Key? key}) : super(key: key);

  @override
  State<PointOfInterestPage> createState() => _PointOfInterestPageState();
}

class _PointOfInterestPageState extends State<PointOfInterestPage> {
  Widget buildAlertItem(BuildContext context, int i) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(50, 0, 0, 0),
                offset: Offset(0, 1),
                blurRadius: 1,
                spreadRadius: 0,
              )
            ]),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Align(
                alignment: Alignment.centerRight,
                child: ValidationButtons(
                  mainAxisAlignment: MainAxisAlignment.end,
                )),
            Align(
              alignment: Alignment.center,
              child: Text(
                widget._poi.getAlerts()[i].getGeneralAlert().getName(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 60,
                child: Icon(
                  widget._poi.getAlerts()[i].getGeneralAlert().getIconData(),
                  size: 35,
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    String titleString = widget._poi.getName();

    Widget _title = AutoSizeText(
      titleString.toUpperCase(),
      textAlign: TextAlign.center,
      maxLines: 2,
      style: const TextStyle(
        fontSize: 17,
        color: Colors.black,
        fontWeight: FontWeight.w800,
      ),
    );

    return TitledBottomModal(
      header: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.notification_add),
            onPressed: () {},
          ),
          Expanded(
            child: _title,
          ),
          IconButton(
            iconSize: 30,
            icon: const Icon(Icons.bar_chart),
            onPressed: () {},
          ),
        ],
      ),
      children: [
        Expanded(
          child: widget._poi.getAlerts().isEmpty
              ? const Center(
                  child: SizedBox(
                    width: 200,
                    child: Text(
                      "There are no active alerts here at this moment.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemBuilder: buildAlertItem,
                  itemCount: widget._poi.getAlerts().length,
                ),
        ),
      ],
    );
  }
}
