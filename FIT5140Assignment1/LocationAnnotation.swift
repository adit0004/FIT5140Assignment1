//
//  LocationAnnotation.swift
//  FIT5140Assignment1
//
//  Created by Aditya Kumar on 30/8/19.
//  Copyright © 2019 Aditya Kumar. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var locationDescription: String?
    var address: String?
    var imagePathOrName: String?
    
    init(newTitle:String, newSubtitle:String, latitude:Double, longitude:Double, locationDescription:String, address:String, imagePathOrName:String) {
        self.title = newTitle
        self.subtitle = newSubtitle
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.address = address
        self.locationDescription = locationDescription
        self.imagePathOrName = imagePathOrName
    }
    
    
}
