package com.navigine.naviginesdk;

import android.content.Context;
import android.graphics.PointF;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;

import com.navigine.idl.java.Camera;
import com.navigine.idl.java.MapObjectPickResult;
import com.navigine.idl.java.PickListener;
import com.navigine.idl.java.Point;
import com.navigine.view.LocationView;
import com.navigine.view.TouchInput;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class LocationViewController implements
  PlatformView,
  MethodChannel.MethodCallHandler,
  DefaultLifecycleObserver,

  // UserLocationObjectListener,
  // TrafficListener,
  // InputListener,
  // CameraListener,
  // GeoObjectTapListener,
  View.OnLayoutChangeListener
{
  private final LocationView locationView;
  public final Context context;
  public final MethodChannel methodChannel;
  private final NavigineSdkPlugin.LifecycleProvider lifecycleProvider;
  private final CircleMapObjectController circleMapObjectController;
  private final IconMapObjectController iconMapObjectController;
  private final PolylineMapObjectController polylineMapObjectController;

  // private final TrafficLayer trafficLayer;
  // private final UserLocationLayer userLocationLayer;
  // @SuppressWarnings({"UnusedDeclaration", "FieldCanBeLocal"})
  // private PlacemarkMapObjectController userPinController;
  // @SuppressWarnings({"UnusedDeclaration", "FieldCanBeLocal"})
  // private PlacemarkMapObjectController userArrowController;
  // @SuppressWarnings({"UnusedDeclaration", "FieldCanBeLocal"})
  // private CircleMapObjectController userAccuracyCircleController;
  // private final MapObjectCollectionController rootController;
  private boolean disposed = false;
  private MethodChannel.Result initResult;

  @SuppressWarnings({"unchecked", "ConstantConditions", "InflateParams"})
  public LocationViewController(
    int id,
    Context context,
    BinaryMessenger messenger,
    Map<String, Object> params,
    NavigineSdkPlugin.LifecycleProvider lifecycleProvider
  ) {
    this.lifecycleProvider = lifecycleProvider;
    this.context = context;

    if (context instanceof FlutterActivity) {
      locationView = (LocationView) ((FlutterActivity) context).getLayoutInflater().inflate(R.layout.location_view, null);
    } else if (context instanceof FlutterFragmentActivity) {
      locationView = (LocationView) ((FlutterFragmentActivity) context).getLayoutInflater().inflate(R.layout.location_view, null);
    } else {
      locationView = new LocationView(context);
    }

    circleMapObjectController = new CircleMapObjectController(messenger, context, locationView.getLocationViewController());
    iconMapObjectController = new IconMapObjectController(messenger, context, locationView.getLocationViewController());
    polylineMapObjectController = new PolylineMapObjectController(messenger, context, locationView.getLocationViewController());

    methodChannel = new MethodChannel(messenger, "navigine_sdk/navigine_map_" + id);
    methodChannel.setMethodCallHandler(this);

    locationView.addOnLayoutChangeListener(this);

    locationView.getLocationViewController().getTouchInput().setTapResponder(new TouchInput.TapResponder() {
      @Override
      public boolean onSingleTapUp(float v, float v1) {
        return false;
      }

      @Override
      public boolean onSingleTapConfirmed(float x, float y) {
        Map<String, Object> arguments = new HashMap<>();
        arguments.put("location", Utils.screenPointToJson(new PointF(x, y)));

        methodChannel.invokeMethod("onSingleTap", arguments);
        return false;
      }
    });

    locationView.getLocationViewController().getTouchInput().setLongPressResponder((x, y) -> {
      Map<String, Object> arguments = new HashMap<>();
      arguments.put("location", Utils.screenPointToJson(new PointF(x, y)));

      methodChannel.invokeMethod("onLongTap", arguments);
    });

    locationView.getLocationViewController().setPickListener(new PickListener() {
      @Override
      public void onMapObjectPickComplete(MapObjectPickResult mapObjectPickResult, PointF screenPosition) {
        if (mapObjectPickResult == null) {
          return;
        }
        Map<String, Object> arguments = new HashMap<>();

        Map<String, Object> mapObject = new HashMap<>();
        mapObject.put("type", mapObjectPickResult.getMapObject().getType().ordinal());
        mapObject.put("id", mapObjectPickResult.getMapObject().getId());

        Map<String, Object> pickResult = new HashMap<>();
        pickResult.put("locationPoint", Utils.locationPointToJson(mapObjectPickResult.getPoint()));
        pickResult.put("mapObject", mapObject);

        arguments.put("mapObjectPickResult", pickResult);
        arguments.put("screenPosition", Utils.screenPointToJson(screenPosition));

        methodChannel.invokeMethod("onMapObjectPick", arguments);
      }

      @Override
      public void onMapFeaturePickComplete(HashMap<String, String> mapFeaturePickResult, PointF screenPosition) {
        if (mapFeaturePickResult == null) {
          return;
        }

        Map<String, Object> arguments = new HashMap<>();

        arguments.put("mapFeaturePickResult", mapFeaturePickResult);
        arguments.put("screenPosition", Utils.screenPointToJson(screenPosition));

        methodChannel.invokeMethod("onMapFeaturePick", arguments);
      }
    });

    lifecycleProvider.getLifecycle().addObserver(this);
  }

  @Override
  public View getView() {
    return locationView;
  }

  @Override
  public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
    switch (call.method) {
      case "waitForInit":
        if (locationView.getWidth() == 0 || locationView.getHeight() == 0) {
          initResult = result;
        } else {
          result.success(null);
        }
        break;
      case "setSublocationId":
        setSublocationId(call);
        result.success(null);
        break;
      case "removeAllMapObjects":
        removeAllMapObjects();
        result.success(null);
        break;
      case "addCircleMapObject":
        result.success(addCircleMapObject(call));
        break;
      case "removeCircleMapObject":
        result.success(removeCircleMapObject(call));
        break;
      case "addIconMapObject":
        result.success(addIconMapObject(call));
        break;
      case "removeIconMapObject":
        result.success(removeIconMapObject(call));
        break;
      case "addPolylineMapObject":
        result.success(addPolylineMapObject(call));
        break;
      case "removePolylineMapObject":
        result.success(removePolylineMapObject(call));
        break;
      case "screenPositionToMeters":
        result.success(screenPositionToMeters(call));
        break;
      case "metersToScreenPosition":
        result.success(metersToScreenPosition(call));
        break;
      case "pickMapObjectAt":
        pickMapObjectAt(call);
        result.success(null);
        break;
      case "pickMapFeatureAt":
        pickMapFeatureAt(call);
        result.success(null);
        break;
      case "applyFilter":
        applyFilter(call);
        result.success(null);
        break;
      case "setMinZoomFactor":
        setMinZoomFactor(call);
        result.success(null);
        break;
      case "getMinZoomFactor":
        result.success(getMinZoomFactor(call));
        break;
      case "setMaxZoomFactor":
        setMaxZoomFactor(call);
        result.success(null);
        break;
      case "getMaxZoomFactor":
        result.success(getMaxZoomFactor(call));
        break;
      case "setZoomFactor":
        setZoomFactor(call);
        result.success(null);
        break;
      case "getZoomFactor":
        result.success(getZoomFactor(call));
        break;
      case "setCamera":
        setCamera(call);
        result.success(null);
        break;
      case "getCamera":
        result.success(getCamera(call));
        break;
      case "flyToCamera":
        flyToCamera(call);
        result.success(null);
        break;

      default:
        result.notImplemented();
        break;
    }
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public void setSublocationId(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);

    locationView.getLocationViewController().setSublocationId((Integer) params.get("sublocationId"));
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public void removeAllMapObjects() {
    locationView.getLocationViewController().removeAllMapObjects();
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public int addCircleMapObject(MethodCall call) {
    return this.circleMapObjectController.addCircleMapObject();
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public boolean removeCircleMapObject(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);
    return this.circleMapObjectController.removeCircleMapObject((Integer) params.get("id"));
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public int addIconMapObject(MethodCall call) {
    return this.iconMapObjectController.addIconMapObject();
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public boolean removeIconMapObject(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);
    return this.iconMapObjectController.removeIconMapObject((Integer) params.get("id"));
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public int addPolylineMapObject(MethodCall call) {
    return this.polylineMapObjectController.addPolylineMapObject();
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public boolean removePolylineMapObject(MethodCall call) {
    Map<String, Object> params = ((Map<String, Object>) call.arguments);
    return this.polylineMapObjectController.removePolylineMapObject((Integer) params.get("id"));
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public Map<String, Object> screenPositionToMeters(MethodCall call) {
    Map<String, Object> params = (Map<String, Object>) call.arguments;

    PointF screenPoint = Utils.screenPointFromJson((Map<String, Object>) params.get("point"));
    return Utils.pointToJson(locationView.getLocationViewController().screenPositionToMeters(screenPoint));
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public Map<String, Object> metersToScreenPosition(MethodCall call) {
    Map<String, Object> params = (Map<String, Object>) call.arguments;

    Point point = Utils.pointFromJson((Map<String, Object>) params.get("point"));

    Boolean clip = (Boolean)params.get("clip");
    return Utils.screenPointToJson(locationView.getLocationViewController().metersToScreenPosition(point, clip));
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public void pickMapObjectAt(MethodCall call) {
    Map<String, Object> params = (Map<String, Object>) call.arguments;

    PointF point = Utils.screenPointFromJson((Map<String, Object>) params.get("point"));

    locationView.getLocationViewController().pickMapObjectAt(point.x, point.y);
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public void pickMapFeatureAt(MethodCall call) {
    Map<String, Object> params = (Map<String, Object>) call.arguments;

    PointF point = Utils.screenPointFromJson((Map<String, Object>) params.get("point"));

    locationView.getLocationViewController().pickMapFeaturetAt(point.x, point.y);
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public void applyFilter(MethodCall call) {
    Map<String, Object> params = (Map<String, Object>) call.arguments;
    locationView.getLocationViewController().applyFilter(
            (String) params.get("filter"),
            (String) params.get("layer"));
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public void setMinZoomFactor(MethodCall call) {
    Map<String, Object> params = (Map<String, Object>) call.arguments;
    Double minZoomFactor = (Double) params.get("minZoomFactor");
    locationView.getLocationViewController().setMinZoomFactor(minZoomFactor.floatValue());
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public float getMinZoomFactor(MethodCall call) {
    return locationView.getLocationViewController().getMinZoomFactor();
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public void setMaxZoomFactor(MethodCall call) {
    Map<String, Object> params = (Map<String, Object>) call.arguments;
    Double maxZoomFactor = (Double) params.get("maxZoomFactor");
    locationView.getLocationViewController().setMaxZoomFactor(maxZoomFactor.floatValue());
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public float getMaxZoomFactor(MethodCall call) {
    return locationView.getLocationViewController().getMaxZoomFactor();
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public void setZoomFactor(MethodCall call) {
    Map<String, Object> params = (Map<String, Object>) call.arguments;
    Double zoomFactor = (Double) params.get("zoomFactor");
    locationView.getLocationViewController().setZoomFactor(zoomFactor.floatValue());
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public float getZoomFactor(MethodCall call) {
    return locationView.getLocationViewController().getZoomFactor();
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public void setCamera(MethodCall call) {
    Map<String, Object> params = (Map<String, Object>) call.arguments;
    locationView.getLocationViewController().setCamera(Utils.cameraFromJson((Map<String, Object>) params.get("camera")));
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public Map<String, Object> getCamera(MethodCall call) {
    return Utils.cameraToJson(locationView.getLocationViewController().getCamera());
  }

  @SuppressWarnings({"unchecked", "ConstantConditions"})
  public void flyToCamera(MethodCall call) {
    Map<String, Object> params = (Map<String, Object>) call.arguments;
    Camera camera = Utils.cameraFromJson((Map<String, Object>) params.get("camera"));
    Integer duration = (Integer) params.get("duration");
    locationView.getLocationViewController().flyToCamera(camera, duration * 1000, new com.navigine.view.LocationViewController.CameraAnimationCallback() {
      @Override
      public void onFinish() {

      }

      @Override
      public void onCancel() {

      }
    });
  }

  @Override
  public void dispose() {
    if (disposed) {
      return;
    }

    disposed = true;
    methodChannel.setMethodCallHandler(null);

    Lifecycle lifecycle = lifecycleProvider.getLifecycle();
    if (lifecycle != null) {
      lifecycle.removeObserver(this);
    }
  }

  @Override
  public void onCreate(@NonNull LifecycleOwner owner) {}

  @Override
  public void onStart(@NonNull LifecycleOwner owner) {
    if (disposed) {
      return;
    }
  }

  @Override
  public void onResume(@NonNull LifecycleOwner owner) {}

  @Override
  public void onPause(@NonNull LifecycleOwner owner) {}

  @Override
  public void onStop(@NonNull LifecycleOwner owner) {
    if (disposed) {
      return;
    }
  }

  @Override
  public void onDestroy(@NonNull LifecycleOwner owner) {
    owner.getLifecycle().removeObserver(this);
  }

  @Override
  public void onLayoutChange(View view, int i, int i1, int i2, int i3, int i4, int i5, int i6, int i7) {
    if (initResult != null) {
      initResult.success(null);
      initResult = null;
    }
  }
}
