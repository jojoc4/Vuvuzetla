import 'package:application/models/Message.dart';
import 'package:application/widgets/CompassWidget.dart';
import 'package:application/widgets/LoadingWidget.dart';
import 'package:application/widgets/MessageItem.dart';
import 'package:application/widgets/TextComposer.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../AppState.dart';
import '../models/Compass.dart';

class MessagesWidget extends StatelessWidget {
  MessagesWidget({Key? key, required this.messages, required this.compass})
      : super(key: key);
  List<Message> messages;
  Compass compass;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          !Provider.of<AppState>(context).readyMessages &&
                  !Provider.of<AppState>(context).readyCompass
              ? LoadingWidget()
              : messages.length > 0
                  ? Flexible(
                      child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, index) => MessageItem(
                          message: messages[index],
                          index: messages.length - 1 - index),
                      itemCount: messages.length,
                    ))
                  : Expanded(
                      child: Column(
                      children: [
                        Expanded(
                            child: CompassWidget(
                          direction:
                              Provider.of<AppState>(context).compass.direction,
                          compact: MediaQuery.of(context).orientation ==
                                  Orientation.landscape ||
                              MediaQuery.of(context).viewInsets.bottom != 0,
                        )),
                        SizedBox(height: 20.0),
                        Text(
                            "message-distance-text".i18n([
                              Provider.of<AppState>(context)
                                  .compass
                                  .distance
                                  .toString()
                            ]),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline4),
                        SizedBox(height: 20.0)
                      ],
                    )),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: TextComposer(),
          )
        ],
      ),
    );
  }
}
