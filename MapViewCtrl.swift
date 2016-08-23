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
//    let exampleTransitionDelegate = Example
    
    
    let catVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("testid") as? CategoryTableViewController
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var categoryInt = ""
    var filtered = false
    
    let regionRadius: CLLocationDistance = 1000
    let melbourneLocation = CLLocation(latitude: -37.8136, longitude: 144.9631)
    var locationManager = (UIApplication.sharedApplication().delegate as! AppDelegate).locationManager
    var discounts:[Discount] = []
    
    
    var clusteringManager = FBClusteringManager()
    
    let categoryPopoverCtrl = FilterViewController()
    
    var userLocation:CLLocation?
    
    var blankView = UIView()
    
    var searchBlankView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate=self
        searchBar.delegate = self
        categoryPopoverCtrl.delegate = self
        catVC!.delegate = self
        categoryPopoverCtrl.catVC = catVC
        
        
        setupBlankView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MapViewCtrl.handleTap))
        self.searchBlankView.addGestureRecognizer(tap)
        
        let searchTextField = searchBar.valueForKey("searchField") as! UITextField
        let color = UIColor(red: 242.0/255.0, green: 109.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "例如：韩国餐馆折扣", attributes: [NSForegroundColorAttributeName:color])
        
        
//        
//        let melmelAnnotation = MKPointAnnotation()
//        melmelAnnotation.coordinate = CLLocation(latitude: -37.846904, longitude: 144.978653).coordinate
//        melmelAnnotation.title = "Melmel"
//        melmelAnnotation.subtitle = "416/566 St. Kilda Road, St. Kilda, VIC, 3004"
//        mapView.addAnnotation(melmelAnnotation)
        locationAuthStatus()
        // load discounts from core data
        //loadDiscountFromCoreData()
        
        
//        discountDetailView = NSBundle.mainBundle().loadNibNamed("MapDiscountDetailView", owner: self, options: nil)[0] as? MapDiscountDetailView
//        discountDetailView.center = CGPoint(x: 0.0, y: 0.0)
//        self.mapView.addSubview(discountDetailView)
        
        //addDiscountDetailViewController()
        loadAllDiscount()
        
    }
    
    override func viewDidAppear(animated: Bool) {

        self.navigationController?.hidesBarsOnSwipe = false
        
    }
    
    func setupBlankView(){
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        let searchBarHeight = self.searchBar.bounds.height
        
        //  var blankView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        blankView.frame = CGRectMake(0.0, 0.0, width, height)
        blankView.backgroundColor = UIColor.blackColor()
        blankView.alpha = 0.5
        self.view.addSubview(blankView)
        self.blankView.hidden = true
        
        searchBlankView.frame = CGRectMake(0.0, searchBarHeight, width, height)
        searchBlankView.backgroundColor = UIColor.blackColor()
        searchBlankView.alpha = 0.5
        self.view.addSubview(searchBlankView)
        self.searchBlankView.hidden = true
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBlankView.hidden = false
    }
    
    func handleTap(){
        self.searchBlankView.hidden = true
        self.searchBar.resignFirstResponder()
        
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
    
    @IBAction func showCategoryPopover(sender: UIBarButtonItem) {
        
//
//        self.addChildViewController(categoryPopoverCtrl)
//        self.view.addSubview(categoryPopoverCtrl.view)
//        self.presentViewController(categoryPopoverCtrl, animated: true, completion: nil)
        categoryPopoverCtrl.modalPresentationStyle = .Popover
        let popover = categoryPopoverCtrl.popoverPresentationController!
        categoryPopoverCtrl.preferredContentSize = CGSizeMake(400, 113.0)
        popover.barButtonItem = sender
        popover.popoverLayoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        popover.delegate = self
        presentViewController(categoryPopoverCtrl, animated: true, completion: nil)
    }
    
    // Implement Popover Ctrl Delegate
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
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
        self.searchBlankView.hidden = true
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
        AnimationEngine.addEaseInFromBottomAnimationToView(discountDetailViewController.view)
        discountDetailViewController.modalTransitionStyle = .CoverVertical
        self.addChildViewController(discountDetailViewController)
        var viewRect:CGRect!
        
        

        viewRect = CGRectMake(0.0, CGRectGetHeight(self.mapView.frame)-80.5, CGRectGetWidth(self.mapView.frame), 80.5)
        discountDetailViewController.view.frame = viewRect
        
        self.view.addSubview(discountDetailViewController.view)
        discountDetailViewController.didMoveToParentViewController(self)
        
    }
    
    func removeDiscountDetailViewController(discountDetailViewController:MapDiscountDetailViewController) {
        AnimationEngine.addEaseOutToBottomAnimationToView(discountDetailViewController.view)
        discountDetailViewController.showed = false
        discountDetailViewController.willMoveToParentViewController(nil)
        discountDetailViewController.view.removeFromSuperview()
        discountDetailViewController.removeFromParentViewController()
    }
    
    func loadAllDiscount(){
        let postUpdateUtility = PostsUpdateUtility()
        
        
        //let loadingAlert = LoadingAlertController(title: "", message: nil, preferredStyle: .Alert)
        //self.addChildViewController(loadingAlert)
        //presentViewController(loadingAlert, animated: true, completion: nil)
        //loadingAlert.activityIndicatorView.center = loadingAlert.view.center
        let activityIndicatorRect = CGRectMake(0, 0, 100.0, 80.0)
        let activityInidicatorView = CustomActivityIndicatorView(frame: activityIndicatorRect)
        self.view.addSubview(activityInidicatorView)
        
        postUpdateUtility.getAllDiscounts({ (discounts) in
            
            
            self.addAnnotationViewsForDiscounts(discounts)
            self.centerMapOnLocation(self.melbourneLocation, zoomLevel: 10.0)
            activityInidicatorView.stopAnimating()
            activityInidicatorView.willMoveToSuperview(self.view)
            
        })
    }
    
    

}


/* 
 Implementation of FilterViewControllerDelegate
 */
extension MapViewCtrl:FilterViewControllerDelegate,FilterPassValueDelegate {
    func ShouldCloseSubview() {
    }
    func didFindAll(){
        self.filtered = false
        self.loadAllDiscount()
    }
    func didEntertainment() {
        catVC?.catID = 1
        self.navigationController?.pushViewController(catVC!, animated: true)
    }
    func didFashion() {
        catVC?.catID = 2
        self.navigationController?.pushViewController(catVC!, animated: true)
    }
    func didService() {
        catVC?.catID = 3
        self.navigationController?.pushViewController(catVC!, animated: true)
    }
    
    func didFood(){
        catVC?.catID = 4
        self.navigationController?.pushViewController(catVC!, animated: true)
    }
    func didShopping() {
        catVC?.catID = 5
        self.navigationController?.pushViewController(catVC!, animated: true)
    }
    func UserDidFilterCategory(catergoryInt: String, FilteredBool: Bool) {
        
        self.categoryInt = catergoryInt
        self.filtered = FilteredBool
        if self.filtered == false{
            
        }
        else{
            print ("filter is \(self.filtered)")
            self.discounts.removeAll()
            // self.filtered = false
            self.updateFilteredDiscounts()
        }
        
    }
    
    func updateFilteredDiscounts(){
        let postUpdateUtility = PostsUpdateUtility()
        postUpdateUtility.updateFilterDiscounts(self.categoryInt) { (filteredDiscounts, success) in
            if success {
                self.discounts = filteredDiscounts
                dispatch_async(dispatch_get_main_queue(), {
                    self.addAnnotationViewsForDiscounts(self.discounts)
                })
            }
        }
    }
}
