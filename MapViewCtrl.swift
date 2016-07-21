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
import FBAnnotationClusteringSwift

class MapViewCtrl: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let regionRadius: CLLocationDistance = 1000
    let melbourneLocation = CLLocation(latitude: -37.8136, longitude: 144.9631)
    var locationManager = (UIApplication.sharedApplication().delegate as! AppDelegate).locationManager
    var discounts:[Discount] = []
    
    
    
    var clusteringManager = FBClusteringManager()
    
    var userLocation:CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate=self
        searchBar.delegate = self
        
        
        let melmelAnnotation = MKPointAnnotation()
        melmelAnnotation.coordinate = CLLocation(latitude: -37.846904, longitude: 144.978653).coordinate
        melmelAnnotation.title = "Melmel"
        melmelAnnotation.subtitle = "416/566 St. Kilda Road, St. Kilda, VIC, 3004"
        mapView.addAnnotation(melmelAnnotation)
        locationAuthStatus()
        // load discounts from core data
        //loadDiscountFromCoreData()
        let postUpdateUtility = PostsUpdateUtility()
        postUpdateUtility.getAllDiscounts({ (discounts) in
            self.addAnnotationViewsForDiscounts(discounts)
            self.centerMapOnLocation(self.melbourneLocation, zoomLevel: 10.0)
        })
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {

        
        
    }
    
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location:CLLocation, zoomLevel:Double) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * zoomLevel, regionRadius * zoomLevel)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if userLocation.location != nil{
            self.userLocation = userLocation.location
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        NSOperationQueue().addOperationWithBlock { 
            let mapBoundsWidth = Double(self.mapView.bounds.size.width)
            let mapRectWidth:Double = self.mapView.visibleMapRect.size.width
            let scale:Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale:scale)
            self.clusteringManager.displayAnnotations(annotationArray, onMapView:self.mapView)
        }
    }

    
    
    /*  Configure annotation view */
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var reuseId = ""
        if annotation.isKindOfClass(FBAnnotationCluster){
            reuseId = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, options: nil)
            return clusterView
        }else if annotation.isKindOfClass(MKUserLocation) {
            return nil
        } else if annotation.isKindOfClass(DiscountAnnotation){
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.image = UIImage(named: "normalPin")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            return annotationView
        }else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.image = UIImage(named: "melmelPin")
            annotationView.canShowCallout = true
            return annotationView
        }

    }
    
    /*  Configure tapped behavior */
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegueWithIdentifier("discountWebViewSegue", sender: view)
    }
    
    func createAnnotationObject(discountForAnnotation:Discount) -> DiscountAnnotation{
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
            centerMapOnLocation(userLocation!,zoomLevel: 2.0)
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
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let postsUpdateUtility = PostsUpdateUtility()
        let keyWords = searchBar.text
        postsUpdateUtility.searchDiscountByKeyWords(keyWords!) { (discounts) in
            self.addAnnotationViewsForDiscounts(discounts)
        }
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func addAnnotationViewsForDiscounts(discounts:[Discount]){
        print("Discounts:\(discounts.count)")
        var annotations = [DiscountAnnotation]()
        clusteringManager = FBClusteringManager()
        
        for discount in discounts {
            // Add Annotations
            let annotation = self.createAnnotationObject(discount)
            //mapView.addAnnotation(annotation)
            annotations.append(annotation)
        }
        print("annotations:\(annotations.count)")
        self.clusteringManager.addAnnotations(annotations)
        self.clusteringManager.displayAnnotations(annotations, onMapView: self.mapView)
    }
    

}
