//
//  MapViewController.swift
//  FIT5140Assignment1
//
//  Created by Aditya Kumar on 30/8/19.
//  Copyright © 2019 Aditya Kumar. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, DatabaseListener {
    var listenerType: ListenerType = ListenerType.locations

    var locationList:[Location] = []
    weak var databaseController: DatabaseProtocol?

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    func onLocationsChange(change: DatabaseChange, locations: [Location]) {
        locationList = locations
        for location in locationList {
            var locationAnnotation:LocationAnnotation
            locationAnnotation = LocationAnnotation(newTitle: location.locationName!, newSubtitle: location.locationDescription!, latitude: location.latitude, longitude: location.longitude, category: location.locationCategory!)
            mapView.addAnnotation(locationAnnotation)
        }
    }
    
    // From the list, if something is clicked, center on it.
    func focusOn(annotation:MKAnnotation) {
        mapView.selectAnnotation(annotation, animated: true)
        
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSightList" {
            let destination = segue.destination as! LocationTableViewController
            destination.locationList = locationList
        }
        
    }

}
