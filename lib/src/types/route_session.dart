part of navigine_sdk;

class RouteSession {
  static const String _methodChannelName = 'navigine_sdk/navigine_route_session_';
  final MethodChannel _methodChannel;
  RouteListener? _listener;

  /// Unique session identifier
  final int id;

  RouteSession._({required this.id}) :
    _methodChannel = MethodChannel(_methodChannelName + id.toString())
  {
    _methodChannel.setMethodCallHandler(_handleMethodCall);
  }

  void setListener(RouteListener listener) {
    _listener = listener;
  }

  Future<List<RoutePath>> split(double distance) async {
    final json = await _methodChannel.invokeMethod('split', {
      'distance': distance,
    });
    return json.map<RoutePath>((el) => RoutePath._fromJson(el)).toList();
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onRouteChanged':
        return _onRouteChanged(call.arguments);
      case 'onRouteAdvanced':
        return _onRouteAdvanced(call.arguments);
      default:
        throw MissingPluginException();
    }
  }

  void _onRouteChanged(dynamic arguments) {
    if (_listener == null) {
      return;
    }

    _listener!.onRouteChanged!(RoutePath._fromJson(arguments['routePath']));
  }

  void _onRouteAdvanced(dynamic arguments) {
    if (_listener == null) {
      return;
    }

    _listener!.onRouteAdvanced!(arguments['distance'], LocationPoint._fromJson(arguments['locationPoint']));
  }
}