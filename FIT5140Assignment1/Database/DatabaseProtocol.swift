//
//  DatabaseProtocol.swift
//  FIT5140Assignment1
//
//  Created by Aditya Kumar on 31/8/19.
//  Copyright © 2019 Aditya Kumar. All rights reserved.
//

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case locations
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onLocationsChange(change:DatabaseChange, locations: [Location])
}

protocol DatabaseProtocol: AnyObject {
    func addLocation(locationName: String, locationDescription: String, latitude: Double, longitude: Double, locationCategory: String, imagePathOrName: String, locationAddress: String) -> Location
    func deleteLocation(location: Location)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
