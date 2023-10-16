package com.navigine.naviginesdk;

import android.content.Context;

import com.navigine.idl.java.PolylineMapObject;
import com.navigine.idl.java.LocationWindow;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;

public class PolylineMapObjectController {
  private final BinaryMessenger binaryMessenger;
  private final Context context;
  private final LocationWindow locationWindow;
  private final Map<Integer, NaviginePolylineMapObject> mapObjects = new HashMap<>();

  @SuppressWarnings({"ConstantConditions", "unchecked"})
  public PolylineMapObjectController(
          BinaryMessenger messenger,
          Context context,
          LocationWindow locationWindow
  ) {
    this.binaryMessenger = messenger;
    this.context = context;
    this.locationWindow = locationWindow;
  }

  public int addPolylineMapObject() {
    PolylineMapObject polylineMapObject = locationWindow.addPolylineMapObject();
    int polylineMapObjectId = polylineMapObject.getId();
    NaviginePolylineMapObject naviginePolylineMapObject = new NaviginePolylineMapObject(
            polylineMapObjectId,
            this.context,
            polylineMapObject,
            binaryMessenger);

    mapObjects.put(polylineMapObjectId, naviginePolylineMapObject);
    return polylineMapObjectId;
  }

  public boolean removePolylineMapObject(int id) {
    NaviginePolylineMapObject naviginePolylineMapObject = mapObjects.get(id);
    if (naviginePolylineMapObject == null) {
      return false;
    }

    boolean success = locationWindow.removePolylineMapObject(naviginePolylineMapObject.getMapObject());
    mapObjects.remove(id);
    return success;
  }


}
