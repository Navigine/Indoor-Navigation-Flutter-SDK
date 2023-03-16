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
  private final BinaryMessenger binaryMessenger;
  private final MethodChannel methodChannel;
  @SuppressWarnings({"MismatchedQueryAndUpdateOfCollection"})
  private final Map<Integer, NavigineRouteSession> routeSessions = new HashMap<>();

  public NavigineRouteManager(Context context, BinaryMessenger messenger) {
    locationManager = NavigineSdk.getInstance().getLocationManager();
    navigationManager = NavigineSdk.getInstance().getNavigationManager(locationManager);
    asyncRouteManager = NavigineSdk.getInstance().getAsyncRouteManager(locationManager, navigationManager);

    binaryMessenger = messenger;
    methodChannel = new MethodChannel(messenger, "navigine_sdk/route_manager");
    methodChannel.setMethodCallHandler(this);
  }

  @Override
  @SuppressWarnings({"SwitchStatementWithTooFewBranches"})
  public void onMethodCall(MethodCall call, @NonNull Result result) {
    switch (call.method) {
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
  public void createRouteSession(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);
    Integer sessionId = (Integer) params.get("sessionId");
    LocationPoint locationPoint = Utils.locationPointFromJson((Map<String, Object>) params.get("locationPoint"));
    Double smoothRadius = (Double)params.get("smoothRadius");
    RouteSession session = asyncRouteManager.createRouteSession(locationPoint, smoothRadius.floatValue());

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
