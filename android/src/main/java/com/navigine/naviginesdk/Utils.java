package com.navigine.naviginesdk;

import android.graphics.PointF;

import com.navigine.idl.java.Beacon;
import com.navigine.idl.java.Camera;
import com.navigine.idl.java.Eddystone;
import com.navigine.idl.java.GlobalPoint;
import com.navigine.idl.java.Location;
import com.navigine.idl.java.LocationInfo;
import com.navigine.idl.java.LocationPoint;
import com.navigine.idl.java.LocationPolyline;
import com.navigine.idl.java.Point;
import com.navigine.idl.java.Polyline;
import com.navigine.idl.java.Position;
import com.navigine.idl.java.RouteEvent;
import com.navigine.idl.java.RouteOptions;
import com.navigine.idl.java.RoutePath;
import com.navigine.idl.java.Sublocation;
import com.navigine.idl.java.Venue;
import com.navigine.idl.java.Wifi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class Utils {
   @SuppressWarnings({"ConstantConditions"})
   public static Point pointFromJson(Map<String, Object> json) {
     return new Point(((Double) json.get("x")).floatValue(), ((Double) json.get("y")).floatValue());
   }

  public static PointF screenPointFromJson(Map<String, Object> json) {
    return new PointF(((Double) json.get("x")).floatValue(), ((Double) json.get("y")).floatValue());
  }

  public static Polyline polylineFromJson(Map<String, Object> json) {
    ArrayList<Point> points = new ArrayList<>();

    for (Object jsonPoint : (ArrayList<Object>)json.get("points")) {
      points.add(pointFromJson((Map<String, Object>) jsonPoint));
    }
    return new Polyline(points);
  }

   @SuppressWarnings({"ConstantConditions", "unchecked"})
   public static LocationPoint locationPointFromJson(Map<String, Object> json) {
     return new LocationPoint(
             pointFromJson((Map<String, Object>) json.get("point")),
             (Integer)json.get("locationId"),
             (Integer)json.get("sublocationId"));
   }

  public static LocationPolyline locationPolylineFromJson(Map<String, Object> json) {
    return new LocationPolyline(
            polylineFromJson((Map<String, Object>) json.get("polyline")),
            (Integer)json.get("locationId"),
            (Integer)json.get("sublocationId"));
  }

  public static Camera cameraFromJson(Map<String, Object> json) {
    return new Camera(pointFromJson((Map<String, Object>) json.get("point")), ((Double) json.get("zoom")).floatValue(), ((Double) json.get("rotation")).floatValue());
  }

  public static RouteOptions routeOptionsFromJson(Map<String, Object> json) {
    return new RouteOptions(
            (Double) json.get("smoothRadius"),
            (Double)json.get("maxProjectionDistance"),
            (Double)json.get("maxAdvance"));
  }

  public static Map<String, Object> locationInfoToJson(LocationInfo locationInfo) {
    Map<String, Object> result = new HashMap<>();
    result.put("id", locationInfo.getId());
    result.put("version", locationInfo.getVersion());
    result.put("name", locationInfo.getName());

    return result;
  }

  public static Map<String, Object> pointToJson(Point point) {
    Map<String, Object> result = new HashMap<>();
    result.put("x", point.getX());
    result.put("y", point.getY());
    return result;
  }

  public static Map<String, Object> screenPointToJson(PointF point) {
    Map<String, Object> result = new HashMap<>();
    result.put("x", point.x);
    result.put("y", point.y);
    return result;
  }

  public static Map<String, Object> locationPointToJson(LocationPoint locationPoint) {
    Map<String, Object> result = new HashMap<>();
    result.put("point", Utils.pointToJson(locationPoint.getPoint()));
    result.put("locationId", locationPoint.getLocationId());
    result.put("sublocationId", locationPoint.getSublocationId());
    return result;
  }

  public static Map<String, Object> globalPointToJson(GlobalPoint point) {
    Map<String, Object> result = new HashMap<>();
    result.put("latitude", point.getLatitude());
    result.put("longitude", point.getLongitude());
    return result;
  }

  public static Map<String, Object> cameraToJson(Camera camera) {
    Map<String, Object> result = new HashMap<>();
    result.put("point", Utils.pointToJson(camera.getPoint()));
    result.put("zoom", camera.getZoom());
    result.put("rotation", camera.getRotation());
    return result;
  }

  public static Map<String, Object> beaconToJson(Beacon beacon) {
    Map<String, Object> result = new HashMap<>();
    result.put("point", pointToJson(beacon.getPoint()));
    result.put("locationId", beacon.getLocationId());
    result.put("sublocationId", beacon.getSublocationId());
    result.put("name", beacon.getName());
    result.put("major", beacon.getMajor());
    result.put("minor", beacon.getMinor());
    result.put("uuid", beacon.getUuid());
    result.put("power", beacon.getPower());
    result.put("status", beacon.getStatus().ordinal());
    return result;
  }

  public static Map<String, Object> eddystoneToJson(Eddystone eddystone) {
    Map<String, Object> result = new HashMap<>();
    result.put("point", pointToJson(eddystone.getPoint()));
    result.put("locationId", eddystone.getLocationId());
    result.put("sublocationId", eddystone.getSublocationId());
    result.put("name", eddystone.getName());
    result.put("namespaceId", eddystone.getNamespaceId());
    result.put("instanceId", eddystone.getInstanceId());
    result.put("power", eddystone.getPower());
    result.put("status", eddystone.getStatus().ordinal());
    return result;
  }

  public static Map<String, Object> wifiToJson(Wifi wifi) {
    Map<String, Object> result = new HashMap<>();
    result.put("point", pointToJson(wifi.getPoint()));
    result.put("locationId", wifi.getLocationId());
    result.put("sublocationId", wifi.getSublocationId());
    result.put("name", wifi.getName());
    result.put("mac", wifi.getMac());
    result.put("status", wifi.getStatus().ordinal());
    return result;
  }

  public static Map<String, Object> venueToJson(Venue venue) {
    Map<String, Object> result = new HashMap<>();
    result.put("point", pointToJson(venue.getPoint()));
    result.put("locationId", venue.getLocationId());
    result.put("sublocationId", venue.getSublocationId());
    result.put("name", venue.getName());
    result.put("phone", venue.getPhone());
    result.put("description", venue.getDescript());
    result.put("alias", venue.getAlias());
    result.put("categoryId", venue.getCategoryId());
//    result.put("imageUrl", venue.getImageUrl());

    return result;
  }

  public static Map<String, Object> sublocationToJson(Sublocation sublocation) {
    Map<String, Object> result = new HashMap<>();

    ArrayList<Map<String, Object>> beacons = new ArrayList<>();
    for (Beacon beacon : sublocation.getBeacons()) {
      beacons.add(Utils.beaconToJson(beacon));
    }
    ArrayList<Map<String, Object>> eddystones = new ArrayList<>();
    for (Eddystone eddystone : sublocation.getEddystones()) {
      eddystones.add(Utils.eddystoneToJson(eddystone));
    }
    ArrayList<Map<String, Object>> wifis = new ArrayList<>();
    for (Wifi wifi : sublocation.getWifis()) {
      wifis.add(Utils.wifiToJson(wifi));
    }
    ArrayList<Map<String, Object>> venues = new ArrayList<>();
    for (Venue venue : sublocation.getVenues()) {
      venues.add(Utils.venueToJson(venue));
    }
    result.put("id", sublocation.getId());
    result.put("location", sublocation.getLocation());
    result.put("name", sublocation.getName());
    result.put("width", sublocation.getWidth());
    result.put("height", sublocation.getHeight());
    result.put("azimuth", sublocation.getAzimuth());
    result.put("originPoint", Utils.globalPointToJson(sublocation.getOriginPoint()));
    result.put("levelId", sublocation.getLevelId());
    result.put("beacons", beacons);
    result.put("eddystones", eddystones);
    result.put("wifis", wifis);
    result.put("venues", venues);

    return result;
  }

  public static Map<String, Object> locationToJson(Location location) {
    Map<String, Object> result = new HashMap<>();

    ArrayList<Map<String, Object>> sublocations = new ArrayList<>();
    for (Sublocation sublocation : location.getSublocations()) {
      sublocations.add(Utils.sublocationToJson(sublocation));
    }
    result.put("id", location.getId());
    result.put("version", location.getVersion());
    result.put("name", location.getName());
    result.put("description", location.getDescript());
    result.put("sublocations", sublocations);
    return result;
  }

  public static Map<String, Object> positionToJson(Position position) {
    Map<String, Object> result = new HashMap<>();

    Map<String, Object> locationPoint = null;
    if (position.getLocationPoint() != null) {
      locationPoint = Utils.locationPointToJson(position.getLocationPoint());
    }

    result.put("point", globalPointToJson(position.getPoint()));
    result.put("accuracy", position.getAccuracy());
    result.put("heading", position.getHeading());
    result.put("locationPoint", locationPoint);
    result.put("locationHeading", position.getLocationHeading());
    return result;
  }

  public static Map<String, Object> routeEventToJson(RouteEvent routeEvent) {
    Map<String, Object> result = new HashMap<>();
    result.put("type", routeEvent.getType().ordinal());
    result.put("value", routeEvent.getValue());
    result.put("distance", routeEvent.getDistance());
    return result;
  }

  public static Map<String, Object> routePathToJson(RoutePath routePath) {
    Map<String, Object> result = new HashMap<>();
    ArrayList<Map<String, Object>> events = new ArrayList<>();
    for (RouteEvent event : routePath.getEvents()) {
      events.add(Utils.routeEventToJson(event));
    }
    ArrayList<Map<String, Object>> points = new ArrayList<>();
    for (LocationPoint point : routePath.getPoints()) {
      points.add(Utils.locationPointToJson(point));
    }
    result.put("length", routePath.getLength());
    result.put("events", events);
    result.put("points", points);
    return result;
  }
}
