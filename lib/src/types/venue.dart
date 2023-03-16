part of navigine_sdk;

class Venue extends Equatable {
  const Venue({
    required this.point,
    required this.locationId,
    required this.sublocationId,
    required this.id,
    required this.name,
    required this.phone,
    required this.description,
    required this.alias,
    required this.categoryId,
    // required this.imageUrl
  });

  final Point point;
  final int locationId;
  final int sublocationId;
  final int id;
  final String name;
  final String phone;
  final String description;
  final String alias;
  final int categoryId;
  // final String imageUrl;

  @override
  List<Object> get props => <Object>[
    point,
    locationId,
    sublocationId,
    id,
    name,
    phone,
    description,
    alias,
    categoryId,
    // imageUrl
  ];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'point': point.toJson(),
      'locationId': locationId,
      'sublocationId': sublocationId,
      'id': id,
      'name': name,
      'phone': phone,
      'description': description,
      'alias': alias,
      'categoryId': categoryId,
      // 'imageUrl': imageUrl
    };
  }

  factory Venue._fromJson(Map<dynamic, dynamic> json) {
    return Venue(
      point: Point._fromJson(json['point']),
      locationId: json['locationId'],
      sublocationId: json['sublocationId'],
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      description: json['description'],
      alias: json['alias'],
      categoryId: json['categoryId'],
      // imageUrl: json['imageUrl']
    );
  }
}
