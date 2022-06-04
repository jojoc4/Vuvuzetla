
import '../models/Message.dart';

class MessagesRepository {

  final List<Message> _messages = [
      //Message(id: 1, longitude: 12.2, latitude: 7.6, message: "message", uuid: "uuid", username: "username", category: "Food", added: "123432423", status: 0, count: 0)
  ];

  List<Message> get messages => _messages;
}
