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

enum AnnotationPinImg: String {
    case Entertainment = "EntertainmentPin"
    case Shopping = "ShoppingPin"
    case Fashion = "FashionPin"
    case Service = "ServicePin"
    case Food = "FoodPin"
}


class MapViewCtrl: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate {
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let regionRadius: CLLocationDistance = 1000
    let melbourneLocation = CLLocation(latitude: -37.8136, longitude: 144.9631)
    var locationManager = (UIApplication.sharedApplication().delegate as! AppDelegate).locationManager
    var discounts:[Discount] = []
    var discountDetailViewController:MapDiscountDetailViewController = MapDiscountDetailViewController()
    
    var clusteringManager = FBClusteringManager()
    
    var userLocation:CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate=self
        searchBar.delegate = self
        
//        
//        let melmelAnnotation = MKPointAnnotation()
//        melmelAnnotation.coordinate = CLLocation(latitude: -37.846904, longitude: 144.978653).coordinate
//        melmelAnnotation.title = "Melmel"
//        melmelAnnotation.subtitle = "416/566 St. Kilda Road, St. Kilda, VIC, 3004"
//        mapView.addAnnotation(melmelAnnotation)
        locationAuthStatus()
        // load discounts from core data
        //loadDiscountFromCoreData()
        let postUpdateUtility = PostsUpdateUtility()
        
        
        

        postUpdateUtility.getAllDiscounts({ (discounts) in
            
            //activityIndicatorVC.dismissViewControllerAnimated(true, completion: nil)
            
            self.centerMapOnLocation(self.melbourneLocation, zoomLevel: 10.0)
        
        })
        
//        discountDetailView = NSBundle.mainBundle().loadNibNamed("MapDiscountDetailView", owner: self, options: nil)[0] as? MapDiscountDetailView
//        discountDetailView.center = CGPoint(x: 0.0, y: 0.0)
//        self.mapView.addSubview(discountDetailView)
        
        addDiscountDetailViewController()
        
        
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
            let discountAnnotation = annotation as! DiscountAnnotation
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            var annotationViewImgFilename = ""
            if discountAnnotation.discount!.catagories[0] == .Shopping{
                annotationViewImgFilename = AnnotationPinImg.Shopping.rawValue
            }
            if discountAnnotation.discount!.catagories[0] == .Entertainment {
                annotationViewImgFilename = AnnotationPinImg.Entertainment.rawValue
            }
            if discountAnnotation.discount!.catagories[0] == .Food {
                annotationViewImgFilename = AnnotationPinImg.Food.rawValue
            }
            if discountAnnotation.discount!.catagories[0] == .Service {
                annotationViewImgFilename = AnnotationPinImg.Service.rawValue
            }
            if discountAnnotation.discount!.catagories[0] == .Fashion {
                annotationViewImgFilename = AnnotationPinImg.Fashion.rawValue
            }
            annotationView.image = UIImage(named: annotationViewImgFilename)
            annotationView.canShowCallout = false
            //Right Callout Accessary View
            annotationView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            //Left Callout Accessary View
            
            
            if (discountAnnotation.discount?.discountTag != nil){
                //print(discountAnnotation.discount?.discountTag)
                let discountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                discountLabel.text = discountAnnotation.discount?.discountTag
                discountLabel.textColor = UIColor.blackColor()
                annotationView.leftCalloutAccessoryView = discountLabel
            }
            
            
            
            return annotationView
        }else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.image = UIImage(named: "melmelPin")
            annotationView.canShowCallout = false
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
    
    
    // Prepare Segue
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
        var annotations = [DiscountAnnotation]()
        clusteringManager = FBClusteringManager()
        
        for discount in discounts {
            // Add Annotations
            //print(discount.catagories.count)
            let annotation = self.createAnnotationObject(discount)
            //mapView.addAnnotation(annotation)
            annotations.append(annotation)
        }
        
        
        self.clusteringManager.addAnnotations(annotations)
        self.clusteringManager.displayAnnotations(annotations, onMapView: self.mapView)
    }
    
    func addDiscountDetailViewController(){
        self.addChildViewController(discountDetailViewController)
        var viewRect:CGRect!

        viewRect = CGRectMake(0.0, CGRectGetHeight(self.mapView.frame)-75.0, CGRectGetWidth(self.mapView.frame), 75.0)
        discountDetailViewController.view.frame = viewRect
        self.mapView.addSubview(discountDetailViewController.view)
        //self.discountDetailViewController.view.hidden = true
        print(discountDetailViewController.view.frame.height)
        print(self.view.frame.height)
        print(self.mapView.frame.height)
    }
    
    

}
