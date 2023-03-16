import Flutter
import UIKit
import Navigine

public class RouteManager: NSObject, FlutterPlugin {
    private let pluginRegistrar: FlutterPluginRegistrar!
    private let methodChannel: FlutterMethodChannel!
    private let locationManager: NCLocationManager!
    private let navigationManager: NCNavigationManager!
    private let asyncRouteManager: NCAsyncRouteManager!
    private var routeSessions: [Int: NavigineRouteSession] = [:]

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "navigine_sdk/route_manager",
            binaryMessenger: registrar.messenger()
        )

        let plugin = RouteManager(channel: channel, registrar: registrar)

        registrar.addMethodCallDelegate(plugin, channel: channel)
    }

    public required init(channel: FlutterMethodChannel, registrar: FlutterPluginRegistrar) {
        self.pluginRegistrar = registrar
        self.methodChannel = channel
        self.locationManager = NCNavigineSdk.getInstance()!.getLocationManager()
        self.navigationManager = NCNavigineSdk.getInstance()!.getNavigationManager(self.locationManager)
        self.asyncRouteManager = NCNavigineSdk.getInstance()!.getAsyncRouteManager(self.locationManager, navigationManager: self.navigationManager)

        super.init()

        self.methodChannel.setMethodCallHandler(self.handle)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "createRouteSession":
            createRouteSession(call)
            result(nil)
        case "cancelRouteSession":
            cancelRouteSession(call)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func createRouteSession(_ call: FlutterMethodCall) {
        let params = call.arguments as! [String: Any]
        let sessionId = params["sessionId"] as! Int
        let locationPoint = Utils.locationPointFromJson(params["locationPoint"] as! [String : Any])
        let smoothRadius = params["smoothRadius"] as! NSNumber

        let session = self.asyncRouteManager.createRouteSession(locationPoint, smoothRadius: smoothRadius.floatValue)

        routeSessions[sessionId] = NavigineRouteSession(
          id: sessionId,
          session: session!,
          registrar: pluginRegistrar
        )
    }

    public func cancelRouteSession(_ call: FlutterMethodCall) {
        let params = call.arguments as! [String: Any]
        let sessionId = params["sessionId"] as! Int
        let routeSession = routeSessions[sessionId]
        if (routeSession != nil) {
            self.asyncRouteManager.cancel(routeSession?.getSession())
            routeSessions.removeValue(forKey: sessionId)
        }
    }
}
