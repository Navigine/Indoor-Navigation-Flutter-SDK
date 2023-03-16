part of navigine_sdk;

class Sublocation extends Equatable {
  const Sublocation({
    required this.id,
    required this.location,
    required this.name,
    required this.width,
    required this.height,
    required this.azimuth,
    required this.originPoint,
    required this.levelId,
    required this.beacons,
    required this.eddystones,
    required this.wifis,
    required this.venues
  });

  final int id;
  final int location;
  final String name;
  final double width;
  final double height;
  final double azimuth;
  final GlobalPoint originPoint;
  final String levelId;
  final List<Beacon> beacons;
  final List<Eddystone> eddystones;
  final List<Wifi> wifis;
  final List<Venue> venues;

  @override
  List<Object> get props => <Object>[
    id,
    location,
    name,
    width,
    height,
    azimuth,
    originPoint,
    levelId,
    beacons,
    eddystones,
    wifis,
    venues
  ];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'name': name,
      'width': width,
      'height': height,
      'azimuth': azimuth,
      'originPoint': originPoint.toJson(),
      'levelId': levelId,
      'beacons': beacons.map((Beacon b) => b.toJson()).toList(),
      'eddystones': eddystones.map((Eddystone e) => e.toJson()).toList(),
      'wifis': wifis.map((Wifi w) => w.toJson()).toList(),
      'venues': venues.map((Venue v) => v.toJson()).toList()
    };
  }

  factory Sublocation._fromJson(Map<dynamic, dynamic> json) {
    return Sublocation(
      id: json['id'],
      location: json['location'],
      name: json['name'],
      width: json['width'],
      height: json['height'],
      azimuth: json['azimuth'],
      originPoint: GlobalPoint._fromJson(json['originPoint']),
      levelId: json['levelId'],
      beacons: json['beacons'].map<Beacon>((el) => Beacon._fromJson(el)).toList(),
      eddystones: json['eddystones'].map<Eddystone>((el) => Eddystone._fromJson(el)).toList(),
      wifis: json['wifis'].map<Wifi>((el) => Wifi._fromJson(el)).toList(),
      venues: json['venues'].map<Venue>((el) => Venue._fromJson(el)).toList(),
    );
  }
}
