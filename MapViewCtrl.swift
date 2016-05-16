//
//  MapViewCtrl.swift
//  Melmel
//
//  Created by Work on 16/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewCtrl: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    var locationManager = (UIApplication.sharedApplication().delegate as! AppDelegate).locationManager
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate=self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        locationAuthStatus()
        
        // Add Annotations
        let location = CLLocation(latitude: -37.846905, longitude: 144.978653)
        let annotation = createAnnotationObject(location, title: "Melmel Consulting", subtitle: "We are Melmel")
        mapView.addAnnotation(annotation)
    }
    
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location:CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if let location = userLocation.location {
            centerMapOnLocation(location)
        }

    }
    
    func createAnnotationObject(location:CLLocation,title:String,subtitle:String) -> MKAnnotation{
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title=title
        annotation.subtitle = subtitle
        return annotation
        
    }
    

}
