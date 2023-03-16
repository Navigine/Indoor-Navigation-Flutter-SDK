part of navigine_sdk;

class IconMapObject implements MapObject {
  static const String _methodChannelName = 'navigine_sdk/navigine_icon_map_object_';
  final MethodChannel _methodChannel;

  final int id;

  IconMapObject._({required this.id}) :
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

  Future<bool> setImage(BitmapDescriptor image) async {
    final success = await _methodChannel.invokeMethod(
      'setImage', {
        'image': image.toJson()
      });
    return success;
  }

  Future<bool> setSize(double width, double height) async {
    final success = await _methodChannel.invokeMethod(
      'setSize', {
        'width': width,
        'height': height,
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
    await _methodChannel.invokeMethod('setData', {'data': data});
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
