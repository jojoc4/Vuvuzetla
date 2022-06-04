import 'package:application/widgets/TagItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../AppState.dart';
import '../models/Tag.dart';

class TagsWidget extends StatelessWidget {
  TagsWidget({Key? key, required this.tags}) : super(key: key);
  List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tags.length,
      itemBuilder: (context, index) {
        Tag tag = tags[index];
        return TagItem(
            tag: tag,
            onCheckboxChanged: (active) {
              this.tags[index].active = active!;
              Provider.of<AppState>(context, listen: false)
                  .setTagState(index, active);
            });
      },
    );
  }
}
