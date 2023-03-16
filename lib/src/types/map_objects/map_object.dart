part of navigine_sdk;

enum MapObjectType {
  icon,
  polyline,
  circle
}

/// A common interface for maps types.
abstract class MapObject<T> {
  Future<MapObjectType> getType();

  Future<bool> setVisible(bool visible);
  Future<bool> setInteractive(bool interactive);
  Future<bool> setStyle(String style);
  Future<void> setData(Uint8List data);
  Future<Uint8List> getData();

  Future<bool> setTitle(String title);
}
