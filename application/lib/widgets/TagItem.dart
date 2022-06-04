import 'package:flutter/material.dart';
import 'package:application/models/Tag.dart';

class TagItem extends StatelessWidget {
  const TagItem(
      {Key? key,
        required this.tag,
        required this.onCheckboxChanged,})
      : super(key: key);

  final Tag tag;
  final ValueChanged<bool?> onCheckboxChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        tag.name,
      ),
      trailing: Checkbox(
        onChanged: onCheckboxChanged,
        value: tag.active,
      ),
    );
  }
}
