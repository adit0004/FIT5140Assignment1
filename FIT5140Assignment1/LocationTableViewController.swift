//
//  LocationTableViewController.swift
//  FIT5140Assignment1
//
//  Created by Aditya Kumar on 30/8/19.
//  Copyright © 2019 Aditya Kumar. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {

    var mapViewController:MapViewController?
    var locationList = [LocationAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // TODO: These are hardcoded for the initial prototype, replace these with coreData loaded locations
        var location = LocationAnnotation(newTitle: "Koorie Heritage Trust", newSubtitle: "The Koorie Heritage Trust is a bold and adventurous 21st century Aboriginal arts and cultural organisation.\nThe Koorie Heritage Trust offers an inclusive and engaging environment for all visitors. As an Aboriginal owned and managed organisation, they take great pride in their ability to develop and deliver an authentic and immersive urban Aboriginal arts and cultural experience in a culturally safe environment that cannot be duplicated by any other arts and cultural organisation in Melbourne.\nIn doing so, the trust contributes to Melbourne as a creative city that embraces Aboriginal and Torres Strait Islander people, their history and culture.\nThe Koorie Heritage Trust welcomes non-Indigenous people and invites them to learn about Victoria's Indigenous cultural heritage. The Trust have an annual program of changing exhibitions showing the work of contemporary Indigenous artists, as well as a display of works from their artworks and artefacts permanent collection.\nThe Koorie Heritage Trust offers a range of cultural education and tours including cultural walks such as The River Walk, an historical and cultural tour along the Birrarung (Yarra River) and an exploration of the installations at Birrarung Marr (Common Ground). There is a fee for tours and bookings are required.", latitude: 	-37.877623, longitude: 145.045374, category: "Arts & Culture")
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        location = LocationAnnotation(newTitle: "Melbourne's Tall Ship - Enterprize", newSubtitle: "Step aboard Melbourne's Tall Ship Enterprize and step back to a time of daring voyages and discovery. Feel the romance and excitement of sailing with the wind in your hair as you take in spectacular views of Melbourne's skyline, Port Phillip Bay and Australia's spectacular southern coast.\nExperience history on a magnificent handcrafted replica of John Pascoe Faulkner's Enterprize, the ship that brought the first permanent European settlers to Melbourne in 1835. Discover life as an early explorer and uncover the tale of ambition, intrigue and rivalry that led to Melbourne's foundation. Relax on deck or hoist the sails, steer the ship and climb the rigging for heart stopping thrills.\nEnterprize has monthly public sails from Docklands, Williamstown, Mornington and Geelong, with sails from Portarlington during peak season and special events, such as the Mussel and Celtic Festivals.", latitude:  -37.819563, longitude: 144.935681, category: "Water Sport")
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locationCell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
        let location = locationList[indexPath.row]
        locationCell.locationNameLabel.text = location.title
        locationCell.locationDescriptionLabel.text = location.subtitle
        
        // Try checking if a named xcasset exists
        var imageToSet:UIImage? = UIImage(named: location.title!)
        // If xcasset is nil, try fetching content of file
        if (imageToSet == nil) {
            // TODO: fetch from file
            imageToSet = UIImage(named: "Placeholder")
        }
        
        locationCell.locationImageField.image = imageToSet
        
        return locationCell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.locationList.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
