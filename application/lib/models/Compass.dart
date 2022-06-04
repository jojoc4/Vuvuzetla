
class Compass {
  late double direction;
  late int distance;

  Compass({
    required this.direction,
    required this.distance,
  });

  factory Compass.fromJson(Map<String, dynamic> json) {
    return Compass(
      direction: json['direction'].toDouble(),
      distance: json['distance'].toDouble().round(),
    );
  }
}