import CoreLocation
import Flutter
import UIKit
import Navigine


public class LocationManager: NSObject, FlutterPlugin, NCLocationListener {

    private let pluginRegistrar: FlutterPluginRegistrar!
    private let methodChannel: FlutterMethodChannel!
    private let locationManager: NCLocationManager!

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "navigine_sdk/location_manager",
            binaryMessenger: registrar.messenger()
        )

        let plugin = LocationManager(channel: channel, registrar: registrar)

        registrar.addMethodCallDelegate(plugin, channel: channel)
    }

    public required init(channel: FlutterMethodChannel, registrar: FlutterPluginRegistrar) {
        self.pluginRegistrar = registrar
        self.methodChannel = channel
        self.locationManager = NCNavigineSdk.getInstance()!.getLocationManager()

        super.init()

        self.locationManager.add(self)

        self.methodChannel.setMethodCallHandler(self.handle)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setLocationId":
            setLocationId(call)
            result(nil)
        case "getLocationId":
            result(getLocationId(call))
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func setLocationId(_ call: FlutterMethodCall) {
        let params = call.arguments as! [String: Any]
        self.locationManager.setLocationId(params["locationId"] as! Int32)
    }

    public func getLocationId(_ call: FlutterMethodCall) -> Int32 {
        return self.locationManager.getLocationId()
    }

    public func onLocationLoaded(_ location: NCLocation?) {
        var arguments: [String: Any?] = [:]
        if (location != nil) {
             arguments = [
                "location": Utils.locationToJson(location!)
            ]
        }
        methodChannel.invokeMethod("onLocationLoaded", arguments: arguments)
    }

    public func onDownloadProgress(_ locationId: Int32, received: Int32, total: Int32) {}

    public func onLocationFailed(_ locationId: Int32, error: Error?) {
        methodChannel.invokeMethod("onFailed", arguments: error.debugDescription)
    }

    public func onLocationCancelled(_ locationId: Int32) {}

    public func onLocationUploaded(_ locationId: Int32) {}
}
