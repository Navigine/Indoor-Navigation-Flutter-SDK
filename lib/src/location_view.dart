part of navigine_sdk;

typedef MapCreatedCallback = void Function(LocationViewController controller);

/// Android specific settings for [LocationView].
class AndroidLocationView {
  /// Whether to render [LocationView] with a [AndroidViewSurface] to build the Google Maps widget.
  ///
  /// This implementation uses hybrid composition to render the LocationView Widget on Android.
  /// This comes at the cost of some performance on Android versions below 10.
  /// See https://flutter.dev/docs/development/platform-integration/platform-views#performance for more information.
  ///
  /// Defaults to true.
  static bool useAndroidViewSurface = true;
}

/// A widget which displays a location view using Navigine CMS.
class LocationView extends StatefulWidget {
  /// A `Widget` for displaying Navigine Location View
  const LocationView({
    Key? key,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.zoomGesturesEnabled = true,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.onMapCreated,
    this.onTap,
    this.onDoubleTap,
    this.onLongTap,
    this.onMapObjectPick,
    this.onMapFeaturePick,
    this.onCameraAnimation,
  }) : super(key: key);

  static const String _viewType = 'navigine_sdk/navigine_map';

  /// Which gestures should be consumed by the map.
  ///
  /// When this set is empty, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  /// Enable rotation gestures, such as rotation with two fingers.
  final bool zoomGesturesEnabled;

  /// Enable rotation gestures, such as rotation with two fingers.
  final bool rotateGesturesEnabled;

  /// Enable scroll gestures, such as the pan gesture.
  final bool scrollGesturesEnabled;

  /// Callback method for when the map is ready to be used.
  ///
  /// Pass to [LocationView.onMapCreated] to receive a [LocationViewController] when the
  /// map is created.
  final MapCreatedCallback? onMapCreated;

  final OnMapObjectPick? onMapObjectPick;

  final OnMapFeaturePick? onMapFeaturePick;

  /// Called every time a [LocationView] is tapped.
  final ArgumentCallback<Point>? onTap;

    /// Called every time a [LocationView] is double tapped.
  final ArgumentCallback<Point>? onDoubleTap;

  /// Called every time a [LocationView] is long tapped.
  final ArgumentCallback<Point>? onLongTap;

  final CameraAnimationCallback? onCameraAnimation;


  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  late _LocationViewOptions _locationViewOptions;

  final Completer<LocationViewController> _controller = Completer<LocationViewController>();

  @override
  void initState() {
    super.initState();
    _locationViewOptions = _LocationViewOptions.fromWidget(widget);
  }

  @override
  void dispose() async {
    super.dispose();
    final controller = await _controller.future;

    controller.dispose();
  }

  @override
  void didUpdateWidget(LocationView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (AndroidLocationView.useAndroidViewSurface) {
        return PlatformViewLink(
          viewType: LocationView._viewType,
          surfaceFactory: (BuildContext context, PlatformViewController controller) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: widget.gestureRecognizers,
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            return PlatformViewsService.initExpensiveAndroidView(
              id: params.id,
              viewType: LocationView._viewType,
              layoutDirection: TextDirection.ltr,
              creationParams: _creationParams(),
              creationParamsCodec: StandardMessageCodec(),
              onFocus: () => params.onFocusChanged(true),
            )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..addOnPlatformViewCreatedListener(_onPlatformViewCreated)
            ..create();
          }
        );
      } else {
        return AndroidView(
          viewType: LocationView._viewType,
          onPlatformViewCreated: _onPlatformViewCreated,
          gestureRecognizers: widget.gestureRecognizers,
          creationParamsCodec: StandardMessageCodec(),
          creationParams: _creationParams(),
        );
      }
    } else {
      return UiKitView(
        viewType: LocationView._viewType,
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: widget.gestureRecognizers,
        creationParamsCodec: StandardMessageCodec(),
        creationParams: _creationParams(),
      );
    }
  }

  Future<void> _onPlatformViewCreated(int id) async {
    final controller = await LocationViewController._init(id, this);

    _controller.complete(controller);

    if (widget.onMapCreated != null) {
      widget.onMapCreated!(controller);
    }
  }

  Map<String, dynamic> _creationParams() {
    final mapOptions = _locationViewOptions.toJson();

    return {
      'mapOptions': mapOptions
    };
  }
}

/// Configuration options for the LocationView native view.
class _LocationViewOptions {
  _LocationViewOptions.fromWidget(LocationView map) :
    zoomGesturesEnabled = map.zoomGesturesEnabled,
    rotateGesturesEnabled = map.rotateGesturesEnabled,
    scrollGesturesEnabled = map.scrollGesturesEnabled;

  final bool zoomGesturesEnabled;
  final bool rotateGesturesEnabled;
  final bool scrollGesturesEnabled;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'zoomGesturesEnabled': zoomGesturesEnabled,
      'rotateGesturesEnabled': rotateGesturesEnabled,
      'scrollGesturesEnabled': scrollGesturesEnabled,
    };
  }

  Map<String, dynamic> mapUpdates(_LocationViewOptions newOptions) {
    final prevOptionsMap = toJson();

    return newOptions.toJson()..removeWhere((String key, dynamic value) => prevOptionsMap[key] == value);
  }
}
