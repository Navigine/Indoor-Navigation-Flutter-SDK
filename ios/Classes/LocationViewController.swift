import CoreLocation
import Flutter
import UIKit
import Navigine

public class LocationViewController:
    NSObject,
    FlutterPlatformView,
    NCPickListener,
    NCGestureRecognizerDelegate
{
    public let methodChannel: FlutterMethodChannel!
    public let pluginRegistrar: FlutterPluginRegistrar!

    private let locationView: FLNCLocationView
    private let circleMapObjectController: CircleMapObjectController
    private let iconMapObjectController: IconMapObjectController
    private let polylineMapObjectController: PolylineMapObjectController

    public required init(id: Int64, frame: CGRect, registrar: FlutterPluginRegistrar, params: [String: Any]) {
        self.pluginRegistrar = registrar
        self.locationView = FLNCLocationView(frame: frame)
        self.methodChannel = FlutterMethodChannel(
            name: "navigine_sdk/navigine_map_\(id)",
            binaryMessenger: registrar.messenger()
        )
        self.circleMapObjectController = CircleMapObjectController(registrar: pluginRegistrar, locationView: locationView)
        self.iconMapObjectController = IconMapObjectController(registrar: pluginRegistrar, locationView: locationView)
        self.polylineMapObjectController = PolylineMapObjectController(registrar: pluginRegistrar, locationView: locationView)

        super.init()

        weak var weakSelf = self
        self.methodChannel.setMethodCallHandler({ weakSelf?.handle($0, result: $1) })

        self.locationView.pickListener = self
        self.locationView.gestureDelegate = self
    }

    public func view() -> UIView {
        return self.locationView
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "waitForInit":
            if (locationView.frame.isEmpty) {
                locationView.initResult = result
            } else {
                result(nil)
            }
        case "setSublocationId":
            setSublocationId(call)
            result(nil)
        case "removeAllMapObjects":
            removeAllMapObjects(call)
            result(nil)
        case "addCircleMapObject":
            result(addCircleMapObject(call))
        case "removeCircleMapObject":
            result(removeCircleMapObject(call))
        case "addIconMapObject":
            result(addIconMapObject(call))
        case "removeIconMapObject":
            result(removeIconMapObject(call))
        case "addPolylineMapObject":
            result(addPolylineMapObject(call))
        case "removePolylineMapObject":
            result(removePolylineMapObject(call))
        case "screenPositionToMeters":
            result(screenPositionToMeters(call))
        case "metersToScreenPosition":
            result(metersToScreenPosition(call))
        case "pickMapObjectAt":
            pickMapObjectAt(call)
            result(nil)
        case "pickMapFeatureAt":
            pickMapFeatureAt(call)
            result(nil)
        case "applyFilter":
            applyFilter(call)
            result(nil)
        case "setMinZoomFactor":
            setMinZoomFactor(call)
            result(nil)
        case "getMinZoomFactor":
            result(getMinZoomFactor(call))
        case "setMaxZoomFactor":
            setMaxZoomFactor(call)
            result(nil)
        case "getMaxZoomFactor":
            result(getMaxZoomFactor(call))
        case "setZoomFactor":
            setZoomFactor(call)
            result(nil)
        case "getZoomFactor":
            result(getZoomFactor(call))
        case "setCamera":
            setCamera(call)
            result(nil)
        case "getCamera":
            result(getCamera(call))
        case "flyToCamera":
            flyToCamera(call)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func setSublocationId(_ call: FlutterMethodCall) {
        let params = call.arguments as! [String: Any]

        locationView.setSublocationId(params["sublocationId"] as! Int32)
    }

    public func removeAllMapObjects(_ call: FlutterMethodCall) {
        locationView.removeAllMapObjects()
    }

    public func addCircleMapObject(_ call: FlutterMethodCall) -> Int32? {
        return self.circleMapObjectController.addCircleMapObject()
    }

    public func removeCircleMapObject(_ call: FlutterMethodCall) -> Bool? {
        let params = call.arguments as! [String: Any]
        return self.circleMapObjectController.removeCircleMapObject(id: params["id"] as! Int32)
    }

    public func addIconMapObject(_ call: FlutterMethodCall) -> Int32? {
        return self.iconMapObjectController.addIconMapObject()
    }

    public func removeIconMapObject(_ call: FlutterMethodCall) -> Bool? {
        let params = call.arguments as! [String: Any]
        return self.iconMapObjectController.removeIconMapObject(id: params["id"] as! Int32)
    }

    public func addPolylineMapObject(_ call: FlutterMethodCall) -> Int32? {
        return self.polylineMapObjectController.addPolylineMapObject()
    }

    public func removePolylineMapObject(_ call: FlutterMethodCall) -> Bool? {
        let params = call.arguments as! [String: Any]
        return self.polylineMapObjectController.removePolylineMapObject(id: params["id"] as! Int32)
    }

    public func screenPositionToMeters(_ call: FlutterMethodCall) -> [String: Any?] {
        let params = call.arguments as! [String: Any]
        let screenPoint = Utils.screenPointFromJson(params["point"] as! [String: NSNumber])
        return Utils.pointToJson(locationView.screenPosition(toMeters: screenPoint))
    }

    public func metersToScreenPosition(_ call: FlutterMethodCall) -> [String: Any?] {
        let params = call.arguments as! [String: Any]

        let point = Utils.pointFromJson(params["point"] as! [String: NSNumber])
        let clip = params["clip"] as! Bool
        return Utils.screenPointToJson(locationView.meters(toScreenPosition: point, clipToViewport: clip))
    }

    public func pickMapObjectAt(_ call: FlutterMethodCall) {
        let params = call.arguments as! [String: Any]
        locationView.pickMapObject(at: Utils.screenPointFromJson(params["point"] as! [String: NSNumber]))
    }

    public func pickMapFeatureAt(_ call: FlutterMethodCall) {
        let params = call.arguments as! [String: Any]
        locationView.pickMapFeature(at: Utils.screenPointFromJson(params["point"] as! [String: NSNumber]))
    }

    public func applyFilter(_ call: FlutterMethodCall) {
        let params = call.arguments as! [String: Any]
        locationView.applyFilter(params["filter"] as! String, layer: params["layer"] as! String)
    }

    public func setMinZoomFactor(_ call: FlutterMethodCall) {
        let params = call.arguments as! [String: Any]
        let minZoomFactor = params["minZoomFactor"] as! Double
        locationView.minZoomFactor = minZoomFactor
    }

    public func getMinZoomFactor(_ call: FlutterMethodCall) -> Float {
        return Float(locationView.minZoomFactor)
    }

    public func setMaxZoomFactor(_ call: FlutterMethodCall) {
        let params = call.arguments as! [String: Any]
        let maxZoomFactor = params["maxZoomFactor"] as! Double
        locationView.maxZoomFactor = maxZoomFactor
    }

    public func getMaxZoomFactor(_ call: FlutterMethodCall) -> Float {
        return Float(locationView.maxZoomFactor)
    }

    public func setZoomFactor(_ call: FlutterMethodCall) {
        let params = call.arguments as! [String: Any]
        let zoomFactor = params["zoomFactor"] as! Double
        locationView.zoomFactor = zoomFactor
    }

    public func getZoomFactor(_ call: FlutterMethodCall) -> Float {
        return Float(locationView.zoomFactor)
    }

    public func setCamera(_ call: FlutterMethodCall) {
        let params = call.arguments as! [String: Any]
        locationView.camera = Utils.cameraFromJson(params["camera"] as! [String: Any])
    }

    public func getCamera(_ call: FlutterMethodCall) -> [String: Any?] {
        return Utils.cameraToJson(locationView.camera)
    }

    public func flyToCamera(_ call: FlutterMethodCall) {
        let params = call.arguments as! [String: Any]
        let camera = Utils.cameraFromJson(params["camera"] as! [String: Any])
        let duration = params["duration"] as! NSNumber
        locationView.fly(to: camera, withDuration: duration.doubleValue) { finished in
            let arguments: [String: Bool] = [
                "finished": finished
            ]
            self.methodChannel.invokeMethod("onCameraAnimation", arguments: arguments)
        }
    }

    private func hasLocationPermission() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                return false
            }
        } else {
            return false
        }
    }

    public func onMapObjectPickComplete(_ mapObjectPickResult: NCMapObjectPickResult?, screenPosition: CGPoint) {
        if mapObjectPickResult == nil {
            return
        }

        let arguments: [String: Any?] = [
            "mapObjectPickResult": [
                "locationPoint": Utils.locationPointToJson(mapObjectPickResult!.point),
                "mapObject": [
                    "id": mapObjectPickResult!.mapObject?.getId() as Any,
                    "type": mapObjectPickResult!.mapObject?.getType().rawValue
                ]
            ],
            "screenPosition" : Utils.screenPointToJson(screenPosition)
        ]

        methodChannel.invokeMethod("onMapObjectPick", arguments: arguments)
    }

    public func onMapFeaturePickComplete(_ mapFeaturePickResult: [String : String], screenPosition: CGPoint) {
        let arguments: [String: Any?] = [
            "mapFeaturePickResult": mapFeaturePickResult,
            "screenPosition" : Utils.screenPointToJson(screenPosition)
        ]

        methodChannel.invokeMethod("onMapFeaturePick", arguments: arguments)
    }

    public func locationView(_ view: NCLocationView!, recognizer: UIGestureRecognizer!, didRecognizeSingleTapGesture location: CGPoint) {
        let arguments: [String: Any?] = [
            "location": Utils.screenPointToJson(location)
        ]
        methodChannel.invokeMethod("onSingleTap", arguments: arguments)
    }

    public func locationView(_ view: NCLocationView!, recognizer: UIGestureRecognizer!, didRecognizePanGesture displacement: CGPoint) {

    }

    public func locationView(_ view: NCLocationView!, recognizer: UIGestureRecognizer!, didRecognizePinchGesture location: CGPoint) {

    }

    public func locationView(_ view: NCLocationView!, recognizer: UIGestureRecognizer!, didRecognizeLongPressGesture location: CGPoint) {
        let arguments: [String: Any?] = [
            "location": Utils.screenPointToJson(location)
        ]
        methodChannel.invokeMethod("onLongTap", arguments: arguments)
    }

    // Fix https://github.com/flutter/flutter/issues/67514
    internal class FLNCLocationView: NCLocationView {
        public var initResult: FlutterResult?

        override var frame: CGRect {
            didSet {
                if initResult != nil {
                    initResult!(nil)
                    initResult = nil
                }
            }
        }
    }
}
