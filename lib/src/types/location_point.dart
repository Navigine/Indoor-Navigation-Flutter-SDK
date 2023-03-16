part of navigine_sdk;

class LocationPoint extends Equatable {
  const LocationPoint({
    required this.point,
    required this.locationId,
    required this.sublocationId,
  });

  final Point point;
  final int locationId;
  final int sublocationId;

  @override
  List<Object> get props => <Object>[
    point,
    locationId,
    sublocationId
  ];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'point': point.toJson(),
      'locationId': locationId,
      'sublocationId': sublocationId

    };
  }

  factory LocationPoint._fromJson(Map<dynamic, dynamic> json) {
    return LocationPoint(
      point: Point._fromJson(json['point']),
      locationId: json['locationId'],
      sublocationId: json['sublocationId']
    );
  }
}
