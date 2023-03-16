package com.navigine.naviginesdk;

import android.content.Context;

import androidx.annotation.NonNull;

import com.navigine.idl.java.PolylineMapObject;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class NaviginePolylineMapObject implements MethodChannel.MethodCallHandler {
  private final int id;
  private final Context context;
  private final PolylineMapObject mapObject;
  private final MethodChannel methodChannel;

  public NaviginePolylineMapObject (
    int id,
    Context context,
    PolylineMapObject mapObject,
    BinaryMessenger messenger
  ) {
    this.id = id;
    this.mapObject = mapObject;
    this.context = context;

    methodChannel = new MethodChannel(messenger, "navigine_sdk/navigine_polyline_map_object_" + id);
    methodChannel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    switch (call.method) {
      case "setPolyLine":
        result.success(setPolyLine(call));
        break;
      case "setWidth":
        result.success(setWidth(call));
        break;
      case "setColor":
        result.success(setColor(call));
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

  public PolylineMapObject getMapObject() {
    return mapObject;
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public boolean setPolyLine(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);
    return mapObject.setPolyLine(Utils.locationPolylineFromJson((Map<String, Object>) params.get("locationPolyline")));
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
  public boolean setWidth(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);

    Double width = (Double) params.get("width");
    return mapObject.setWidth(width.floatValue());
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
