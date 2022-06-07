import 'package:flutter/material.dart';
import 'package:uni/model/entities/live/alert_type.dart';

class AlertTypeSelector extends StatefulWidget {
  AlertTypeSelector({
    Key key,
    this.types,
    this.callback,
    this.selected,
  }) : super(key: key);

  final List<AlertType> types;
  final void Function(int) callback;
  final int selected;

  @override
  State<AlertTypeSelector> createState() => _AlertTypeSelectorState();
}

class _AlertTypeSelectorState extends State<AlertTypeSelector> {
  int _selected;

  @override
  void initState() {
    super.initState();
    _selected = -1;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        primary: false,
        padding: EdgeInsets.fromLTRB(25, 30, 25, 0),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: widget.types.length,
        itemBuilder: (BuildContext context, index) {
          final _name = widget.types[index].getName();
          return ToggleButtons(
            onPressed: (_) {
              widget.callback(index);
              setState(() {
                _selected = index;
              });
            },
            renderBorder: false,
            children: [
              Column(
                key: Key('alert-type-${index.toString()}'),
                children: [
                  Icon(
                    widget.types[index].getIconData(),
                    size: 40,
                  ),
                  Expanded(
                    child: Text(
                      _name.length > 6 ? _name.substring(0, 6) + '...' : _name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // and this
                    ),
                  ),
                ],
              ),
            ],
            fillColor: Colors.white,
            isSelected: [_selected == index],
            selectedColor: Theme.of(context).colorScheme.secondary,
          );
        });
  }
}
