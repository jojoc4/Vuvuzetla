import 'package:application/models/Compass.dart';
import 'package:application/widgets/ErrorNetworkWidget.dart';
import 'package:application/widgets/ErrorPermissionWidget.dart';
import 'package:application/widgets/ProfileWidget.dart';
import 'package:application/widgets/TagsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'Repository/MessagesRepository.dart';
import 'Repository/TagsRepository.dart';
import 'AppState.dart';
import 'widgets/MessagesWidget.dart';

void main() {
  runApp(MyApp(
    tagsRepository: TagsRepository(),
    messagesRepository: MessagesRepository(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp(
      {Key? key,
      required this.tagsRepository,
      required this.messagesRepository})
      : super(key: key);
  final TagsRepository tagsRepository;
  final MessagesRepository messagesRepository;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AppState(
            compass: new Compass(direction: 0.0, distance: 0),
            messages: widget.messagesRepository.messages,
            tags: widget.tagsRepository.getTags()),
        child: MaterialApp(
          supportedLocales: [
            Locale('en', ''),
            Locale('fr', ''),
            Locale('de', ''),
            Locale('it', ''),
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            LocalJsonLocalization.delegate,
          ],
          title: 'Vuvuzetla',
          theme: ThemeData(
              primarySwatch: Colors.blue, brightness: Brightness.light),
          darkTheme: ThemeData(
              primaryColor: Colors.blue,
              colorScheme: ColorScheme.dark(
                  secondary: Colors.blue,
                  primary: Colors.blue,
                  tertiary: Colors.blue),
              toggleableActiveColor: Colors.blue,
              brightness: Brightness.dark),
          themeMode: ThemeMode.system,
          home: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vuvuzetla"),
      ),
      body: this.getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: this.selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'navigation-messages'.i18n(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'navigation-tags'.i18n(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'navigation-profile'.i18n(),
          )
        ],
        onTap: (int index) {
          this.onTapHandler(index);
        },
      ),
    );
  }

  Widget getBody() {
    Widget _messagesWidget = MessagesWidget(
        messages: Provider.of<AppState>(context).getMessagesFiltered().reversed.toList(),
        compass: Provider.of<AppState>(context).compass);
    Widget _profileWidget = ProfileWidget();
    Widget _tagsWidget = TagsWidget(tags: Provider.of<AppState>(context).tags);
    Widget _errorPermissionWidget = ErrorPermissionWidget();
    Widget _errorNetworkWidget = ErrorNetworkWidget();
    if (this.selectedIndex == 0) {
      if(Provider.of<AppState>(context).errorPermission){
        return _errorPermissionWidget;
      }else if(Provider.of<AppState>(context).errorNetwork){
        return _errorNetworkWidget;
      }else {
        return _messagesWidget;
      }
    } else if (this.selectedIndex == 1) {
      return _tagsWidget;
    } else {
      return _profileWidget;
    }
  }

  void onTapHandler(int index) {
    this.setState(() {
      this.selectedIndex = index;
    });
  }
}
