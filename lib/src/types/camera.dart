part of navigine_sdk;

class Camera extends Equatable {
  const Camera({
    required this.point,
    required this.zoom,
    required this.rotation
  });

  final Point point;
  final double zoom;
  final double rotation;

  @override
  List<Object?> get props => <Object?>[
    point,
    zoom,
    rotation
  ];

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return {
      'point': point.toJson(),
      'zoom': zoom,
      'rotation': rotation
    };
  }

  factory Camera._fromJson(Map<dynamic, dynamic> json) {
    return Camera(
      point: Point._fromJson(json['point']),
      zoom: json['zoom'],
      rotation: json['rotation']
    );
  }
}
