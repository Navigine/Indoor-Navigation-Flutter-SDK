import Foundation
import Navigine

public class NavigineRouteSession: NSObject, NCAsyncRouteListener {
    private var id: Int
    private var session: NCRouteSession
    private let methodChannel: FlutterMethodChannel!

    private var currentRoutePath: NCRoutePath?

    public required init(
        id: Int,
        session: NCRouteSession,
        registrar: FlutterPluginRegistrar
    ) {
        self.id = id
        self.session = session

        methodChannel = FlutterMethodChannel(
            name: "navigine_sdk/navigine_route_session_\(id)",
            binaryMessenger: registrar.messenger()
        )

        super.init()
        weak var weakSelf = self
        self.methodChannel.setMethodCallHandler({ weakSelf?.handle($0, result: $1) })

        self.session.add(weakSelf)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "split":
            result(split(call))
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func split(_ call: FlutterMethodCall) -> [[String: Any?]] {
        let params = call.arguments as! [String: Any]
        let distance = params["distance"] as! NSNumber

        var paths = [[String: Any?]]()
        if currentRoutePath != nil {
            for path in currentRoutePath!.split(distance.floatValue) {
                paths.append(Utils.routePathToJson(path))
            }
        }

        return paths
    }

    public func unsubscribe() {
        self.session.remove(self)
    }


    public func getSession() -> NCRouteSession {
        return self.session
    }

    public func onRouteChanged(_ currentPath: NCRoutePath?) {
        var arguments: [String: Any?] = [:]
        if (currentPath != nil) {
             arguments = [
                "routePath": Utils.routePathToJson(currentPath!)
            ]
        }
        currentRoutePath = currentPath
        methodChannel.invokeMethod("onRouteChanged", arguments: arguments)
    }

    public func onRouteAdvanced(_ distance: Float, point: NCLocationPoint) {
        let arguments = [
            "distance": distance,
            "locationPoint": Utils.locationPointToJson(point)
        ] as [String : Any]
        methodChannel.invokeMethod("onRouteAdvanced", arguments: arguments)
    }
}
