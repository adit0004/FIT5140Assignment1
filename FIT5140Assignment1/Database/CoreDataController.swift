//
//  CoreDataController.swift
//  FIT5140Assignment1
//
//  Created by Aditya Kumar on 31/8/19.
//  Copyright © 2019 Aditya Kumar. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, NSFetchedResultsControllerDelegate, DatabaseProtocol {
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    var allLocationsFetchedResultsContainer: NSFetchedResultsController<Location>?
    
    override init() {
        persistentContainer = NSPersistentContainer(name:"MelbourneHistory")
    }
}
