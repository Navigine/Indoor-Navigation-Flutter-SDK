part of navigine_sdk;

class PolylineMapObject implements MapObject {
  static const String _methodChannelName = 'navigine_sdk/navigine_polyline_map_object_';
  final MethodChannel _methodChannel;

  /// Unique session identifier
  final int id;

  PolylineMapObject._({required this.id}) :
    _methodChannel = MethodChannel(_methodChannelName + id.toString())
  {}

  Future<bool> setPolyLine(LocationPolyline locationPolyline) async {
    final success = await _methodChannel.invokeMethod(
      'setPolyLine', {
        'locationPolyline': locationPolyline.toJson()
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

  Future<bool> setWidth(double width) async {
    final success = await _methodChannel.invokeMethod(
      'setWidth', {
        'width': width
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
