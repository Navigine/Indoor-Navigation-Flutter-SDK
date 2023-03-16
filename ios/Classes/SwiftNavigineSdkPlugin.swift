import CoreLocation
import Flutter
import UIKit
import Navigine

public class SwiftNavigineSdkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        registrar.register(
            LocationViewFactory(registrar: registrar),
            withId: "navigine_sdk/navigine_map"
        )

        LocationListManager.register(with: registrar)
        LocationManager.register(with: registrar)
        NavigationManager.register(with: registrar)
        RouteManager.register(with: registrar)
    }
}
