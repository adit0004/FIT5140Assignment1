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
    
    func addLocation(locationName: String, locationDescription: String, latitude: Double, longitude: Double, locationCategory: String, imagePathOrName: String, locationAddress: String) -> Location {
        let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: persistentContainer.viewContext) as! Location
        location.locationName = locationName
        location.locationDescription = locationDescription
        location.latitude = latitude
        location.longitude = longitude
        location.locationCategory = locationCategory
        location.imagePathOrName = imagePathOrName
        location.locationAddress = locationAddress
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
        let _ = addLocation(locationName: "Bundoora Homestead Art Centre", locationDescription: "Built in 1899, Bundoora Homestead is a magnificent Queen Anne style Federation mansion operating as a historic house, art gallery and cafe, registered by Heritage Victoria and certified by the National Trust.\n\nBundoora Homestead Art Centre is the public art gallery for the City of Darebin hosting contemporary visual arts and craft exhibitions, a public education program including artist talks, workshops and events. A selected range of Bundoora Homestead and exhibition merchandise is also available for sale.\n\nBundoora Homestead's café offers a seasonal menu of fresh market and quality commercial produce. Set amidst heritage gardens and located in the elegant drawing room, it is the perfect location for dining in a friendly and relaxed atmosphere.\n\nBundoora Homestead Art Centre maintains excellent disability access including a lift, on-site car parking and is situated close to public transport.\n\nBundoora Homestead Art Centre car park entrance via Prospect Hill Drive, Bundoora.", latitude: -37.703747, longitude: 145.048345, locationCategory: "Art Galleries", imagePathOrName: "Bundoora Homestead", locationAddress: "7 Prospect Hill Dr, Bundoora VIC 3083")
        let _ = addLocation(locationName: "Heide Museum of Modern Art", locationDescription: "Heide Museum of Modern Art, or Heide as it is affectionately known, began life in 1934 as the Melbourne home of John and Sunday Reed and has since evolved into one of Australia's most unique destinations for modern and contemporary Australian art. Located just twenty minutes from the city, Heide boasts fifteen acres of beautiful gardens, three dedicated exhibition spaces, two historic kitchen gardens, a sculpture park and the Heide Store.\n\nCafé Heide, located in the sculpture plaza opposite the main entrance of the museum, serves coffee, breakfast and a delicious lunch-time menu that focuses on seasonal produce grown in the kitchen garden.\n\nVisit the website for information on the exhibitions and programs and to discover the museum's fascinating history.", latitude: -37.755678, longitude: 145.092862, locationCategory: "Art Galleries", imagePathOrName: "Heide Museum of Modern Art", locationAddress: "7 Templestowe Rd, Bulleen VIC 3105")
        let _ = addLocation(locationName: "Aboriginal Heritage Walk", locationDescription: "Womin Djeka. Journey into the ancestral lands of the Kulin (Koolin) Nation in this 90 minute tour with an Aboriginal guide. Gain insight into the rich history and thriving culture of the local First Peoples, and discover their connection to plants and their traditional uses for food, tools and medicine.", latitude: -37.828779, longitude: 144.975727, locationCategory: "Arts & Culture", imagePathOrName: "Aboriginal Heritage Walk", locationAddress: "Visitors Centre, Birdwood Ave, South Yarra VIC 3141")
        let _ = addLocation(locationName: "Koorie Heritage Trust", locationDescription: "The Koorie Heritage Trust is a bold and adventurous 21st century Aboriginal arts and cultural organisation.\n\nThe Koorie Heritage Trust offers an inclusive and engaging environment for all visitors. As an Aboriginal owned and managed organisation, they take great pride in their ability to develop and deliver an authentic and immersive urban Aboriginal arts and cultural experience in a culturally safe environment that cannot be duplicated by any other arts and cultural organisation in Melbourne.\n\nIn doing so, the trust contributes to Melbourne as a creative city that embraces Aboriginal and Torres Strait Islander people, their history and culture.\n\nThe Koorie Heritage Trust welcomes non-Indigenous people and invites them to learn about Victoria's Indigenous cultural heritage. The Trust have an annual program of changing exhibitions showing the work of contemporary Indigenous artists, as well as a display of works from their artworks and artefacts permanent collection.\n\nThe Koorie Heritage Trust offers a range of cultural education and tours including cultural walks such as The River Walk, an historical and cultural tour along the Birrarung (Yarra River) and an exploration of the installations at Birrarung Marr (Common Ground). There is a fee for tours and bookings are required.", latitude: -37.813017, longitude: 144.966225, locationCategory: "Arts & Culture", imagePathOrName: "Koorie Heritage Trust", locationAddress: "Little Lonsdale St, Melbourne VIC 3000")
        let _ = addLocation(locationName: "Her Majesty's Theatre", locationDescription: "Her Majesty's Theatre, one of Melbourne's most iconic venues for live performance, has been entertaining Australia since 1886.\n\nNewly restored and with ongoing renovations and improvements - including new and more comfortable seats throughout the auditorium, a modern stage house, enlarged orchestra pit and upgraded backstage facilities - Her Majesty's Theatre continues to be a truly dynamic venue, hosting musicals, plays, opera, dance, comedy and more. Its Art Deco interior boasts an impressive seating capacity of 1700 seats, yet the auditorium is renowned for its intimate setting.\n\nTo add that special something to your visit, Her Majesty's Theatre has elegantly appointed private rooms and catering options available for anywhere from couples celebrating a romantic night out at the theatre, through to large groups.", latitude: -37.810650, longitude: 144.969547, locationCategory: "Theatre & Musicals", imagePathOrName: "Her Majesty's Theatre", locationAddress: "219 Exhibition St, Melbourne VIC 3000")
        let _ = addLocation(locationName: "Victoria Police Museum", locationDescription: "From the largest collection of Kelly Gang armour in Australia to forensic evidence from some of Melbourne's most notorious crimes, the Victoria Police Museum presents visitors with an intriguing insight into the social history of policing and crime.\n\nLearn what life would have been like as a police officer in the 19th century, discover some of the shady underworld figures lurking around Melbourne's streets in the 1920s and explore the diversity of policing in the 21st century.\n\nExhibitions at the Victoria Police Museum include the iconic armour worn by members of the Kelly Gang; the remains of the car used in the Russell Street headquarters bombing and police files on some of Melbourne's most infamous criminals, including 'Squizzy' Taylor.\n\nThe Museum hosts a number of temporary exhibitions throughout the year. Check the website for details on current exhibitions.\n\nAlso located in the Museum is the Victoria Police Museum Shop, offering unique gifts for adults and children. Delve into some crime, mystery and history with the range of books, unique collection-based products and Victoria Police branded merchandise.", latitude: -37.822089, longitude: 144.954161, locationCategory: "Museums", imagePathOrName: "Victoria Police Museum", locationAddress: "Mezzanine Level, 637 Flinders St, Docklands VIC 3008")
        let _ = addLocation(locationName: "Chinese Museum", locationDescription: "Located in the heart of Melbourne’s Chinatown, the Chinese Museum (Museum of Chinese Australian History)’s five floors showcase the heritage and culture of Australia’s Chinese community.\n\nMarvel at the world’s biggest processional Dai Loong Dragon, experience Finding Gold and discover the new One Million Stories Exhibition, showcasing the contribution Chinese Australians have made to Australian Society over 200 years.", latitude: -37.810480, longitude: 144.969140, locationCategory: "Museums", imagePathOrName: "Chinese Museum", locationAddress: "22 Cohen Pl, Melbourne VIC 3000")
        
        let _ = addLocation(locationName: "Cooks' Cottage", locationDescription: "Built in 1755, Cooks' Cottage is the oldest building in Australia and a popular Melbourne tourist attraction.\n\nOriginally located in Yorkshire, England, and built by the parents of Captain James Cook, the cottage was brought to Melbourne by Sir Russell Grimwade in 1934. Astonishingly, each brick was individually numbered, packed into barrels and then shipped to Australia.\n\nCombining modern interpretations of Captain Cook's adventures, centuries-old antiques, a delightful English cottage garden, volunteers dressed in 18th century costumes and a new interpretive space in the stable, Cooks' Cottage is a fascinating step back in time.\n\nEntry to the cottage includes a comprehensive fact sheet for a self-guided tour. Available in English, Cantonese, Mandarin, Italian, Spanish, Russian, Thai, Indonesian, Japanese, German, French and Korean.\n\nSchool tours and group tours and visits are also available.\n\nTickets and souvenirs can be purchased from the Fitzroy Gardens Visitor Centre, just 100 metres away.", latitude: -37.814310, longitude: 144.979489, locationCategory: "Heritage Buildings", imagePathOrName: "Cook's Cottage", locationAddress: "Fitzroy Gardens, Wellington Parade, East Melbourne VIC 3002")
        
        let _ = addLocation(locationName: "Brighton Bathing Boxes", locationDescription: "Dive into Port Phillip Bay under the watch of 82 distinctive bathing boxes, a row of uniformly proportioned wooden structures lining the foreshore at Brighton Beach.\n\nBuilt well over a century ago in response to very Victorian ideas of morality and seaside bathing, the bathing boxes remain almost unchanged. All retain classic Victorian architectural features with timber framing, weatherboards and corrugated iron roofs, though they also bear the hallmarks of individual licencees' artistic and colourful embellishments.\n\nThanks to these distinctive decorations, the boxes turn the Brighton seaside into an immediately recognisable, iconic beachscape that can transform by the hour according to season, light and colour. Just try to resist pulling out your camera and snapping away.", latitude: -37.917159, longitude: -144.986688, locationCategory: "Heritage Buildings", imagePathOrName: "Brighton Bathing Boxes", locationAddress: "Esplanade, Brighton VIC 3186")
        
        let _ = addLocation(locationName: "Rippon Lea Estate", locationDescription: "An intact example of 19th century suburban high life, the National Heritage Listed Rippon Lea Estate is like a suburb all to itself, an authentic Victorian mansion amidst 14 acres of breathtaking gardens.\n\nMake yourself at home exploring over 20 rooms in the original estate, its sweeping heritage grounds, a picturesque lake and waterfall, an original 19th century fruit orchard and the largest fernery in the Southern Hemisphere.\n\nKeep your eyes peeled for the Gruffalo’s latest hideout.\n\nOpen all year, Rippon Lea Estate is Victoria’s grandest backyard.", latitude: -37.879290, longitude: 144.998889, locationCategory: "History & Heritage", imagePathOrName: "Rippon Lea Estate", locationAddress: "192 Hotham St, Elsternwick VIC 3185")
        
        let _ = addLocation(locationName: "St Michael's Uniting Church", locationDescription: "St Michael's is a unique church in the heart of the city. It is not only unique for its relevant, contemporary preaching, but for its unusual architecture.\n\nSt Michael's strives to be the best possible model of what the New Faith can be; they want to attract and sustain larger numbers of people who see that this expression of church life is the most meaningful and worthwhile experience for them.\n\nIt is a place which affirms and encourages the best expression of who you are and who you can be, through relevant theology, Sunday Service, numerous support programs and its commitment to counselling and psychotherapy.\n\nFor further information please contact St Michael's Uniting Church or view their website.", latitude: -37.814021, longitude: 144.969281, locationCategory: "History & Heritage", imagePathOrName: "St Michael's Uniting Church", locationAddress: "120 Collins St, Melbourne VIC 3000")
        
        let _ = addLocation(locationName: "Polly Woodside", locationDescription: "Climb aboard and roam the decks of the historic Polly Woodside, one of Australia’s last surviving 19th century tall ships.\n\nExperience the turbulent trials of history at sea and steer your way through blustering tales from the ship’s 17 world voyages, above and below deck. Polly Woodside offers a range of activities for visitors including an award-winning interactive gallery on its history, children’s Crew Calls and Pirate Days.\n\nLocated in the heart of Melbourne’s South Wharf, discover life on the seas with one of Melbourne most iconic and enchanting attractions.", latitude: -37.824248, longitude: 144.953581, locationCategory: "Maritime History", imagePathOrName: "Polly Woodside", locationAddress: "21 S Wharf Promenade, South Wharf VIC 3006")
        
        let _ = addLocation(locationName: "Seaworks and the Maritime Discovery Centre", locationDescription: "The Seaworks and the Maritime Discovery Centre is a new and exciting location for any event given its mix of indoor and outdoor space with the enviable view of the Melbourne skyline and Port Phillip Bay.\n\nCatch an upcoming event, visit the Sea Shepherd or grab a drink at The Pirate’s Tavern.\n\nIncluded in the maritime collection is a large display of ship models, ships bells, books, prints, navigation equipment, plaques, marine equipment and its World War Honour board.\n\nThe centre is open every Wednesday, Friday and Sunday from 11:00am to 3:00pm and group tours are available at other times.", latitude: -37.863031, longitude: 144.907147, locationCategory: "Maritime History", imagePathOrName: "Seaworks and the Maritime Discovery Centre", locationAddress: "82 Nelson Place, Williamstown, Victoria, 3016")
        
        let _ = addLocation(locationName: "Villa Alba Museum", locationDescription: "Villa Alba Museum is a lavishly decorated 1880 Italianate mansion in Kew adjacent to Studley Park. It is elaborately decorated with painted ceilings and walls with trompe l'oeil being used and 40 foot panoramic murals of marine views of Sydney and Edinburgh of national significance.\n\nRestoration of the house is ongoing. The heritage garden has been reinstated in its late Victorian form.\n\nThe House is open on the first Sunday of the month from 1:00pm to 4:00pm. Come and explore the house and garden and enjoy afternoon tea in the Vestibule.\n\nTours also available by appointment.", latitude: -37.804911, longitude: 145.011192, locationCategory: "Architecture & Design", imagePathOrName: "Villa Alba Museum", locationAddress: "44 Walmer St, Kew VIC 3101")
        
        let _ = addLocation(locationName: "Portable Iron Houses", locationDescription: "The nineteenth century Portable Iron Houses provide an insight into life in Emerald Hill, now known as South Melbourne, during the gold rush years.\n\nThese remarkable examples of early property development are among the few prefabricated iron buildings remaining in the world.\n\nIn 1855 South Melbourne had nearly 100 portable buildings, of which 399 Patterson House still stands on its original site. Abercrombie House and Bellhouse House were moved to the current site from North Melbourne and Fitzroy, respectively.\n\nGet an unparalleled insight into life during the gold rush when you visit one of these long lost relics of Australian history.", latitude: -37.833988, longitude: 144.953300, locationCategory: "Architecture & Design", imagePathOrName: "Portable Iron Houses", locationAddress: "399 Coventry St, South Melbourne VIC 3205")
    }
}
