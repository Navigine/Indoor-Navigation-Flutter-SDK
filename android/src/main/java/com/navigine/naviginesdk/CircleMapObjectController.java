package com.navigine.naviginesdk;

import android.content.Context;

import com.navigine.idl.java.CircleMapObject;
import com.navigine.idl.java.LocationWindow;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;

public class CircleMapObjectController {
  private final BinaryMessenger binaryMessenger;
  private final Context context;
  private final LocationWindow locationWindow;
  private final Map<Integer, NavigineCircleMapObject> mapObjects = new HashMap<>();

  @SuppressWarnings({"ConstantConditions", "unchecked"})
  public CircleMapObjectController(
          BinaryMessenger messenger,
          Context context,
          LocationWindow locationWindow
  ) {
    this.binaryMessenger = messenger;
    this.context = context;
    this.locationWindow = locationWindow;
  }

  public int addCircleMapObject() {
    CircleMapObject circleMapObject = locationWindow.addCircleMapObject();
    int circleMapObjectId = circleMapObject.getId();
    NavigineCircleMapObject navigineCircleMapObject = new NavigineCircleMapObject(
            circleMapObjectId,
            this.context,
            circleMapObject,
            binaryMessenger);

    mapObjects.put(circleMapObjectId, navigineCircleMapObject);
    return circleMapObjectId;
  }

  public boolean removeCircleMapObject(int id) {
    NavigineCircleMapObject navigineCircleMapObject = mapObjects.get(id);
    if (navigineCircleMapObject == null) {
      return false;
    }

    boolean success = locationWindow.removeCircleMapObject(navigineCircleMapObject.getMapObject());
    mapObjects.remove(id);
    return success;
  }


}
