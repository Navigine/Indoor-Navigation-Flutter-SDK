part of navigine_sdk;

class LocationListManager {
  static const String _channelName = 'navigine_sdk/location_list_manager';

  final MethodChannel _channel;
  LocationListListener? _listener;

  LocationListManager._(this._channel) {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static LocationListManager init() {
    final methodChannel = MethodChannel(_channelName);

    return LocationListManager._(methodChannel);
  }

  void setListener(LocationListListener listener) {
    _listener = listener;
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onLocationListLoaded':
        return _onLocationListLoaded(call.arguments);
      case 'onFailed':
        return _onFailed(call.arguments);
      default:
        throw MissingPluginException();
    }
  }

  void _onLocationListLoaded(dynamic arguments) {
    if (_listener == null) {
      return;
    }

    _listener!.onLocationListLoaded!(arguments['location_list'].map<LocationInfo>((el) => LocationInfo._fromJson(el)).toList());
  }

  void _onFailed(dynamic arguments) {
    if (_listener == null) {
      return;
    }

    _listener!.onFailed!(arguments['error']);
  }
}
