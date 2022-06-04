import 'package:application/AppState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Message.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    required this.message,
    required this.index,
    Key? key,
  }) : super(key: key);
  final Message message;
  final int index;
  final enabled=true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.username, style: Theme.of(context).textTheme.headline6),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(message.message),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                onPressed: Provider.of<AppState>(context, listen: false).sendingStatus ? null : () {
                  Provider.of<AppState>(context, listen: false).setMessageStatus(index, 1);
                },
                color: Provider.of<AppState>(context, listen: false).sendingStatus ? Colors.black12 : message.status==1 ? Colors.blue : Colors.black,
              ),
              Text(message.count.toString(), textAlign: TextAlign.center,),
              IconButton(
                icon: const Icon(Icons.arrow_downward),
                onPressed: Provider.of<AppState>(context, listen: false).sendingStatus ? null : () {
                  Provider.of<AppState>(context, listen: false).setMessageStatus(index, -1);
                },
                color: Provider.of<AppState>(context, listen: false).sendingStatus ? Colors.black12 : message.status==-1 ? Colors.red : Colors.black,
              ),
            ],
          )
        ],
      ),
    );
  }
}
