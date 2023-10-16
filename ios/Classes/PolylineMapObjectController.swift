import Navigine

class PolylineMapObjectController: NSObject {
    public weak var locationView: NCLocationView?

    private let pluginRegistrar: FlutterPluginRegistrar!
    private var mapObjects: [Int32: NaviginePolylineMapObject] = [:]

    public required init(
        registrar: FlutterPluginRegistrar,
        locationView: NCLocationView
    ) {
        self.pluginRegistrar = registrar
        self.locationView = locationView
        super.init()
    }

    public func addPolylineMapObject() -> Int32? {
        if locationView == nil {
            return nil
        }
        let polylineMapObject = locationView!.locationWindow.addPolylineMapObject()
        let polylineMapObjectId = polylineMapObject!.getId()
        mapObjects[polylineMapObjectId] = NaviginePolylineMapObject(id: polylineMapObjectId, mapObject: polylineMapObject!, registrar: self.pluginRegistrar)
        return polylineMapObjectId

    }

    public func removePolylineMapObject(id: Int32) -> Bool? {
        if locationView == nil {
            return nil
        }
        let polylineMapObject = mapObjects[id]
        if (polylineMapObject == nil) {
            return false
        }

        let success = locationView?.locationWindow.remove((polylineMapObject?.getMapObject())!);
        mapObjects.removeValue(forKey: id)
        return success
    }
}
