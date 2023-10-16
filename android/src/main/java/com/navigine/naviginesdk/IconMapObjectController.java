package com.navigine.naviginesdk;

import android.content.Context;

import com.navigine.idl.java.IconMapObject;
import com.navigine.idl.java.LocationWindow;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;

public class IconMapObjectController {
  private final BinaryMessenger binaryMessenger;
  private final Context context;
  private final LocationWindow locationWindow;
  private final Map<Integer, NavigineIconMapObject> mapObjects = new HashMap<>();

  @SuppressWarnings({"ConstantConditions", "unchecked"})
  public IconMapObjectController(
          BinaryMessenger messenger,
          Context context,
          LocationWindow locationWindow
  ) {
    this.binaryMessenger = messenger;
    this.context = context;
    this.locationWindow = locationWindow;
  }

  public int addIconMapObject() {
    IconMapObject iconMapObject = locationWindow.addIconMapObject();
    int iconMapObjectId = iconMapObject.getId();
    NavigineIconMapObject navigineIconMapObject = new NavigineIconMapObject(
            iconMapObjectId,
            this.context,
            iconMapObject,
            binaryMessenger);

    mapObjects.put(iconMapObjectId, navigineIconMapObject);
    return iconMapObjectId;
  }

  public boolean removeIconMapObject(int id) {
    NavigineIconMapObject iconMapObject = mapObjects.get(id);
    if (iconMapObject == null) {
      return false;
    }

    boolean success = locationWindow.removeIconMapObject(iconMapObject.getMapObject());
    mapObjects.remove(id);
    return success;
  }


}
