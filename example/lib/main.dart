import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:navigine_sdk/navigine_sdk.dart';

void main() {
  runApp(MaterialApp(home: MainPage()));
}

int LOCATION_ID = 0; // Put here your location id
int SUBLOCATION_ID = 0;  // Put here your sublocation id

class MainPage extends StatelessWidget with WidgetsBindingObserver {
  Future<bool> get locationPermissionNotGranted async => !(await Permission.location.request().isGranted);
  Future<bool> get bluetoothscanPermissionNotGranted async => !(await Permission.bluetoothScan.request().isGranted);
  Future<bool> get bluetoothPermissionNotGranted async => !(await Permission.bluetoothConnect.request().isGranted);

  void _showMessage(BuildContext context, Text text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: text));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.removeObserver(this);
    var locationManager = LocationManager.init();
    locationManager.setListener(LocationListener(
      onLocationLoaded: (location) {
        print(location);
      },
    ));

    var locationListManager = LocationListManager.init();
    locationListManager.setListener(LocationListListener(
      onLocationListLoaded: (locationInfos) {
        print(locationInfos);
      },
    ));

    PolylineMapObject? polylineMapObject;
    IconMapObject? iconMapObject;

    var navigationManager = NavigationManager.init();
    navigationManager.setListener(PositionListener(
      onPositionUpdated: (position) {
        if (position != null && position.locationPoint != null) {
          iconMapObject?.setPosition(position.locationPoint!);
        }
      },
    ));

    navigationManager.startLogRecording();
    navigationManager.addCheckPoint(LocationPoint(point: Point(x: 1.0, y: 2.0), locationId: LOCATION_ID, sublocationId: SUBLOCATION_ID));
    navigationManager.stopLogRecording();

    var routeManager = RouteManager.init();

    RouteSession? routeSession;

    var path = routeManager.makeRoute(
    LocationPoint(point: Point(x: 100.0, y: 200.0), locationId: LOCATION_ID, sublocationId: SUBLOCATION_ID),
    LocationPoint(point: Point(x: 110.0, y: 210.0), locationId: LOCATION_ID, sublocationId: SUBLOCATION_ID));

    LocationViewController? viewController;

    return Scaffold(
      appBar: AppBar(title: const Text('Navigine flutter example')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: LocationView(
                onMapCreated: (LocationViewController locationViewController) async {
                  viewController = locationViewController;
                  if (await locationPermissionNotGranted) {
                    _showMessage(context, Text('Location permission was NOT granted'));
                  }

                  if (await bluetoothscanPermissionNotGranted) {
                    _showMessage(context, Text('Bluetooth scan permission was NOT granted'));
                  }

                  if (await bluetoothPermissionNotGranted) {
                    _showMessage(context, Text('Bluetooth permission was NOT granted'));
                  }

                  await locationManager.setLocationId(LOCATION_ID);
                  // final locationId = await locationManager.getLocationId();
                  await viewController?.setSublocationId(SUBLOCATION_ID);

                  iconMapObject = await viewController?.addIconMapObject();
                  await iconMapObject?.setImage(BitmapDescriptor.fromAssetImage('lib/assets/place.png'));
                  await iconMapObject?.setSize(40.0, 40.0);
                  await iconMapObject?.setStyle("{order: 1, collide: false}");

                  final minZoomFactor = await viewController?.getMinZoomFactor();
                  await viewController?.setMinZoomFactor(minZoomFactor! / 2);

                  final maxZoomFactor = await viewController?.getMaxZoomFactor();
                  await viewController?.setMaxZoomFactor(maxZoomFactor! * 2);

                  final zoomFactor = await viewController?.getZoomFactor();
                  await viewController?.setZoomFactor(zoomFactor! + 2);

                  polylineMapObject = await viewController?.addPolylineMapObject();
                  await polylineMapObject?.setColor(0, 160 / 255, 0, 1);
                  await polylineMapObject?.setWidth(2);
                  await polylineMapObject?.setStyle("{order: 1, collide: false}");
                },
                onMapObjectPick: (mapObjectPickResult, screenPosition) {
                  print('onMapObjectPick');
                  print(mapObjectPickResult);
                  print(screenPosition);
                },
                onMapFeaturePick: (mapFeaturePickResult, screenPosition) {
                  print('onMapFeaturePick');
                  print(mapFeaturePickResult);
                  print(screenPosition);
                },
                onLongTap: (Point point) async {
                  print('onLongTap');
                  print(point);
                  final pointMeters = await viewController?.screenPositionToMeters(point);
                  final screenMeters = await viewController?.metersToScreenPosition(pointMeters!, false);
                  await viewController?.flyToCamera(Camera(point: pointMeters!, zoom: 11, rotation: 0), 2);

                  var routeSession = routeManager.createRouteSession(
                    LocationPoint(point: pointMeters!, locationId: LOCATION_ID, sublocationId: SUBLOCATION_ID),
                    RouteOptions(smoothRadius: 0.3, maxProjectionDistance: 10.0, maxAdvance: 5.0));

                  routeSession.setListener(RouteListener(
                    onRouteAdvanced: (distance, point) async {
                      print('onRouteAdvanced');
                      print(distance);
                      print(point);

                      if (routeSession != null) {
                        final routes = await routeSession.split(distance);
                        if (routes.length < 2) {
                          return;
                        }

                        final route = routes[1];

                        late List<Point> points = [];
                        for (final locationPoint in route.points) {
                          points.add(locationPoint.point);
                        }

                        final locationPolyline = LocationPolyline(polyline: Polyline(points: points), locationId: LOCATION_ID, sublocationId: SUBLOCATION_ID);

                        await polylineMapObject?.setPolyLine(locationPolyline);
                      }
                    },
                    onRouteChanged: (currentPath) {
                      print('onRouteChanged');
                      print(currentPath);
                  }));
                },
                onTap: (Point point) {
                  print('onTap');
                  print(point);
                  viewController?.pickMapObjectAt(point);
                  viewController?.pickMapFeatureAt(point);
                },
                onDoubleTap: (Point point) {
                  print('onDoubleTap');
                  print(point);
                },
                onCameraAnimation: (finished) {
                  print(finished);
                },
              )
            )
          )
        ]
      )
    );
  }
}
