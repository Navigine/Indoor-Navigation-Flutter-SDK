package com.navigine.naviginesdk;

import android.content.Context;

import androidx.annotation.NonNull;

import com.navigine.idl.java.LocationInfo;
import com.navigine.idl.java.LocationListListener;
import com.navigine.idl.java.NavigineSdk;
import com.navigine.idl.java.LocationListManager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class NavigineLocationListManager implements MethodCallHandler {
  private final LocationListManager locationListManager;
  private final BinaryMessenger binaryMessenger;
  private final MethodChannel methodChannel;

  public NavigineLocationListManager(Context context, BinaryMessenger messenger) {
    locationListManager = NavigineSdk.getInstance().getLocationListManager();
    methodChannel = new MethodChannel(messenger, "navigine_sdk/location_list_manager");
    methodChannel.setMethodCallHandler(this);

    locationListManager.addLocationListListener(new LocationListListener() {
      @Override
      public void onLocationListLoaded(HashMap<Integer, LocationInfo> hashMap) {
        Map<String, Object> arguments = new HashMap<>();
        ArrayList<Map<String, Object>> locationList = new ArrayList<>();
        for (LocationInfo info : hashMap.values()) {
          locationList.add(Utils.locationInfoToJson(info));
        }
        arguments.put("location_list", locationList);

        methodChannel.invokeMethod("onLocationListLoaded", arguments);
      }

      @Override
      public void onLocationListFailed(Error error) {
        methodChannel.invokeMethod("onFailed", error.toString());
      }
    });
    binaryMessenger = messenger;
  }

  @Override
  @SuppressWarnings({"SwitchStatementWithTooFewBranches"})
  public void onMethodCall(MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "updateLocationList":
        updateLocationList();
        result.success(null);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public void updateLocationList() {
    locationListManager.updateLocationList();
  }
}
