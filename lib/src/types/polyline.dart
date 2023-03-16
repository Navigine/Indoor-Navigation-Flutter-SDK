part of navigine_sdk;

class Polyline extends Equatable {
  const Polyline({
    required this.points
  });

  final List<Point> points;

  @override
  List<Object> get props => <Object>[
    points
  ];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((Point p) => p.toJson()).toList(),
    };
  }

  factory Polyline._fromJson(Map<dynamic, dynamic> json) {
    return Polyline(
      points: json['points'].map<Point>((el) => Point._fromJson(el)).toList(),
    );
  }
}
