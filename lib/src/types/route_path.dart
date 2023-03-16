part of navigine_sdk;

class RoutePath extends Equatable {
  const RoutePath({
    required this.length,
    required this.events,
    required this.points
  });

  final double length;
  final List<RouteEvent> events;
  final List<LocationPoint> points;

  @override
  List<Object?> get props => <Object?>[
    length,
    events,
    points
  ];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'events': events.map((RouteEvent e) => e.toJson()).toList(),
      'points': points.map((LocationPoint p) => p.toJson()).toList()
    };
  }

  factory RoutePath._fromJson(Map<dynamic, dynamic> json) {
    return RoutePath(
      length: json['length'],
      events: json['events'].map<RouteEvent>((el) => RouteEvent._fromJson(el)).toList(),
      points: json['points'].map<LocationPoint>((el) => LocationPoint._fromJson(el)).toList()
    );
  }
}
