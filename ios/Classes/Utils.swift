import Navigine

class Utils {
    static func pointFromJson(_ json: [String: NSNumber]) -> NCPoint {
        return NCPoint(
            x: json["x"]!.floatValue,
            y: json["y"]!.floatValue
        )
    }

    static func screenPointFromJson(_ json: [String: NSNumber]) -> CGPoint {
        return CGPoint(
            x: json["x"]!.doubleValue,
            y: json["y"]!.doubleValue
        )
    }

    static func polylineFromJson(_ json: [String: Any]) -> NCPolyline {
        var points: [NCPoint] = []

        for jsonPoint in (json["points"] as! [[String: NSNumber]]) {
            points.append(pointFromJson(jsonPoint))
        }
        return NCPolyline(points: points)
    }

    static func locationPointFromJson(_ json: [String: Any]) -> NCLocationPoint {
        return NCLocationPoint(
            point: pointFromJson(json["point"] as! [String: NSNumber]),
            locationId: (json["locationId"] as! NSNumber).int32Value,
            sublocationId: (json["sublocationId"] as! NSNumber).int32Value
        )
    }

    static func locationPolylineFromJson(_ json: [String: Any]) -> NCLocationPolyline {
        return NCLocationPolyline(
            polyline: polylineFromJson(json["polyline"] as! [String: Any]),
            locationId: (json["locationId"] as! NSNumber).int32Value,
            sublocationId: (json["sublocationId"] as! NSNumber).int32Value
        )
    }
    
    static func routeOptionsFromJson(_ json: [String: Any]) -> NCRouteOptions {
        return NCRouteOptions(
            smoothRadius: (json["smoothRadius"] as! NSNumber),
            maxProjectionDistance: (json["maxProjectionDistance"] as! NSNumber),
            maxAdvance: (json["maxAdvance"] as! NSNumber))
    }

    static func cameraFromJson(_ json: [String: Any]) -> NCCamera {
        return NCCamera(
            point: pointFromJson(json["point"] as! [String: NSNumber]),
            zoom: (json["zoom"] as! NSNumber).floatValue,
            rotation: (json["rotation"] as! NSNumber).floatValue
        )
    }

    static func locationInfoToJson(_ locationInfo: NCLocationInfo) -> [String: Any?] {
        return [
            "id" : locationInfo.id,
            "version" : locationInfo.version,
            "name" : locationInfo.name,
        ]
    }

    static func pointToJson(_ point: NCPoint) -> [String: Any?] {
        return [
            "x" : point.x,
            "y" : point.y,
        ]
    }

    static func screenPointToJson(_ point: CGPoint) -> [String: Any?] {
        return [
            "x" : point.x,
            "y" : point.y,
        ]
    }

    static func locationPointToJson(_ locationPoint: NCLocationPoint) -> [String: Any?] {
        return [
            "point" : pointToJson(locationPoint.point),
            "locationId" : locationPoint.locationId,
            "sublocationId" : locationPoint.sublocationId
        ]
    }

    static func globalPointToJson(_ globalPoint: NCGlobalPoint) -> [String: Any?] {
        return [
            "latitude" : globalPoint.latitude,
            "longitude" : globalPoint.longitude,
        ]
    }

    static func cameraToJson(_ camera: NCCamera) -> [String: Any?] {
        return [
            "point" : Utils.pointToJson(camera.point),
            "zoom" : camera.zoom,
            "rotation" : camera.rotation,
        ]
    }

    static func beaconToJson(_ beacon: NCBeacon) -> [String: Any?] {
        return [
            "point" : pointToJson(beacon.point),
            "locationId" : beacon.locationId,
            "sublocationId" : beacon.sublocationId,
            "name" : beacon.name,
            "major" : beacon.major,
            "minor" : beacon.minor,
            "uuid" : beacon.uuid,
            "power" : beacon.power,
            "status" : beacon.status.rawValue
        ]
    }

    static func eddystoneToJson(_ eddystone: NCEddystone) -> [String: Any?] {
        return [
            "point" : pointToJson(eddystone.point),
            "locationId" : eddystone.locationId,
            "sublocationId" : eddystone.sublocationId,
            "name" : eddystone.name,
            "namespaceId" : eddystone.namespaceId,
            "instanceId" : eddystone.instanceId,
            "power" : eddystone.power,
            "status" : eddystone.status.rawValue
        ]
    }

    static func wifiToJson(_ wifi: NCWifi) -> [String: Any?] {
        return [
            "point" : pointToJson(wifi.point),
            "locationId" : wifi.locationId,
            "sublocationId" : wifi.sublocationId,
            "name" : wifi.name,
            "mac" : wifi.mac,
            "status" : wifi.status.rawValue
        ]
    }

    static func venueToJson(_ venue: NCVenue) -> [String: Any?] {
        return [
            "point" : pointToJson(venue.point),
            "locationId" : venue.locationId,
            "sublocationId" : venue.sublocationId,
            "name" : venue.name,
            "phone" : venue.phone,
            "description" : venue.descript,
            "alias" : venue.alias,
            "categoryId" : venue.categoryId,
            //            "imageUrl" : venue.imageUrl
        ]
    }

    static func sublocationToJson(_ sublocation: NCSublocation) -> [String: Any?] {
        var beacons = [[String: Any?]]()
        for beacon in sublocation.beacons {
            beacons.append(Utils.beaconToJson(beacon))
        }
        var eddystones = [[String: Any?]]()
        for eddystone in sublocation.eddystones {
            eddystones.append(Utils.eddystoneToJson(eddystone))
        }
        var wifis = [[String: Any?]]()
        for wifi in sublocation.wifis {
            wifis.append(Utils.wifiToJson(wifi))
        }
        var venues = [[String: Any?]]()
        for venue in sublocation.venues {
            venues.append(Utils.venueToJson(venue))
        }
        return [
            "id" : sublocation.id,
            "location" : sublocation.location,
            "name" : sublocation.name,
            "width" : sublocation.width,
            "height" : sublocation.height,
            "azimuth" : sublocation.azimuth,
            "originPoint" : Utils.globalPointToJson(sublocation.originPoint),
            "levelId" : sublocation.levelId,
            "beacons" : beacons,
            "eddystones" : eddystones,
            "wifis" : wifis,
            "venues" : venues,
        ]
    }

    static func locationToJson(_ location: NCLocation) -> [String: Any?] {
        var sublocations = [[String: Any?]]()
        for sublocation in location.sublocations {
            sublocations.append(Utils.sublocationToJson(sublocation))
        }
        return [
            "id" : location.id,
            "version" : location.version,
            "name" : location.name,
            "description" : location.descript,
            "sublocations" : sublocations
        ]
    }

    static func positionToJson(_ position: NCPosition) -> [String: Any?] {
        var locationPoint: [String: Any?]? = nil
        if (position.locationPoint != nil) {
            locationPoint = locationPointToJson(position.locationPoint!)
        }
        return [
            "point" : globalPointToJson(position.point),
            "accuracy" : position.accuracy,
            "heading" : position.heading ?? nil,
            "locationPoint" : locationPoint,
            "locationHeading" : position.locationHeading ?? nil
        ]
    }

    static func routeEventToJson(_ routeEvent: NCRouteEvent) -> [String: Any?] {
        return [
            "type" : routeEvent.type.rawValue,
            "value" : routeEvent.value,
            "distance" : routeEvent.distance
        ]
    }

    static func routePathToJson(_ routePath: NCRoutePath) -> [String: Any?] {
        var events = [[String: Any?]]()
        for event in routePath.events {
            events.append(Utils.routeEventToJson(event))
        }
        var points = [[String: Any?]]()
        for point in routePath.points {
            points.append(Utils.locationPointToJson(point))
        }
        return [
            "length" : routePath.length,
            "events" : events,
            "points" : points
        ]
    }
}
