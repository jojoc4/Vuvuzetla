
class Message {
  late int id;
  final double longitude;
  final double latitude;
  final String message;
  final String uuid;
  final String username;
  final String category;
  final String added;
  late int status;
  late int count;

  Message({
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.message,
    required this.uuid,
    required this.username,
    required this.category,
    required this.added,
    required this.status,
    required this.count,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: int.parse(json['id']),
      longitude: double.parse(json['longitude']),
      latitude: double.parse(json['latitude']),
      message: json['message'],
      uuid: json['uuid'],
      username: json['username'],
      category: json['category'],
      added: json['added'],
      status: int.parse(json['status'].toString()),
      count: int.parse(json['count'].toString()),
    );
  }
}