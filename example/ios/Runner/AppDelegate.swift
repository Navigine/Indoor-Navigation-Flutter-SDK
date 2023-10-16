import UIKit
import Flutter
import Navigine

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var sdk: NCNavigineSdk? = nil
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    sdk = NCNavigineSdk.getInstance()
    sdk!.setUserHash("Your user hash")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
