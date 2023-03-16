import Navigine

class IconMapObjectController: NSObject {
    public weak var locationView: NCLocationView?

    private let pluginRegistrar: FlutterPluginRegistrar!
    private var mapObjects: [Int32: NavigineIconMapObject] = [:]

    public required init(
        registrar: FlutterPluginRegistrar,
        locationView: NCLocationView
    ) {
        self.pluginRegistrar = registrar
        self.locationView = locationView
        super.init()
    }

    public func addIconMapObject() -> Int32? {
        if locationView == nil {
            return nil
        }
        let iconMapObject = locationView!.addIconMapObject()
        let iconMapObjectId = iconMapObject.getId()
        mapObjects[iconMapObjectId] = NavigineIconMapObject(id: iconMapObjectId, mapObject: iconMapObject, registrar: self.pluginRegistrar)
        return iconMapObjectId

    }
    
    public func removeIconMapObject(id: Int32) -> Bool? {
        if locationView == nil {
            return nil
        }
        let iconMapObject = mapObjects[id]
        if (iconMapObject == nil) {
            return false
        }
        
        let success = locationView?.remove((iconMapObject?.getMapObject())!);
        mapObjects.removeValue(forKey: id)
        return success
    }
}
