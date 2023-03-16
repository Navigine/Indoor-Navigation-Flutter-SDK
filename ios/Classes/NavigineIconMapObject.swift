import Foundation
import Navigine

public class NavigineIconMapObject: NSObject {
    private var id: Int32
    private var mapObject: NCIconMapObject
    private let methodChannel: FlutterMethodChannel!
    private let pluginRegistrar: FlutterPluginRegistrar!

    public required init(
        id: Int32,
        mapObject: NCIconMapObject,
        registrar: FlutterPluginRegistrar
    ) {
        self.id = id
        self.mapObject = mapObject

        methodChannel = FlutterMethodChannel(
            name: "navigine_sdk/navigine_icon_map_object_\(id)",
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
        case "setImage":
            result(setImage(call))
        case "setSize":
            result(setSize(call))
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

    public func getMapObject() -> NCIconMapObject {
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

    public func setImage(_ call: FlutterMethodCall) -> Bool {
        let params = call.arguments as! [String: Any]
        let image = params["image"] as! [String : Any]

        return mapObject.setBitmap(getIconImage(image))
    }

    public func setSize(_ call: FlutterMethodCall) -> Bool {
        let params = call.arguments as! [String: Any]
        let width = (params["width"] as! NSNumber)
        let height = (params["height"] as! NSNumber)

        return mapObject.setSize(width.floatValue,  height: height.floatValue)
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

    private func getIconImage(_ image: [String: Any]) -> UIImage {
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
