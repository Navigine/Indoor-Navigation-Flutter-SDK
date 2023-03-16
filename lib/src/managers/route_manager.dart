part of navigine_sdk;

class RouteManager {
  static const String _channelName = 'navigine_sdk/route_manager';

  final MethodChannel _channel;
  static int _nextSessionId = 0;

  RouteManager._(this._channel);

  static RouteManager init() {
    final methodChannel = MethodChannel(_channelName);

    return RouteManager._(methodChannel);
  }

  RouteSession createRouteSession(LocationPoint locationPoint, double smoothRadius) {
    int sessionId = _nextSessionId++;
    _channel.invokeMethod(
      'createRouteSession', {
        'locationPoint' : locationPoint.toJson(),
        'smoothRadius' : smoothRadius,
        'sessionId' : sessionId});

    return RouteSession._(id: sessionId);
  }

  Future<void> cancelRouteSession(RouteSession routeSession) async {
    await _channel.invokeMethod('cancelRouteSession', {'sessionId' : routeSession.id});
  }
}
