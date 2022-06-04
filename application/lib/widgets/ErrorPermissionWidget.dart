import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';


class ErrorPermissionWidget extends StatefulWidget{
  @override
  State<ErrorPermissionWidget> createState() => _ErrorPermissionWidgetState();
}

class _ErrorPermissionWidgetState extends State<ErrorPermissionWidget> {



  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'error-permission'.i18n(),
              style: Theme.of(context).textTheme.headline3,
            )
          ],
        ),
    );
  }

}