part of navigine_sdk;

class LocationPolyline extends Equatable {
  const LocationPolyline({
    required this.polyline,
    required this.locationId,
    required this.sublocationId,
  });

  final Polyline polyline;
  final int locationId;
  final int sublocationId;

  @override
  List<Object> get props => <Object>[
    polyline,
    locationId,
    sublocationId
  ];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'polyline': polyline.toJson(),
      'locationId': locationId,
      'sublocationId': sublocationId

    };
  }

  factory LocationPolyline._fromJson(Map<dynamic, dynamic> json) {
    return LocationPolyline(
      polyline: Polyline._fromJson(json['LocationPoLyline']),
      locationId: json['locationId'],
      sublocationId: json['sublocationId']
    );
  }
}
