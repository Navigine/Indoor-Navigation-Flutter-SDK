package com.navigine.naviginesdk;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.navigine.idl.java.AsyncRouteManager;
import com.navigine.idl.java.LocationPoint;
import com.navigine.idl.java.NavigineSdk;
import com.navigine.idl.java.LocationManager;
import com.navigine.idl.java.NavigationManager;
import com.navigine.idl.java.Position;
import com.navigine.idl.java.PositionListener;
import com.navigine.idl.java.RouteManager;
import com.navigine.idl.java.RouteOptions;
import com.navigine.idl.java.RoutePath;
import com.navigine.idl.java.RouteSession;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class NavigineRouteManager implements MethodCallHandler {
  private final LocationManager locationManager;
  private final NavigationManager navigationManager;
  private final AsyncRouteManager asyncRouteManager;
  private final RouteManager routeManager;
  private final BinaryMessenger binaryMessenger;
  private final MethodChannel methodChannel;
  @SuppressWarnings({"MismatchedQueryAndUpdateOfCollection"})
  private final Map<Integer, NavigineRouteSession> routeSessions = new HashMap<>();

  public NavigineRouteManager(Context context, BinaryMessenger messenger) {
    locationManager = NavigineSdk.getInstance().getLocationManager();
    navigationManager = NavigineSdk.getInstance().getNavigationManager(locationManager);
    asyncRouteManager = NavigineSdk.getInstance().getAsyncRouteManager(locationManager, navigationManager);
    routeManager = NavigineSdk.getInstance().getRouteManager(locationManager, navigationManager);

    binaryMessenger = messenger;
    methodChannel = new MethodChannel(messenger, "navigine_sdk/route_manager");
    methodChannel.setMethodCallHandler(this);
  }

  @Override
  @SuppressWarnings({"SwitchStatementWithTooFewBranches"})
  public void onMethodCall(MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "makeRoute":
        result.success(makeRoute(call));
        break;
      case "createRouteSession":
        createRouteSession(call);
        result.success(null);
        break;
      case "cancelRouteSession":
        cancelRouteSession(call);
        result.success(null);
        break;
      default:
        result.notImplemented();
        break;
    }
  }
  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public Map<String, Object> makeRoute(MethodCall call) {
    Map<String, Object> params = (Map<String, Object>) call.arguments;
    LocationPoint from = Utils.locationPointFromJson((Map<String, Object>) params.get("from"));
    LocationPoint to = Utils.locationPointFromJson((Map<String, Object>) params.get("to"));
    RoutePath path = routeManager.makeRoute(from, to);
    if (path == null) {
      return null;
    }
    return Utils.routePathToJson(path);
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public void createRouteSession(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);
    Integer sessionId = (Integer) params.get("sessionId");
    LocationPoint locationPoint = Utils.locationPointFromJson((Map<String, Object>) params.get("locationPoint"));
    RouteOptions routeOptions = Utils.routeOptionsFromJson((Map<String, Object>) params.get("routeOptions"));

    RouteSession session = asyncRouteManager.createRouteSession(locationPoint, routeOptions);

    NavigineRouteSession routeSession = new NavigineRouteSession(
      sessionId,
      session,
      binaryMessenger);

    routeSessions.put(sessionId, routeSession);
  }

  public void cancelRouteSession(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);
    Integer sessionId = (Integer) params.get("sessionId");

    NavigineRouteSession routeSession = routeSessions.get(sessionId);
    if (routeSession != null) {
      asyncRouteManager.cancelRouteSession(routeSession.getSession());
      routeSessions.remove(sessionId);
    }
  }
}
