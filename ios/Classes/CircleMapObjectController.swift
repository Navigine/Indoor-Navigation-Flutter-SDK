import Navigine

class CircleMapObjectController: NSObject {
    public weak var locationView: NCLocationView?

    private let pluginRegistrar: FlutterPluginRegistrar!
    private var mapObjects: [Int32: NavigineCircleMapObject] = [:]

    public required init(
        registrar: FlutterPluginRegistrar,
        locationView: NCLocationView
    ) {
        self.pluginRegistrar = registrar
        self.locationView = locationView
        super.init()
    }

    public func addCircleMapObject() -> Int32? {
        if locationView == nil {
            return nil
        }
        let circleMapObject = locationView!.addCircleMapObject()
        let circleMapObjectId = circleMapObject.getId()
        mapObjects[circleMapObjectId] = NavigineCircleMapObject(id: circleMapObjectId, mapObject: circleMapObject, registrar: self.pluginRegistrar)
        return circleMapObjectId

    }

    public func removeCircleMapObject(id: Int32) -> Bool? {
        if locationView == nil {
            return nil
        }
        let circleMapObject = mapObjects[id]
        if (circleMapObject == nil) {
            return false
        }

        let success = locationView?.remove((circleMapObject?.getMapObject())!);
        mapObjects.removeValue(forKey: id)
        return success
    }
}
