part of navigine_sdk;

class Beacon extends Equatable {
  const Beacon({
    required this.point,
    required this.locationId,
    required this.sublocationId,
    required this.name,
    required this.major,
    required this.minor,
    required this.uuid,
    required this.power,
    this.status = TransmitterStatus.status_none,
  });

  final Point point;
  final int locationId;
  final int sublocationId;
  final String name;
  final int major;
  final int minor;
  final String uuid;
  final int? power;
  final TransmitterStatus status;

  @override
  List<Object?> get props => <Object?>[
    point,
    locationId,
    sublocationId,
    name,
    major,
    minor,
    uuid,
    power,
    status,
  ];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'point': point.toJson(),
      'locationId': locationId,
      'sublocationId': sublocationId,
      'name': name,
      'major': major,
      'minor': minor,
      'uuid': uuid,
      'power': power,
      'status': status.index,
    };
  }

  factory Beacon._fromJson(Map<dynamic, dynamic> json) {
    return Beacon(
      point: Point._fromJson(json['point']),
      locationId: json['locationId'],
      sublocationId: json['sublocationId'],
      name: json['name'],
      major: json['major'],
      minor: json['minor'],
      uuid: json['uuid'],
      power: json['power'],
      status: TransmitterStatus.values[json['status']]
    );
  }
}
