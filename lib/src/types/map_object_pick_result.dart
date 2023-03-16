part of navigine_sdk;

class MapObjectPickResult extends Equatable {
  const MapObjectPickResult({
    required this.point,
    required this.mapObject,
  });

  final LocationPoint point;
  final MapObject mapObject;

  @override
  List<Object?> get props => <Object?>[
    point,
    mapObject
  ];
}
