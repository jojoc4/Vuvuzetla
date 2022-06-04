import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_words/english_words.dart';

class ProfileWidget extends StatefulWidget {
  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final _textController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
     _prefs.then((SharedPreferences prefs) {
       _textController.text = prefs.getString('username') ?? generateWordPairs().first.asString;
       if(_textController.text.length==0) _textController.text = generateWordPairs().first.asString;
       prefs.setString('username', _textController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Expanded(
                        child: Text("profile-username".i18n()),
                      ),
                      Expanded(
                          child: TextField(
                            controller: _textController,
                            onSubmitted: (String value) async {
                              if(value.length==0) _textController.text = generateWordPairs().first.asString;
                              final SharedPreferences prefs = await _prefs;
                              prefs.setString('username', _textController.text);
                            },
                            decoration:
                               InputDecoration.collapsed(hintText: "profile-username-hint".i18n()),
                          )
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Expanded(
                        child: Text("profile-score".i18n()),
                      ),
                      Expanded(
                          child: Text("Coming soon")
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width: 10),
              Text("profile-about-title".i18n(), style: Theme.of(context).textTheme.headline6)
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              SizedBox(width: 10),
              Expanded(child: Text("profile-about-1".i18n())
              )
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              SizedBox(width: 10),
              Expanded(child: Text("profile-about-2".i18n())
              )
            ],
          ),
          Row(
            children: [
              SizedBox(width: 10),
              Expanded(child: Text("profile-about-3".i18n())
              )
            ],
          ),
          SizedBox(height: 8),
        ],
      )
    );
  }
}