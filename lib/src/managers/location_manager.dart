part of navigine_sdk;

class LocationManager {
  static const String _channelName = 'navigine_sdk/location_manager';

  final MethodChannel _channel;
  LocationListener? _listener;

  LocationManager._(this._channel) {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static LocationManager init() {
    final methodChannel = MethodChannel(_channelName);

    return LocationManager._(methodChannel);
  }

  Future<void> setLocationId(int locationId) async {
    await _channel.invokeMethod('setLocationId', {'locationId': locationId});
  }

  Future<int> getLocationId() async {
    final int locationId = await _channel.invokeMethod('getLocationId');

    return locationId;
  }

  void setListener(LocationListener listener) {
    _listener = listener;
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onLocationLoaded':
        return _onLocationLoaded(call.arguments);
      case 'onFailed':
        return _onFailed(call.arguments);
      default:
        throw MissingPluginException();
    }
  }

  void _onLocationLoaded(dynamic arguments) {
    if (_listener == null) {
      return;
    }

    _listener!.onLocationLoaded!(Location._fromJson(arguments['location']));
  }

  void _onFailed(dynamic arguments) {
    if (_listener == null) {
      return;
    }

    _listener!.onFailed!(arguments['error']);
  }
}
