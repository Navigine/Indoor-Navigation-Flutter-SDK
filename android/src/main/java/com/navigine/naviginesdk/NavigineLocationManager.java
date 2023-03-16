package com.navigine.naviginesdk;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.navigine.idl.java.Location;
import com.navigine.idl.java.LocationInfo;
import com.navigine.idl.java.LocationListener;
import com.navigine.idl.java.NavigineSdk;
import com.navigine.idl.java.LocationManager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class NavigineLocationManager implements MethodCallHandler {
  private final LocationManager locationManager;
  private final BinaryMessenger binaryMessenger;
  private final MethodChannel methodChannel;

  public NavigineLocationManager(Context context, BinaryMessenger messenger) {
    locationManager = NavigineSdk.getInstance().getLocationManager();

    binaryMessenger = messenger;
    methodChannel = new MethodChannel(messenger, "navigine_sdk/location_manager");
    methodChannel.setMethodCallHandler(this);

    locationManager.addLocationListener(new LocationListener() {
      @Override
      public void onLocationLoaded(Location location) {
        Map<String, Object> arguments = new HashMap<>();
        if (location != null) {
          arguments.put("location", Utils.locationToJson(location));
        }
        methodChannel.invokeMethod("onLocationLoaded", arguments);
      }

      @Override
      public void onLocationFailed(int i, Error error) {
        methodChannel.invokeMethod("onFailed", error.toString());
      }

      @Override
      public void onLocationUploaded(int i) {

      }
    });
  }

  @Override
  @SuppressWarnings({"SwitchStatementWithTooFewBranches"})
  public void onMethodCall(MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "setLocationId":
        setLocationId(call);
        result.success(null);
        break;
      case "getLocationId":
        result.success(getLocationId(call));
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public void setLocationId(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);

    locationManager.setLocationId((Integer) params.get("locationId"));
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public int getLocationId(MethodCall call) {
    return locationManager.getLocationId();
  }
}
