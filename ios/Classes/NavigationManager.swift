import Flutter
import UIKit
import Navigine


public class NavigationManager: NSObject, FlutterPlugin, NCPositionListener {
    private let pluginRegistrar: FlutterPluginRegistrar!
    private let methodChannel: FlutterMethodChannel!
    private let locationManager: NCLocationManager!
    private let navigationManager: NCNavigationManager!

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "navigine_sdk/navigation_manager",
            binaryMessenger: registrar.messenger()
        )

        let plugin = NavigationManager(channel: channel, registrar: registrar)

        registrar.addMethodCallDelegate(plugin, channel: channel)
    }

    public required init(channel: FlutterMethodChannel, registrar: FlutterPluginRegistrar) {
        self.pluginRegistrar = registrar
        self.methodChannel = channel
        self.locationManager = NCNavigineSdk.getInstance()!.getLocationManager()
        self.navigationManager = NCNavigineSdk.getInstance()!.getNavigationManager(self.locationManager)

        super.init()

        self.navigationManager.add(self)

        self.methodChannel.setMethodCallHandler(self.handle)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startLogRecording":
            startLogRecording(call)
            result(nil)
        case "stopLogRecording":
            stopLogRecording(call)
            result(nil)
        case "addCheckPoint":
            addCheckPoint(call)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func startLogRecording(_ call: FlutterMethodCall) {
        self.navigationManager.startLogRecording()
    }

    public func stopLogRecording(_ call: FlutterMethodCall) {
        return self.navigationManager.stopLogRecording()
    }

    public func addCheckPoint(_ call: FlutterMethodCall) {
        let params = call.arguments as! [String: Any]
        self.navigationManager.addCheck(Utils.locationPointFromJson(params["locationPoint"] as! [String : Any]))
    }

    public func onPositionUpdated(_ position: NCPosition) {
        let arguments = [
            "position": Utils.positionToJson(position)
        ]
        methodChannel.invokeMethod("onPositionUpdated", arguments: arguments)
    }

    public func onPositionError(_ error: Error?) {
        methodChannel.invokeMethod("onFailed", arguments: error.debugDescription)
    }
}
