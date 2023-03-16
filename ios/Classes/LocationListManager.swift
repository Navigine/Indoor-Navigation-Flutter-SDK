import CoreLocation
import Flutter
import UIKit
import Navigine


public class LocationListManager: NSObject, FlutterPlugin, NCLocationListListener {

    private let pluginRegistrar: FlutterPluginRegistrar!
    private let methodChannel: FlutterMethodChannel!
    private let locationListManager: NCLocationListManager!

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "navigine_sdk/location_list_manager",
            binaryMessenger: registrar.messenger()
        )

        let plugin = LocationListManager(channel: channel, registrar: registrar)

        registrar.addMethodCallDelegate(plugin, channel: channel)
    }

    public required init(channel: FlutterMethodChannel, registrar: FlutterPluginRegistrar) {
        self.pluginRegistrar = registrar
        self.methodChannel = channel
        self.locationListManager = NCNavigineSdk.getInstance()!.getLocationListManager()

        super.init()

        self.locationListManager.add(self)

        self.methodChannel.setMethodCallHandler(self.handle)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "updateLocationList":
            updateLocationList()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func updateLocationList() {
        self.locationListManager.updateLocationList()
    }

    public func onLocationListLoaded(_ locationInfos: [NSNumber : NCLocationInfo]) {
        var infos = [[String: Any?]]()
        for (_, info) in locationInfos {
            infos.append(Utils.locationInfoToJson(info))
        }
        let arguments: [String: Any?] = [
            "location_list": infos
        ]
        methodChannel.invokeMethod("onLocationListLoaded", arguments: arguments)
    }

    public func onLocationListFailed(_ error: Error?) {
        methodChannel.invokeMethod("onFailed", arguments: error.debugDescription)
    }
}
