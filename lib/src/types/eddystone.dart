part of navigine_sdk;

class Eddystone extends Equatable {
  const Eddystone({
    required this.point,
    required this.locationId,
    required this.sublocationId,
    required this.name,
    required this.namespaceId,
    required this.instanceId,
    required this.power,
    this.status = TransmitterStatus.status_none,
  });

  final Point point;
  final int locationId;
  final int sublocationId;
  final String name;
  final String namespaceId;
  final String instanceId;
  final int power;
  final TransmitterStatus status;

  @override
  List<Object> get props => <Object>[
    point,
    locationId,
    sublocationId,
    name,
    namespaceId,
    instanceId,
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
      'namespaceId': namespaceId,
      'instanceId': instanceId,
      'power': power,
      'status': status.index,
    };
  }

  factory Eddystone._fromJson(Map<dynamic, dynamic> json) {
    return Eddystone(
      point: Point._fromJson(json['point']),
      locationId: json['locationId'],
      sublocationId: json['sublocationId'],
      name: json['name'],
      namespaceId: json['namespaceId'],
      instanceId: json['instanceId'],
      power: json['power'],
      status: TransmitterStatus.values[json['status']]
    );
  }
}
