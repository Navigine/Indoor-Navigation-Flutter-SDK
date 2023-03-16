part of navigine_sdk;

class NavigationManager {
  static const String _channelName = 'navigine_sdk/navigation_manager';

  final MethodChannel _channel;
  PositionListener? _listener;

  NavigationManager._(this._channel) {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static NavigationManager init() {
    final methodChannel = MethodChannel(_channelName);

    return NavigationManager._(methodChannel);
  }

  Future<void> startLogRecording() async {
    await _channel.invokeMethod('startLogRecording');
  }

  Future<void> stopLogRecording() async {
    await _channel.invokeMethod('stopLogRecording');
  }

  Future<void> addCheckPoint(LocationPoint locationPoint) async {
    await _channel.invokeMethod('addCheckPoint', {'locationPoint': locationPoint.toJson()});
  }

  void setListener(PositionListener listener) {
    _listener = listener;
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onPositionUpdated':
        return _onPositionUpdated(call.arguments);
      case 'onFailed':
        return _onFailed(call.arguments);
      default:
        throw MissingPluginException();
    }
  }

  void _onPositionUpdated(dynamic arguments) {
    if (_listener == null) {
      return;
    }

    _listener!.onPositionUpdated!(Position._fromJson(arguments['position']));
  }

  void _onFailed(dynamic arguments) {
    if (_listener == null) {
      return;
    }

    _listener!.onFailed!(arguments['error']);
  }
}
