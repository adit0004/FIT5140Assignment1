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
// For user's current location
import CoreLocation


class MapViewController: UIViewController, DatabaseListener, MKMapViewDelegate {
    var listenerType: ListenerType = ListenerType.locations
    var locationList:[Location] = []
    weak var databaseController: DatabaseProtocol?
    var userLocation:CLLocationManager = CLLocationManager()
    var latToZoomOn: Double?
    var longToZoomOn: Double?
    

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set delegate to self
        mapView.delegate = self
        // Set initial latToZoomOn and longToZoomOn to nil
        latToZoomOn = nil
        longToZoomOn = nil
        
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // Current location
        userLocation.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        userLocation.distanceFilter = 10
        userLocation.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        
        // Zoom into Flinder's Street Station, keep 2000m radius
        let zoomRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -37.8183, longitude: 144.9671), latitudinalMeters: 3000, longitudinalMeters: 3000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Handle zoom
        if latToZoomOn != nil {
            focusOn(lat: latToZoomOn!, long: longToZoomOn!)
            for location in mapView.annotations {
                if location.coordinate.latitude == latToZoomOn! && location.coordinate.longitude == longToZoomOn! {
                    mapView.selectAnnotation(location, animated: true)
                }
            }

        }
    }
    
    func onLocationsChange(change: DatabaseChange, locations: [Location]) {
        locationList = locations
        
        for location in locationList {
            var locationAnnotation:LocationAnnotation
            locationAnnotation = LocationAnnotation(newTitle: location.locationName!, newSubtitle: location.locationCategory!, latitude: location.latitude, longitude: location.longitude, locationDescription: location.locationDescription!, address: location.locationAddress!, imagePathOrName: location.imagePathOrName!)
            mapView.addAnnotation(locationAnnotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        if annotation.isKind(of: MKUserLocation.self) {
            return annotationView
        }
        
        let castedAnnotation:LocationAnnotation = annotation as! LocationAnnotation
        if annotation.subtitle == "Art Galleries" {
            annotationView?.image = UIImage(named: "Art Galleries")
        } else if annotation.subtitle == "Arts & Culture" {
            annotationView?.image = UIImage(named: "Arts & Culture")
        } else if annotation.subtitle == "Theatre & Musicals" {
            annotationView?.image = UIImage(named: "Theatre & Musical")
        } else if annotation.subtitle == "Museums" {
            annotationView?.image = UIImage(named: "Museum")
        } else if annotation.subtitle == "Heritage Buildings" {
            annotationView?.image = UIImage(named: "Heritage")
        } else if annotation.subtitle == "History & Heritage" {
            annotationView?.image = UIImage(named: "History")
        } else if annotation.subtitle == "Maritime History" {
            annotationView?.image = UIImage(named: "Maritime History")
        } else if annotation.subtitle == "Architecture & Design" {
            annotationView?.image = UIImage(named: "Architecture")
        } else {
            annotationView?.image = UIImage(named: "Default Pin")
        }
        annotationView?.canShowCallout = true
        
        let button = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = button
        
        // Location picture
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        var imageToUse = UIImage(named: castedAnnotation.imagePathOrName!)
        if imageToUse == nil {
            imageToUse = UIImage(contentsOfFile: castedAnnotation.imagePathOrName!)
        }
        if imageToUse == nil {
            imageToUse = UIImage(named: "Placeholder")
        }
        imageView.image = imageToUse
        annotationView?.leftCalloutAccessoryView = imageView
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Selected: \(String(describing:view.annotation?.title))")
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let castedAnnotation = view.annotation as! LocationAnnotation
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sightDetailViewController:SightDetailsViewController = storyboard.instantiateViewController(withIdentifier: "sightDetailsController") as! SightDetailsViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        
        sightDetailViewController.locationName = castedAnnotation.title
        sightDetailViewController.locationDescription = castedAnnotation.locationDescription
        var imageToSend = UIImage(named: castedAnnotation.imagePathOrName!)
        if imageToSend == nil {
            imageToSend = UIImage(contentsOfFile: castedAnnotation.imagePathOrName!)
        }
        if imageToSend == nil {
            imageToSend = UIImage(named: "Placeholder")
        }
        sightDetailViewController.locationImage = imageToSend
        sightDetailViewController.locationAddress = castedAnnotation.address
        sightDetailViewController.locationCategory = castedAnnotation.subtitle
        appDelegate.navigationView?.pushViewController(sightDetailViewController, animated: true)

    }
    
    // From the list, if something is clicked, center on it.
    // Instead of calling this using MKAnnotation like in the tut, I'm calling this using the coordinates. This is because the locations on the other side are just location objects, not annotations
    func focusOn(lat:Double, long:Double) {
        let zoomRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Start tracking location
        userLocation.startUpdatingLocation()
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop tracking location
        userLocation.stopUpdatingLocation()
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
