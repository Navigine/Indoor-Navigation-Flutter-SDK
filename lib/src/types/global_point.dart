part of navigine_sdk;

class GlobalPoint extends Equatable {
  const GlobalPoint({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  List<Object> get props => <Object>[
    latitude,
    longitude
  ];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude
    };
  }

  factory GlobalPoint._fromJson(Map<dynamic, dynamic> json) {
    return GlobalPoint(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
