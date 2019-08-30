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
    
    var allLocationsFetchedResultsController: NSFetchedResultsController<Location>?
    
    override init() {
        persistentContainer = NSPersistentContainer(name:"MelbourneHistory")
        persistentContainer.loadPersistentStores() {(description,error) in
            if let error = error {
                fatalError("Oops! We had trouble loading data. Debug message: \(error)")
            }
        }
        super.init()
        if fetchAllLocations().count == 0 {
            createDefaultLocations()
        }
    }
    func fetchAllLocations(sortOrder:Bool = true) -> [Location] {
        if allLocationsFetchedResultsController == nil {
            let fetchRequest:NSFetchRequest<Location> = Location.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key:"locationName", ascending: sortOrder)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allLocationsFetchedResultsController = NSFetchedResultsController<Location>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allLocationsFetchedResultsController?.delegate = self
            
            do{
                try allLocationsFetchedResultsController?.performFetch()
            } catch {
                print ("Oops! Could not fetch the data. Debug message: \(error)")
            }
        }
        var locations = [Location]()
        if allLocationsFetchedResultsController != nil {
            locations = (allLocationsFetchedResultsController?.fetchedObjects)!
        }
        return locations
    }
    
    func addLocation(locationName: String, locationDescription: String, latitude: Double, longitude: Double, locationCategory: String, imagePathOrName: String) -> Location {
        let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: persistentContainer.viewContext) as! Location
        location.locationName = locationName
        location.locationDescription = locationDescription
        location.latitude = latitude
        location.longitude = longitude
        location.locationCategory = locationCategory
        location.imagePathOrName = imagePathOrName
        // TODO: Move this saveContext to screen change
        saveContext()
        return location
    }
    
    func deleteLocation(location:Location) {
        persistentContainer.viewContext.delete(location)
        // TODO: Move this saveContext to screen change
        saveContext()
    }
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Oops! Failed to save changes. Debug message: \(error)")
            }
        }
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        listener.onLocationsChange(change: .update, locations: fetchAllLocations())
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        listeners.invoke {(listener) in
            listener.onLocationsChange(change: .update, locations: fetchAllLocations())
        }
    }
    
    func createDefaultLocations() {
        let _ = addLocation(locationName: "Bundoora Homestead Art Centre", locationDescription: "Built in 1899, Bundoora Homestead is a magnificent Queen Anne style Federation mansion operating as a historic house, art gallery and cafe, registered by Heritage Victoria and certified by the National Trust.\nBundoora Homestead Art Centre is the public art gallery for the City of Darebin hosting contemporary visual arts and craft exhibitions, a public education program including artist talks, workshops and events. A selected range of Bundoora Homestead and exhibition merchandise is also available for sale.\nBundoora Homestead's café offers a seasonal menu of fresh market and quality commercial produce. Set amidst heritage gardens and located in the elegant drawing room, it is the perfect location for dining in a friendly and relaxed atmosphere.\nBundoora Homestead Art Centre maintains excellent disability access including a lift, on-site car parking and is situated close to public transport.\nBundoora Homestead Art Centre car park entrance via Prospect Hill Drive, Bundoora.", latitude: -37.703747, longitude: 145.048345, locationCategory: "Art Galleries", imagePathOrName: "Bundoora Homestead")
        let _ = addLocation(locationName: "Heide Museum of Modern Art", locationDescription: "Heide Museum of Modern Art, or Heide as it is affectionately known, began life in 1934 as the Melbourne home of John and Sunday Reed and has since evolved into one of Australia's most unique destinations for modern and contemporary Australian art. Located just twenty minutes from the city, Heide boasts fifteen acres of beautiful gardens, three dedicated exhibition spaces, two historic kitchen gardens, a sculpture park and the Heide Store.\nCafé Heide, located in the sculpture plaza opposite the main entrance of the museum, serves coffee, breakfast and a delicious lunch-time menu that focuses on seasonal produce grown in the kitchen garden.\nVisit the website for information on the exhibitions and programs and to discover the museum's fascinating history.", latitude: -37.755678, longitude: 145.092862, locationCategory: "Art Galleries", imagePathOrName: "Heide Museum of Modern Art")
        let _ = addLocation(locationName: "Aboriginal Heritage Walk", locationDescription: "Womin Djeka. Journey into the ancestral lands of the Kulin (Koolin) Nation in this 90 minute tour with an Aboriginal guide. Gain insight into the rich history and thriving culture of the local First Peoples, and discover their connection to plants and their traditional uses for food, tools and medicine.", latitude: -37.828779, longitude: 144.975727, locationCategory: "Arts & Culture", imagePathOrName: "Aboriginal Heritage Walk")
        let _ = addLocation(locationName: "Koorie Heritage Trust", locationDescription: "The Koorie Heritage Trust is a bold and adventurous 21st century Aboriginal arts and cultural organisation.\nThe Koorie Heritage Trust offers an inclusive and engaging environment for all visitors. As an Aboriginal owned and managed organisation, they take great pride in their ability to develop and deliver an authentic and immersive urban Aboriginal arts and cultural experience in a culturally safe environment that cannot be duplicated by any other arts and cultural organisation in Melbourne.\nIn doing so, the trust contributes to Melbourne as a creative city that embraces Aboriginal and Torres Strait Islander people, their history and culture.\nThe Koorie Heritage Trust welcomes non-Indigenous people and invites them to learn about Victoria's Indigenous cultural heritage. The Trust have an annual program of changing exhibitions showing the work of contemporary Indigenous artists, as well as a display of works from their artworks and artefacts permanent collection.\nThe Koorie Heritage Trust offers a range of cultural education and tours including cultural walks such as The River Walk, an historical and cultural tour along the Birrarung (Yarra River) and an exploration of the installations at Birrarung Marr (Common Ground). There is a fee for tours and bookings are required.", latitude: -37.813017, longitude: 144.966225, locationCategory: "Arts & Culture", imagePathOrName: "Koorie Heritage Trust")
    }
}
