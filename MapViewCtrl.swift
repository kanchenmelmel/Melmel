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
    
    @IBOutlet weak var currentLocationButton: UIButton!
    let regionRadius: CLLocationDistance = 1000
    var locationManager = (UIApplication.sharedApplication().delegate as! AppDelegate).locationManager
    var discounts:[Discount] = []
    
    var userLocation:CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate=self
        updateDiscounts()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let melmelAnnotation = MKPointAnnotation()
        melmelAnnotation.coordinate = CLLocation(latitude: -37.846904, longitude: 144.978653).coordinate
        mapView.addAnnotation(melmelAnnotation)
        locationAuthStatus()
        // load discounts from core data
        loadDiscountFromCoreData()
        print("Discounts:\(discounts.count)")
        for discount in discounts {
            // Add Annotations
            let annotation = createAnnotationObject(discount)
            mapView.addAnnotation(annotation)
        }
        
        
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
        if userLocation.location != nil{
            self.userLocation = userLocation.location
        }
    }

    
    
    /*  Configure annotation view */
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        } else if annotation.isKindOfClass(DiscountAnnotation){
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.image = UIImage(named: "normalPin")
            return annotationView
        }else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.image = UIImage(named: "melmelPin")
            return annotationView
        }
//        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
//        annotationView.canShowCallout = true
//        annotationView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
//        return annotationView
    }
    
    /*  Configure tapped behavior */
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegueWithIdentifier("discountWebViewSegue", sender: view)
    }
    
    func createAnnotationObject(discountForAnnotation:Discount) -> MKAnnotation{
        let annotation = DiscountAnnotation(discount:discountForAnnotation)
        return annotation
        
    }
    
    func loadDiscountFromCoreData(){
        let postUpdateUtility = PostsUpdateUtility()
        discounts = postUpdateUtility.fetchDiscounts()
    }
    
    func updateDiscounts() {
        let postUpdateUtility = PostsUpdateUtility()
        postUpdateUtility.updateDiscounts {
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.locationAuthStatus()
                // load discounts from core data
                self.loadDiscountFromCoreData()
                print("Discounts:\(self.discounts.count)")
                for discount in self.discounts {
                    // Add Annotations
                    let annotation = self.createAnnotationObject(discount)
                    self.mapView.addAnnotation(annotation)
                }
            })
            
        }
    }
    
    @IBAction func currentLocation(sender: AnyObject) {
        if userLocation != nil {
            centerMapOnLocation(userLocation!)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "discountWebViewSegue" {
            let annotationview = sender as! MKAnnotationView
            let destinationCtrl = segue.destinationViewController as! PostWebViewController
            let annotation = annotationview.annotation as! DiscountAnnotation
            destinationCtrl.webRequestURLString = annotation.discount!.link!
            destinationCtrl.navigationItem.setRightBarButtonItem(nil, animated: true)
        }
    }
    

}
