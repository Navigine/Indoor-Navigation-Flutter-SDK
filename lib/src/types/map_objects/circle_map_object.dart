part of navigine_sdk;

class CircleMapObject implements MapObject {
  static const String _methodChannelName = 'navigine_sdk/navigine_circle_map_object_';
  final MethodChannel _methodChannel;

  /// Unique session identifier
  final int id;

  CircleMapObject._({required this.id}) :
    _methodChannel = MethodChannel(_methodChannelName + id.toString())
  {}

  Future<bool> setPosition(LocationPoint locationPoint) async {
    final success = await _methodChannel.invokeMethod(
      'setPosition', {
        'locationPoint': locationPoint.toJson()
      });
    return success;
  }

  Future<bool> setPositionAnimated(LocationPoint locationPoint, double duration, AnimationType type) async {
    final success = await _methodChannel.invokeMethod(
      'setPositionAnimated', {
        'locationPoint': locationPoint.toJson(),
        'duration' : duration,
        'type' : type.index
      });
    return success;
  }

  Future<bool> setColor(double red, double green, double blue, double alpha) async {
    final success = await _methodChannel.invokeMethod(
      'setColor', {
        'red': red,
        'green': green,
        'blue': blue,
        'alpha': alpha
      });
    return success;
  }

  Future<bool> setRadius(double radius) async {
    final success = await _methodChannel.invokeMethod(
      'setRadius', {
        'radius': radius
      });
    return success;
  }

  @override
  Future<MapObjectType> getType() async {
    final type = await _methodChannel.invokeMethod('getType');

    return MapObjectType.values[type];
  }

  @override
  Future<bool> setVisible(bool visible) async {
    final success = await _methodChannel.invokeMethod(
      'setVisible', {
        'visible': visible
      });

    return success;
  }

  @override
  Future<bool> setInteractive(bool interactive) async {
    final success = await _methodChannel.invokeMethod(
      'setInteractive', {
        'interactive': interactive
      });

    return success;
  }

  @override
  Future<bool> setStyle(String style) async {
    final success = await _methodChannel.invokeMethod(
      'setStyle', {
        'style': style
      });

    return success;
  }

  @override
  Future<void> setData(Uint8List data) async {
    await _methodChannel.invokeMethod(
      'setData', {
        'data': data
      });
  }

  @override
  Future<Uint8List> getData() async {
    final data = await _methodChannel.invokeMethod('getData');
    return data;
  }

  @override
  Future<bool> setTitle(String title) async {
    final success = await _methodChannel.invokeMethod(
      'setTitle', {
        'title': title
      });

    return success;
  }
}
