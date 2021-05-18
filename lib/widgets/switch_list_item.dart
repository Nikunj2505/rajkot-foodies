import 'package:flutter/material.dart';

class SwitchListItem extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final Function updateSwitch;
  SwitchListItem(
      {this.title, this.description, this.isSelected, this.updateSwitch});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        title: Text(
          '$title',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          '$description',
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        value: isSelected,
        onChanged: updateSwitch);
  }
}
