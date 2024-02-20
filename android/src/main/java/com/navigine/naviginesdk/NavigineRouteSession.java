package com.navigine.naviginesdk;

import androidx.annotation.NonNull;

import com.navigine.idl.java.AsyncRouteListener;
import com.navigine.idl.java.LocationPoint;
import com.navigine.idl.java.RoutePath;
import com.navigine.idl.java.RouteSession;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class NavigineRouteSession implements MethodChannel.MethodCallHandler {
  private final int id;
  private final RouteSession session;
  private final MethodChannel methodChannel;

  private RoutePath currentRoutePath = null;
  private AsyncRouteListener asyncRouteListener = null;

  public NavigineRouteSession(
    int id,
    RouteSession session,
    BinaryMessenger messenger
  ) {
    this.id = id;
    this.session = session;

    methodChannel = new MethodChannel(messenger, "navigine_sdk/navigine_route_session_" + id);
    methodChannel.setMethodCallHandler(this);

    asyncRouteListener = new AsyncRouteListener() {
      @Override
      public void onRouteChanged(RoutePath routePath) {
        Map<String, Object> arguments = new HashMap<>();
        if (routePath != null) {
          arguments.put("routePath", Utils.routePathToJson(routePath));
        }
        currentRoutePath = routePath;
        methodChannel.invokeMethod("onRouteChanged", arguments);
      }

      @Override
      public void onRouteAdvanced(float v, LocationPoint locationPoint) {
        Map<String, Object> arguments = new HashMap<>();
        arguments.put("distance", v);
        arguments.put("locationPoint", Utils.locationPointToJson(locationPoint));
        methodChannel.invokeMethod("onRouteAdvanced", arguments);
      }
    };

    this.session.addRouteListener(asyncRouteListener);
  }

  public RouteSession getSession() {
    return this.session;
  }

  public void unsubscribe() {
    this.session.removeRouteListener(asyncRouteListener);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    switch (call.method) {

      case "split":
        result.success(split(call));
        break;

      default:
        result.notImplemented();
        break;
    }
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public ArrayList<Map<String, Object>> split(MethodCall call) {
    Map<String, Object> params = (Map<String, Object>) call.arguments;
    Double distance = (Double) params.get("distance");

    ArrayList<Map<String, Object>> paths = new ArrayList<>();
    if (currentRoutePath != null) {
      for (RoutePath path : currentRoutePath.split(distance.floatValue())) {
        paths.add(Utils.routePathToJson(path));
      }
    }

    return paths;
  }
}
