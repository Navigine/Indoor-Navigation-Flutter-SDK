package com.navigine.naviginesdk;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.navigine.idl.java.NavigineSdk;
import com.navigine.idl.java.LocationManager;
import com.navigine.idl.java.NavigationManager;
import com.navigine.idl.java.Position;
import com.navigine.idl.java.PositionListener;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class NavigineNavigationManager implements MethodCallHandler {
  private final LocationManager locationManager;
  private final NavigationManager navigationManager;
  private final BinaryMessenger binaryMessenger;
  private final MethodChannel methodChannel;

  public NavigineNavigationManager(Context context, BinaryMessenger messenger) {
    locationManager = NavigineSdk.getInstance().getLocationManager();
    navigationManager = NavigineSdk.getInstance().getNavigationManager(locationManager);

    binaryMessenger = messenger;
    methodChannel = new MethodChannel(messenger, "navigine_sdk/navigation_manager");
    methodChannel.setMethodCallHandler(this);

    navigationManager.addPositionListener(new PositionListener() {
      @Override
      public void onPositionUpdated(Position position) {
        Map<String, Object> arguments = new HashMap<>();
        if (position != null) {
          arguments.put("position", Utils.positionToJson(position));
        }
        methodChannel.invokeMethod("onPositionUpdated", arguments);
      }

      @Override
      public void onPositionError(Error error) {
        methodChannel.invokeMethod("onFailed", error.toString());
      }
    });
  }

  @Override
  @SuppressWarnings({"SwitchStatementWithTooFewBranches"})
  public void onMethodCall(MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "startLogRecording":
        startLogRecording(call);
        result.success(null);
        break;
      case "stopLogRecording":
        stopLogRecording(call);
        result.success(null);
        break;
      case "addCheckPoint":
        addCheckPoint(call);
        result.success(null);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public void startLogRecording(MethodCall call) {
    navigationManager.startLogRecording();
  }

  public void stopLogRecording(MethodCall call) {
    navigationManager.stopLogRecording();
  }

  public void addCheckPoint(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);
    navigationManager.addCheckPoint(Utils.locationPointFromJson((Map<String, Object>) params.get("locationPoint")));
  }

}
