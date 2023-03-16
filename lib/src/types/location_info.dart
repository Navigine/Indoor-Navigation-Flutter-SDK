part of navigine_sdk;

class LocationInfo extends Equatable {
  const LocationInfo({
    required this.id,
    required this.version,
    required this.name,
  });

  final int id;
  final int version;
  final String name;

  @override
  List<Object> get props => <Object>[
    id,
    version,
    name
  ];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'name': name
    };
  }

  factory LocationInfo._fromJson(Map<dynamic, dynamic> json) {
    return LocationInfo(
      id: json['id'],
      version: json['version'],
      name: json['name'],
    );
  }
}
