part of navigine_sdk;

class RouteEvent extends Equatable {
  const RouteEvent({
    required this.type,
    required this.value,
    required this.distance,
  });

  final RouteEventType type;
  final int value;
  final double distance;

  @override
  List<Object?> get props => <Object?>[
    type,
    value,
    distance,
  ];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'value': value,
      'distance': distance,
    };
  }

  factory RouteEvent._fromJson(Map<dynamic, dynamic> json) {
    return RouteEvent(
      type: RouteEventType.values[json['type']], // SuggestItemType
      value: json['value'],
      distance: json['distance'],
    );
  }
}

/// Route Event types
enum RouteEventType {
  turn_left,
  turn_right,
  transition
}