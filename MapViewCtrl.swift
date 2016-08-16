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


class MapViewCtrl: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate,UIPopoverPresentationControllerDelegate {
    
    
    let discountDetailViewController = MapDiscountDetailViewController()
    
    
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
        
        
        let loadingAlert = LoadingAlertController(title: "", message: nil, preferredStyle: .Alert)
        //self.addChildViewController(loadingAlert)
        presentViewController(loadingAlert, animated: true, completion: nil)
        loadingAlert.activityIndicatorView.center = loadingAlert.view.center

        postUpdateUtility.getAllDiscounts({ (discounts) in
            
            
            self.addAnnotationViewsForDiscounts(discounts)
            self.centerMapOnLocation(self.melbourneLocation, zoomLevel: 10.0)
            loadingAlert.close()
        })
        
//        discountDetailView = NSBundle.mainBundle().loadNibNamed("MapDiscountDetailView", owner: self, options: nil)[0] as? MapDiscountDetailView
//        discountDetailView.center = CGPoint(x: 0.0, y: 0.0)
//        self.mapView.addSubview(discountDetailView)
        
        //addDiscountDetailViewController()
        
        
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
            let annotationView = DiscountAnnotationView(annotation: annotation, reuseIdentifier: nil,delegate: self)
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
            print(annotationViewImgFilename)
            annotationView.image = UIImage(named: annotationViewImgFilename)
            
            //Right Callout Accessary View
            //annotationView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            //Left Callout Accessary View
            
            
            
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
    
    @IBAction func showCategoryPopover(sender: AnyObject) {
        let categoryPopoverCtrl = FilterViewController()
        
        self.addChildViewController(categoryPopoverCtrl)
        self.view.addSubview(categoryPopoverCtrl.view)
//        self.presentViewController(categoryPopoverCtrl, animated: true, completion: nil)
//        let popoverPresentationController = categoryPopoverCtrl.popoverPresentationController
//        popoverPresentationController?.sourceView = sender.view
//        popoverPresentationController?.delegate = self
    }
    
    // Prepare Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "discountWebViewSegue" {
            let annotationviewController = sender as! MapDiscountDetailViewController
            let destinationCtrl = segue.destinationViewController as! PostWebViewController
            //let annotation = annotationview.annotation as! DiscountAnnotation
            destinationCtrl.webRequestURLString = annotationviewController.discount!.link!
            destinationCtrl.navigationItem.setRightBarButtonItem(nil, animated: true)
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let postsUpdateUtility = PostsUpdateUtility()
        let keyWords = searchBar.text
        postsUpdateUtility.searchDiscountByKeyWords(keyWords!) { (discounts) in
            self.discounts = discounts
            
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
    
    func addDiscountDetailViewController(discountDetailViewController:MapDiscountDetailViewController){
        
        discountDetailViewController.showed = true
        addBasicEaseAnimationToView(discountDetailViewController.view)
        discountDetailViewController.modalTransitionStyle = .CoverVertical
        self.addChildViewController(discountDetailViewController)
        var viewRect:CGRect!

        viewRect = CGRectMake(0.0, CGRectGetHeight(self.mapView.frame)-75.0, CGRectGetWidth(self.mapView.frame), 75.0)
        discountDetailViewController.view.frame = viewRect
        
        self.mapView.addSubview(discountDetailViewController.view)
        discountDetailViewController.didMoveToParentViewController(self)
        
    }
    
    func removeDiscountDetailViewController(discountDetailViewController:MapDiscountDetailViewController) {
        addBasicEaseAnimationToView(discountDetailViewController.view)
        discountDetailViewController.showed = false
        discountDetailViewController.willMoveToParentViewController(nil)
        discountDetailViewController.view.removeFromSuperview()
        discountDetailViewController.removeFromParentViewController()
    }
    
    func addBasicEaseAnimationToView(view:UIView){
        UIView.animateWithDuration(0.3) {
            let amount = CGFloat(97.0)
            let positionY = CGRectGetHeight(self.mapView.frame)-75.0
            print(view.frame.origin.y)
            print(positionY)
            if view.frame.origin.y != positionY {
                view.frame = CGRectOffset(view.frame, 0, -amount)
            } else {
                print("remove")
                view.frame = CGRectOffset(view.frame, 0, amount)
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    

}
