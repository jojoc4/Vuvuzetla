import 'dart:convert';

import 'package:application/models/Compass.dart';
import 'package:application/models/Message.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class APIConnector {
  const APIConnector();

  static Future<List<Message>> fetchMessages(
      double lon, double lat, String cat, String uuid) async {
    final response = await http.get(Uri.parse(
        'https://vuvuzetla.host-free.ch?r=messages&longitude=' +
            lon.toString() +
            '&latitude=' +
            lat.toString() +
            '&category=' +
            cat +
            '&uuid=' +
            uuid));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonresponse = jsonDecode(response.body);
      final List<dynamic> jsonMessages = jsonresponse['messages'];
      var msgs = <Message>[];
      jsonMessages.forEach((value) {
        msgs.add(Message.fromJson(value));
      });
      return msgs;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return Future.error("Network error");
    }
  }

  static Future<Compass> fetchCompass(
      double lon, double lat, String uuid) async {
    final response = await http.get(Uri.parse(
        'https://vuvuzetla.host-free.ch?r=messages&longitude=' +
            lon.toString() +
            '&latitude=' +
            lat.toString() +
            '&category=All&uuid=' +
            uuid));

    if (response.statusCode == 200) {
      return Compass.fromJson(jsonDecode(response.body)['nearest']);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return Future.error("Network error");
    }
  }

  static Future<Message> addMessage(Message msg) async {
    final response = await  http.post(Uri.parse("https://vuvuzetla.host-free.ch?r=messages"),
        headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded"
        },
        body: <String, String>{
          "uuid": msg.uuid,
          "username": msg.username,
          "message": msg.message,
          "longitude": msg.longitude.toString(),
          "latitude": msg.latitude.toString(),
          "category": msg.category,
        });
    if (response.statusCode == 200) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return Future.error("Network error");
    }
  }

  static Future<Response> changeState(int value, String uuid, int id) {
    return http.post(Uri.parse("https://vuvuzetla.host-free.ch?r=action"),
        headers: <String, String>{
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: <String, String>{
          "uuid": uuid,
          "id": id.toString(),
          "value": value.toString(),
        });
  }
}
