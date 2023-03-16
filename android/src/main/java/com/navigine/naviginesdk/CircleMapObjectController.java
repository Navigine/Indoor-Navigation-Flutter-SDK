package com.navigine.naviginesdk;

import android.content.Context;

import com.navigine.idl.java.CircleMapObject;
import com.navigine.view.LocationViewController;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;

public class CircleMapObjectController {
  private final BinaryMessenger binaryMessenger;
  private final Context context;
  private final LocationViewController controller;
  private final Map<Integer, NavigineCircleMapObject> mapObjects = new HashMap<>();

  @SuppressWarnings({"ConstantConditions", "unchecked"})
  public CircleMapObjectController(
          BinaryMessenger messenger,
          Context context,
          LocationViewController controller
  ) {
    this.binaryMessenger = messenger;
    this.context = context;
    this.controller = controller;
  }

  public int addCircleMapObject() {
    CircleMapObject circleMapObject = controller.addCircleMapObject();
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

    boolean success = controller.removeCircleMapObject(navigineCircleMapObject.getMapObject());
    mapObjects.remove(id);
    return success;
  }


}
