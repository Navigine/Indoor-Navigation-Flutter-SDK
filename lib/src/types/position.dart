part of navigine_sdk;

class Position extends Equatable {
  const Position({
    required this.point,
    required this.accuracy,
    required this.heading,
    required this.locationPoint,
    required this.locationHeading
  });

  final GlobalPoint point;
  final double accuracy;
  final double? heading;
  final LocationPoint? locationPoint;
  final double? locationHeading;

  @override
  List<Object?> get props => <Object?>[
    point,
    accuracy,
    heading,
    locationPoint,
    locationHeading
  ];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'point': point.toJson(),
      'accuracy': accuracy,
      'heading': heading,
      'locationPoint': locationPoint,
      'locationHeading': locationHeading
    };
  }

  factory Position._fromJson(Map<dynamic, dynamic> json) {
    return Position(
      point: GlobalPoint._fromJson(json['point']),
      accuracy: json['accuracy'],
      heading: json['heading'],
      locationPoint: LocationPoint._fromJson(json['locationPoint']),
      locationHeading: json['locationHeading']
    );
  }
}
