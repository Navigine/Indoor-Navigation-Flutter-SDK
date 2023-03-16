package com.navigine.naviginesdk;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import androidx.annotation.NonNull;

import com.navigine.idl.java.AnimationType;
import com.navigine.idl.java.IconMapObject;
import com.navigine.idl.java.LocationPoint;

import java.io.InputStream;
import java.util.Map;

import io.flutter.FlutterInjector;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class NavigineIconMapObject implements MethodChannel.MethodCallHandler {
  private final int id;
  private final Context context;
  private final IconMapObject mapObject;
  private final MethodChannel methodChannel;

  public NavigineIconMapObject (
    int id,
    Context context,
    IconMapObject mapObject,
    BinaryMessenger messenger
  ) {
    this.id = id;
    this.mapObject = mapObject;
    this.context = context;

    methodChannel = new MethodChannel(messenger, "navigine_sdk/navigine_icon_map_object_" + id);
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
      case "setImage":
        result.success(setImage(call));
        break;
      case "setSize":
        result.success(setSize(call));
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

  public IconMapObject getMapObject() {
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
  public boolean setImage(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);

    Map<String, Object> image = (Map<String, Object>) params.get("image");
    return mapObject.setBitmap(getIconImage(image));
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public boolean setSize(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);

    Double width = (Double) params.get("width");
    Double height = (Double) params.get("height");
    return mapObject.setSize(width.floatValue(), height.floatValue());
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

  @SuppressWarnings({"ConstantConditions"})
  private Bitmap getIconImage(Map<String, Object> image) {
    String type = (String) image.get("type");
    Bitmap defaultImage = Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888);

    if (type.equals("fromAssetImage")) {
      String assetName = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset((String) image.get("assetName"));

      try (InputStream i = this.context.getAssets().open(assetName)) {
        return BitmapFactory.decodeStream(i);

      } catch (java.io.IOException e) {
        return defaultImage;
      }
    }

    if (type.equals("fromBytes")) {
      byte[] rawImageData = (byte[]) image.get("rawImageData");
      Bitmap bitmap = BitmapFactory.decodeByteArray(rawImageData, 0, rawImageData.length);

      if (bitmap != null) {
        return bitmap;
      }

      return defaultImage;
    }

    return defaultImage;
  }
}
