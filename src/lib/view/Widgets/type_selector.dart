import 'package:flutter/material.dart';
import 'package:uni/model/entities/live/poi_type.dart';

class TypeSelector extends StatefulWidget {
  TypeSelector({
    Key key,
    this.types,
    this.callback,
    this.selected,
  }) : super(key: key);

  final List<PointOfInterestType> types;
  final void Function(int) callback;
  final int selected;

  @override
  State<TypeSelector> createState() => _TypeSelectorState();
}

class _TypeSelectorState extends State<TypeSelector> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        primary: false,
        padding: EdgeInsets.fromLTRB(70, 30, 25, 0),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width / 4,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: widget.types.length,
        itemBuilder: (BuildContext context, index) {
          return ToggleButtons(
            onPressed: (_) => widget.callback(index),
            fillColor: Colors.white60,
            renderBorder: false,
            children: [
              Column(
                children: [
                  Icon(
                    widget.types[index].getIcon(),
                    size: 40,
                  ),
                  Expanded(
                    child: Text(
                      widget.types[index].getName(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis, // and this
                    ),
                  ),
                ],
              ),
            ],
            isSelected: [widget.selected == index],
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
        });
  }
}
