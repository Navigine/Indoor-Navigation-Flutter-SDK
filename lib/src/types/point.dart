part of navigine_sdk;

class Point extends Equatable {
  const Point({
    required this.x,
    required this.y,
  });

  final double x;
  final double y;

  @override
  List<Object> get props => <Object>[
    x,
    y
  ];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y
    };
  }

  factory Point._fromJson(Map<dynamic, dynamic> json) {
    return Point(
      x: json['x'],
      y: json['y'],
    );
  }
}
