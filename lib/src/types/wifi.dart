part of navigine_sdk;

class Wifi extends Equatable {
  const Wifi({
    required this.point,
    required this.locationId,
    required this.sublocationId,
    required this.name,
    required this.mac,
    this.status = TransmitterStatus.status_none
  });

  final Point point;
  final int locationId;
  final int sublocationId;
  final String name;
  final String mac;
  final TransmitterStatus status;

  @override
  List<Object> get props => <Object>[
    point,
    locationId,
    sublocationId,
    name,
    mac,
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
      'mac': mac,
      'status': status.index,
    };
  }

  factory Wifi._fromJson(Map<dynamic, dynamic> json) {
    return Wifi(
      point: Point._fromJson(json['point']),
      locationId: json['locationId'],
      sublocationId: json['sublocationId'],
      name: json['name'],
      mac: json['mac'],
      status: TransmitterStatus.values[json['status']]
    );
  }
}
