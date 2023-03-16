package com.navigine.naviginesdk;

import android.content.Context;

import androidx.annotation.NonNull;

import com.navigine.idl.java.AnimationType;
import com.navigine.idl.java.CircleMapObject;
import com.navigine.idl.java.LocationPoint;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class NavigineCircleMapObject implements MethodChannel.MethodCallHandler {
  private final int id;
  private final Context context;
  private final CircleMapObject mapObject;
  private final MethodChannel methodChannel;

  public NavigineCircleMapObject (
    int id,
    Context context,
    CircleMapObject mapObject,
    BinaryMessenger messenger
  ) {
    this.id = id;
    this.mapObject = mapObject;
    this.context = context;

    methodChannel = new MethodChannel(messenger, "navigine_sdk/navigine_circle_map_object_" + id);
    methodChannel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    switch (call.method) {
      case "setPosition":
        result.success(setPosition(call));
        break;
      case "setPositionAnimated":
        result.success(setPositionAnimated(call));
        break;
      case "setColor":
        result.success(setColor(call));
        break;
      case "setRadius":
        result.success(setRadius(call));
        break;
      case "getType":
        result.success(getType(call));
        break;
      case "setVisible":
        result.success(setVisible(call));
        break;
      case "setInteractive":
        result.success(setInteractive(call));
        break;
      case "setStyle":
        result.success(setStyle(call));
        break;
      case "setData":
        setData(call);
        result.success(null);
        break;
      case "getData":
        result.success(getData(call));
        break;
      case "setTitle":
        result.success(setTitle(call));
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  public CircleMapObject getMapObject() {
    return mapObject;
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public boolean setPosition(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);
    return mapObject.setPosition(Utils.locationPointFromJson((Map<String, Object>) params.get("locationPoint")));
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public boolean setPositionAnimated(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);
    LocationPoint locationPoint = Utils.locationPointFromJson((Map<String, Object>) params.get("locationPoint"));
    float duration = ((Double) params.get("duration")).floatValue();
    int type = ((Integer) params.get("type"));
    return mapObject.setPositionAnimated(locationPoint, duration, AnimationType.values()[type]);
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public boolean setColor(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);

    Double red = (Double) params.get("red");
    Double green = (Double) params.get("green");
    Double blue = (Double) params.get("blue");
    Double alpha = (Double) params.get("alpha");
    return mapObject.setColor(red.floatValue(), green.floatValue(), blue.floatValue(), alpha.floatValue());
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public boolean setRadius(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);

    Double radius = (Double) params.get("radius");
    return mapObject.setRadius(radius.floatValue());
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public int getType(MethodCall call) {
    return mapObject.getType().ordinal();
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public boolean setVisible(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);

    Boolean visible = (Boolean) params.get("visible");
    return mapObject.setVisible(visible);
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public boolean setInteractive(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);

    Boolean interactive = (Boolean) params.get("interactive");
    return mapObject.setInteractive(interactive);
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public boolean setStyle(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);

    String style = (String) params.get("style");
    return mapObject.setStyle(style);
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public void setData(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);

    byte[] data = (byte[]) params.get("style");
    mapObject.setData(data);
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public byte[] getData(MethodCall call) {
    return mapObject.getData();
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public boolean setTitle(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);

    String title = (String) params.get("title");
    return mapObject.setTitle(title);
  }
}
