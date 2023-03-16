part of navigine_sdk;

class LocationViewController extends ChangeNotifier {
  LocationViewController._(this._channel, this._locationViewState) {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  final MethodChannel _channel;
  final _LocationViewState _locationViewState;

  static Future<LocationViewController> _init(int id, _LocationViewState locationViewState) async {
    final methodChannel = MethodChannel('navigine_sdk/navigine_map_$id');
    await methodChannel.invokeMethod('waitForInit');

    return LocationViewController._(methodChannel, locationViewState);
  }

  Future<void> setSublocationId(int sublocationId) async {
    await _channel.invokeMethod('setSublocationId', {
      'sublocationId': sublocationId
    });
  }

  Future<void> removeAllMapObjects() async {
    await _channel.invokeMethod('removeAllMapObjects');
  }

  Future<CircleMapObject> addCircleMapObject() async {
    final dynamic result = await _channel.invokeMethod('addCircleMapObject');
    return CircleMapObject._(id: result);
  }

  Future<bool> removeCircleMapObject(CircleMapObject circleMapObject) async {
    final dynamic result = await _channel.invokeMethod('removeCircleMapObject', {
      'id': circleMapObject.id
    });

    return result;
  }

  Future<IconMapObject> addIconMapObject() async {
    final dynamic result = await _channel.invokeMethod('addIconMapObject');
    return IconMapObject._(id: result);
  }

  Future<bool> removeIconMapObject(IconMapObject iconMapObject) async {
    final dynamic result = await _channel.invokeMethod('removeIconMapObject', {
      'id': iconMapObject.id
    });

    return result;
  }

  Future<PolylineMapObject> addPolylineMapObject() async {
    final dynamic result = await _channel.invokeMethod('addPolylineMapObject');
    return PolylineMapObject._(id: result);
  }

  Future<bool> removePolylineMapObject(PolylineMapObject polylineMapObject) async {
    final dynamic result = await _channel.invokeMethod('removePolylineMapObject', {
      'id': polylineMapObject.id
    });

    return result;
  }

  Future<Point> screenPositionToMeters(Point point) async {
    final dynamic result = await _channel.invokeMethod('screenPositionToMeters', {
      'point': point.toJson()
    });
    return Point._fromJson(result);
  }

  Future<Point> metersToScreenPosition(Point point, bool clip) async {
    final dynamic result = await _channel.invokeMethod('metersToScreenPosition', {
      'point': point.toJson(),
      'clip': clip
    });
    return Point._fromJson(result);
  }

  Future<void> pickMapObjectAt(Point point) async {
    await _channel.invokeMethod('pickMapObjectAt', {
      'point': point.toJson()
    });
  }

  Future<void> pickMapFeatureAt(Point point) async {
    await _channel.invokeMethod('pickMapFeatureAt', {
      'point': point.toJson()
    });
  }

  Future<void> applyFilter(String filter, String layer) async {
    await _channel.invokeMethod('applyFilter', {
      'filter': filter,
      'layer': layer,
    });
  }

  Future<void> setMinZoomFactor(double minZoomFactor) async {
    await _channel.invokeMethod('setMinZoomFactor', {
      'minZoomFactor': minZoomFactor
    });
  }

  Future<double> getMinZoomFactor() async {
    final double minZoomFactor = await _channel.invokeMethod('getMinZoomFactor');
    return minZoomFactor;
  }

  Future<void> setMaxZoomFactor(double maxZoomFactor) async {
    await _channel.invokeMethod('setMaxZoomFactor', {
      'maxZoomFactor': maxZoomFactor
    });
  }

  Future<double> getMaxZoomFactor() async {
    final double maxZoomFactor = await _channel.invokeMethod('getMaxZoomFactor');
    return maxZoomFactor;
  }

  Future<void> setZoomFactor(double zoomFactor) async {
    await _channel.invokeMethod('setZoomFactor', {
      'zoomFactor': zoomFactor
    });
  }

  Future<double> getZoomFactor() async {
    final double zoomFactor = await _channel.invokeMethod('getZoomFactor');
    return zoomFactor;
  }

  Future<void> setCamera(Camera camera) async {
    await _channel.invokeMethod('setCamera', {
      'camera': camera.toJson()
    });
  }

  Future<Camera> getCamera() async {
    final result = await _channel.invokeMethod('getCamera');
    return Camera._fromJson(result);
  }

  Future<void> flyToCamera(Camera camera, int duration) async {
    await _channel.invokeMethod('flyToCamera', {
      'camera': camera.toJson(),
      'duration': duration
    });
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onSingleTap':
        return _onSingleTap(call.arguments);
      case 'onLongTap':
        return _onLongTap(call.arguments);
      case 'onMapObjectPick':
        return _onMapObjectPick(call.arguments);
      case 'onMapFeaturePick':
        return _onMapFeaturePick(call.arguments);
      case 'onCameraAnimation':
        return _onCameraAnimation(call.arguments);
      default:
        throw MissingPluginException();
    }
  }

  void _onSingleTap(dynamic arguments) {
    if (_locationViewState.widget.onSingleTap == null) {
      return;
    }
    _locationViewState.widget.onSingleTap!(Point._fromJson(arguments['location']));
  }

  void _onLongTap(dynamic arguments) {
    if (_locationViewState.widget.onLongTap == null) {
      return;
    }

    _locationViewState.widget.onLongTap!(Point._fromJson(arguments['location']));
  }

  void _onMapObjectPick(dynamic arguments) {
    if (_locationViewState.widget.onMapObjectPick == null) {
      return;
    }

    final mapObjectPickResult = arguments['mapObjectPickResult'];
    final mapObjectJson = mapObjectPickResult['mapObject'];
    final mapObjectId = mapObjectJson['id'];
    final type = MapObjectType.values[mapObjectJson['type']];

    MapObject? mapObject = null;

    switch (type) {
      case MapObjectType.circle:
        mapObject = CircleMapObject._(id: mapObjectId);
        break;
      case MapObjectType.icon:
        mapObject = IconMapObject._(id: mapObjectId);
        break;
      case MapObjectType.polyline:
        mapObject = PolylineMapObject._(id: mapObjectId);
        break;
    }

    _locationViewState.widget.onMapObjectPick!(
      MapObjectPickResult(
        point: LocationPoint._fromJson(mapObjectPickResult["locationPoint"]),
        mapObject: mapObject),
      Point._fromJson(arguments['screenPosition']));
  }

  void _onMapFeaturePick(dynamic arguments) {
    if (_locationViewState.widget.onMapFeaturePick == null) {
      return;
    }

    _locationViewState.widget.onMapFeaturePick!(
      arguments['mapFeaturePickResult'],
      Point._fromJson(arguments['screenPosition']));
  }

  void _onCameraAnimation(dynamic arguments) {
    if (_locationViewState.widget.onCameraAnimation == null) {
      return;
    }

    _locationViewState.widget.onCameraAnimation!(
      arguments['finished']);
  }
}
