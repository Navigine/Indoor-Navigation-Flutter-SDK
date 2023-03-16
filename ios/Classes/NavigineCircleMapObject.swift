import Foundation
import Navigine

public class NavigineCircleMapObject: NSObject {
    private var id: Int32
    private var mapObject: NCCircleMapObject
    private let methodChannel: FlutterMethodChannel!
    private let pluginRegistrar: FlutterPluginRegistrar!

    public required init(
        id: Int32,
        mapObject: NCCircleMapObject,
        registrar: FlutterPluginRegistrar
    ) {
        self.id = id
        self.mapObject = mapObject

        methodChannel = FlutterMethodChannel(
            name: "navigine_sdk/navigine_circle_map_object_\(id)",
            binaryMessenger: registrar.messenger()
        )

        self.pluginRegistrar = registrar

        super.init()

        weak var weakSelf = self
        self.methodChannel.setMethodCallHandler({ weakSelf?.handle($0, result: $1) })
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setPosition":
            result(setPosition(call))
        case "setPositionAnimated":
            result(setPositionAnimated(call))
        case "setColor":
            result(setColor(call))
        case "setRadius":
            result(setRadius(call))
        case "getType":
            result(getType(call))
        case "setVisible":
            result(setVisible(call))
        case "setInteractive":
            result(setInteractive(call))
        case "setStyle":
            result(setStyle(call))
        case "setData":
            setData(call)
            result(nil)
        case "getData":
            result(getData(call))
        case "setTitle":
            result(setTitle(call))
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func getMapObject() -> NCCircleMapObject {
        return mapObject
    }

    public func setPosition(_ call: FlutterMethodCall) -> Bool {
        let params = call.arguments as! [String: Any]
        let locationPoint = Utils.locationPointFromJson(params["locationPoint"] as! [String : Any])

        return mapObject.setPosition(locationPoint)
    }

    public func setPositionAnimated(_ call: FlutterMethodCall) -> Bool {
        let params = call.arguments as! [String: Any]
        let locationPoint = Utils.locationPointFromJson(params["locationPoint"] as! [String : Any])
        let duration = (params["duration"] as! NSNumber)
        let type = params["type"] as! Int

        return mapObject.setPositionAnimated(locationPoint, duration: duration.floatValue, type: NCAnimationType.init(rawValue: type)!)
    }

    public func setColor(_ call: FlutterMethodCall) -> Bool {
        let params = call.arguments as! [String: Any]
        let red = params["red"] as! NSNumber
        let green = params["green"] as! NSNumber
        let blue = params["blue"] as! NSNumber
        let alpha = params["alpha"] as! NSNumber

        return mapObject.setColor(red.floatValue, green: green.floatValue, blue: blue.floatValue, alpha: alpha.floatValue)
    }

    public func setRadius(_ call: FlutterMethodCall) -> Bool {
        let params = call.arguments as! [String: Any]
        let radius = (params["radius"] as! NSNumber)

        return mapObject.setRadius(radius.floatValue)
    }

    public func getType(_ call: FlutterMethodCall) -> Int {
        return mapObject.getType().rawValue
    }

    public func setVisible(_ call: FlutterMethodCall) -> Bool {
        let params = call.arguments as! [String: Any]
        let visible = (params["visible"] as! NSNumber)

        return mapObject.setVisible(visible.boolValue)
    }

    public func setInteractive(_ call: FlutterMethodCall) -> Bool {
        let params = call.arguments as! [String: Any]
        let interactive = (params["interactive"] as! NSNumber)

        return mapObject.setInteractive(interactive.boolValue)
    }

    public func setStyle(_ call: FlutterMethodCall) -> Bool {
        let params = call.arguments as! [String: Any]
        let style = (params["style"] as! String)

        return mapObject.setStyle(style)
    }

    public func setData(_ call: FlutterMethodCall) {
        let params = call.arguments as! [String: Any]
        let data = (params["data"] as! FlutterStandardTypedData).data

        return mapObject.setData(data)
    }

    public func getData(_ call: FlutterMethodCall) -> Data {
        return mapObject.getData()
    }

    public func setTitle(_ call: FlutterMethodCall) -> Bool {
        let params = call.arguments as! [String: Any]
        let title = (params["title"] as! String)

        return mapObject.setTitle(title)
    }

    private func getCircleImage(_ image: [String: Any]) -> UIImage {
        let type = image["type"] as! String
        let defaultImage = UIImage()

        if (type == "fromAssetImage") {
          let assetName = self.pluginRegistrar.lookupKey(forAsset: image["assetName"] as! String)

          return UIImage(named: assetName) ?? defaultImage
        }

        if (type == "fromBytes") {
          let imageData = (image["rawImageData"] as! FlutterStandardTypedData).data

          return UIImage(data: imageData) ?? defaultImage
        }

        return defaultImage
      }
}
