import 'dart:async';
import 'dart:io';

import 'package:application/models/Tag.dart';
import 'package:application/tools/APIConnector.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'models/Compass.dart';
import 'models/Message.dart';

class AppState extends ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var deviceInfo = DeviceInfoPlugin();

  List<Message> messages;
  Compass compass;
  List<Tag> tags;
  String currentTag = "Animals";
  late Position position;
  late Timer _timer;
  late String uuid;

  bool readyUuid = false;
  bool readyPosition = false;
  bool readyMessages = false;
  bool readyCompass = false;
  bool errorNetwork = false;
  bool errorPermission = false;
  bool sendingStatus = false;

  AppState({
    required this.messages,
    required this.compass,
    required this.tags,
  }) {
    if (Platform.isIOS) {
      deviceInfo.iosInfo.then((value) {
        uuid = value.identifierForVendor!;
        readyUuid = true;
      });
    } else {
      deviceInfo.androidInfo.then((value) {
        uuid = value.androidId!;
        readyUuid = true;
      });
    }
    _prefs.then((SharedPreferences prefs) {
      currentTag = prefs.getString('currentTag') ?? "Animals";
      notifyListeners();
    });
    periodicTasks();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) => periodicTasks());
  }

  void stopTimer() {
    _timer.cancel();
  }

  void restartTimer() {
    _timer.cancel();
    periodicTasks();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) => periodicTasks());
  }

  void periodicTasks() {
    _determinePosition().then((value) {
      this.position = value;
      readyPosition = true;
    });
    if (readyPosition && readyUuid) {
      APIConnector.fetchMessages(
              this.position.longitude, this.position.latitude, "All", this.uuid)
          .then((value) {
        this.messages = value;
        readyMessages = true;
        errorNetwork = false;
        notifyListeners();
      }).onError((error, stackTrace) {
        errorNetwork = true;
        notifyListeners();
      });
      APIConnector.fetchCompass(
              this.position.longitude, this.position.latitude, this.uuid)
          .then((value) {
        this.compass = value;
        readyCompass = true;
        errorNetwork = false;
        notifyListeners();
      }).onError((error, stackTrace) {
        errorNetwork = true;
        notifyListeners();
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      errorPermission = true;
      notifyListeners();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        errorPermission = true;
        notifyListeners();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      errorPermission = true;
      notifyListeners();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    errorPermission = false;
    notifyListeners();
    return await Geolocator.getCurrentPosition();
  }

  void setCurrentTag(String tag) {
    this.currentTag = tag;
    this.tags.forEach((t) => {if (t.name == tag) t.active = true});
    _prefs.then((prefs) {
      prefs.setString("currentTag", tag);
    });
    notifyListeners();
  }

  List<Message> getMessagesFiltered() {
    var tagsMap =
        Map.fromIterable(tags, key: (e) => e.name, value: (e) => e.active);
    return messages.where((m) => tagsMap[m.category]).toList();
  }

  void addMessage(String text) {
    if (text.length>1) {
      _prefs.then((SharedPreferences prefs) {
        var username = prefs.getString('username') ?? "";
        if (username == ""){
        username = generateWordPairs().first.asString;
        prefs.setString('username', username);
        }
        var msg = Message(
            id: 1,
            longitude: position.longitude,
            latitude: position.latitude,
            message: text,
            uuid: uuid,
            username: username,
            category: currentTag,
            added: "",
            status: 0,
            count: 0);
        APIConnector.addMessage(msg).then((nmsg) {
          messages.add(nmsg);
          notifyListeners();
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(msg: 'error-msg'.i18n());
        });

        notifyListeners();
      });
    }
  }

  void setMessageStatus(index, change) {
    sendingStatus = true;
    notifyListeners();
    int actStatus = messages[index].status;
    int newStatus = actStatus;
    int newCount = messages[index].count;
    switch (actStatus) {
      case -1:
        if (change == -1) {
          newStatus = 0;
          newCount += 1;
        } else {
          newStatus = 1;
          newCount += 2;
        }
        break;
      case 0:
        if (change == -1) {
          newStatus = -1;
          newCount -= 1;
        } else {
          newStatus = 1;
          newCount += 1;
        }
        break;
      case 1:
        if (change == -1) {
          newStatus = -1;
          newCount -= 2;
        } else {
          newStatus = 0;
          newCount -= 1;
        }
        break;
    }
    APIConnector.changeState(newStatus, uuid, messages[index].id).then((response){
      if(response.statusCode == 200){
        messages[index].status = newStatus;
        messages[index].count = newCount;
      }
      if(response.statusCode == 403){
        Fluttertoast.showToast(msg: 'error-react-own'.i18n());
      }
    }).onError((error, stackTrace){
      Fluttertoast.showToast(msg: 'error-react'.i18n());
    });
    sendingStatus = false;
    notifyListeners();
  }

  void setTagState(index, state) {
    tags[index].active = state;
    if (tags[index].name == currentTag) {
      currentTag = "Animals";
    }
    _prefs.then((prefs) {
      prefs.setBool(tags[index].name + "_active", state);
    });

    notifyListeners();
  }
}
