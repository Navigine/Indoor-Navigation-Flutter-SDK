import Foundation
import Navigine

public class NaviginePolylineMapObject: NSObject {
    private var id: Int32
    private var mapObject: NCPolylineMapObject
    private let methodChannel: FlutterMethodChannel!
    private let pluginRegistrar: FlutterPluginRegistrar!

    public required init(
        id: Int32,
        mapObject: NCPolylineMapObject,
        registrar: FlutterPluginRegistrar
    ) {
        self.id = id
        self.mapObject = mapObject

        methodChannel = FlutterMethodChannel(
            name: "navigine_sdk/navigine_polyline_map_object_\(id)",
            binaryMessenger: registrar.messenger()
        )

        self.pluginRegistrar = registrar

        super.init()

        weak var weakSelf = self
        self.methodChannel.setMethodCallHandler({ weakSelf?.handle($0, result: $1) })
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setPolyLine":
            result(setPolyLine(call))
        case "setColor":
            result(setColor(call))
        case "setWidth":
            result(setWidth(call))
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

    public func getMapObject() -> NCPolylineMapObject {
        return mapObject
    }

    public func setPolyLine(_ call: FlutterMethodCall) -> Bool {
        let params = call.arguments as! [String: Any]
        let locationPoint = Utils.locationPolylineFromJson(params["locationPolyline"] as! [String : Any])

        return mapObject.setPolyLine(locationPoint)
    }

    public func setColor(_ call: FlutterMethodCall) -> Bool {
        let params = call.arguments as! [String: Any]
        let red = params["red"] as! NSNumber
        let green = params["green"] as! NSNumber
        let blue = params["blue"] as! NSNumber
        let alpha = params["alpha"] as! NSNumber

        return mapObject.setColor(red.floatValue, green: green.floatValue, blue: blue.floatValue, alpha: alpha.floatValue)
    }

    public func getType(_ call: FlutterMethodCall) -> Int {
        return mapObject.getType().rawValue
    }

    public func setWidth(_ call: FlutterMethodCall) -> Bool {
        let params = call.arguments as! [String: Any]
        let width = (params["width"] as! NSNumber)

        return mapObject.setWidth(width.floatValue)
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

    private func getPolylineImage(_ image: [String: Any]) -> UIImage {
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
