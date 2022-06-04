import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../AppState.dart';


class ErrorNetworkWidget extends StatefulWidget{
  @override
  State<ErrorNetworkWidget> createState() => _ErrorNetworkWidgetState();
}

class _ErrorNetworkWidgetState extends State<ErrorNetworkWidget> {



  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'error-network'.i18n(),
              style: Theme.of(context).textTheme.headline3,
            ),
            TextButton(onPressed: (){
              Provider.of<AppState>(context, listen: false).restartTimer();
            }, child: Text("retry".i18n()))
          ],
        ),
    );
  }

}