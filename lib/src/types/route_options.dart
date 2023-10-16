part of navigine_sdk;

class RouteOptions extends Equatable {
  const RouteOptions({
    required this.smoothRadius,
    required this.maxProjectionDistance,
    required this.maxAdvance,
  });

  final double smoothRadius;
  final double maxProjectionDistance;
  final double maxAdvance;

  @override
  List<Object> get props => <Object>[
    smoothRadius,
    maxProjectionDistance,
    maxAdvance
  ];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'smoothRadius': smoothRadius,
      'maxProjectionDistance': maxProjectionDistance,
      'maxAdvance': maxAdvance

    };
  }

  factory RouteOptions._fromJson(Map<dynamic, dynamic> json) {
    return RouteOptions(
      smoothRadius: json['smoothRadius'],
      maxProjectionDistance: json['maxProjectionDistance'],
      maxAdvance: json['maxAdvance']
    );
  }
}
