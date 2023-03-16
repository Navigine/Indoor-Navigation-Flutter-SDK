part of navigine_sdk;

typedef OnLocationListLoadedCallback = void Function(List<LocationInfo> locationInfos);
typedef OnFailedCallback = void Function(String error);

class LocationListListener {
    const LocationListListener({this.onLocationListLoaded, this.onFailed});
    final OnLocationListLoadedCallback? onLocationListLoaded;
    final OnFailedCallback? onFailed;
}

typedef OnLocationLoadedCallback = void Function(Location location);

class LocationListener {
    const LocationListener({this.onLocationLoaded, this.onFailed});
    final OnLocationLoadedCallback? onLocationLoaded;
    final OnFailedCallback? onFailed;
}

typedef OnPositionUpdatedCallback = void Function(Position location);

class PositionListener {
    const PositionListener({this.onPositionUpdated, this.onFailed});
    final OnPositionUpdatedCallback? onPositionUpdated;
    final OnFailedCallback? onFailed;
}

typedef OnRouteChangedCallback = void Function(RoutePath currentPath);
typedef OnRouteAdvancedCallback = void Function(double distance, LocationPoint point);

class RouteListener {
    const RouteListener({this.onRouteChanged, this.onRouteAdvanced});
    final OnRouteChangedCallback? onRouteChanged;
    final OnRouteAdvancedCallback? onRouteAdvanced;
}

typedef ArgumentCallback<T> = void Function(T argument);

typedef OnMapObjectPick = void Function(MapObjectPickResult mapObjectPickResult, Point screenPosition);
typedef OnMapFeaturePick = void Function(Map<String, String> mapFeaturePickResult, Point screenPosition);

typedef CameraAnimationCallback = void Function(bool finished);