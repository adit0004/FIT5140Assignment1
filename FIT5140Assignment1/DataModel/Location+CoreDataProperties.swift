//
//  Location+CoreDataProperties.swift
//  FIT5140Assignment1
//
//  Created by Aditya Kumar on 31/8/19.
//  Copyright © 2019 Aditya Kumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var locationName: String?
    @NSManaged public var locationDescription: String?
    @NSManaged public var latitude: Double?
    @NSManaged public var longitude: Double?
    @NSManaged public var locationCategory: String?
    @NSManaged public var imagePathOrName: String?

}
