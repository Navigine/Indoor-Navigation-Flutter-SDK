part of navigine_sdk;

class Location extends Equatable {
  const Location({
    required this.id,
    required this.version,
    required this.name,
    required this.description,
    required this.sublocations,
  });

  final int id;
  final int version;
  final String name;
  final String description;
  final List<Sublocation> sublocations;

  @override
  List<Object> get props => <Object>[
    id,
    version,
    name,
    description,
    sublocations
  ];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'name': name,
      'description': description,
      'sublocations': sublocations.map((Sublocation s) => s.toJson()).toList()
    };
  }

  factory Location._fromJson(Map<dynamic, dynamic> json) {
    return Location(
      id: json['id'],
      version: json['version'],
      name: json['name'],
      description: json['description'],
      sublocations: json['sublocations'].map<Sublocation>((el) => Sublocation._fromJson(el)).toList()
    );
  }
}
