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
    
    
    let catVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "testid") as? CategoryTableViewController
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var categoryInt = ""
    var filtered = false
    
    let regionRadius: CLLocationDistance = 1000
    let melbourneLocation = CLLocation(latitude: -37.8136, longitude: 144.9631)
    var locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
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
        
        let searchTextField = searchBar.value(forKey: "searchField") as! UITextField
        let color = UIColor(red: 242.0/255.0, green: 109.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "例如：韩餐，日餐", attributes: [NSForegroundColorAttributeName:color])
        
        
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
    
    override func viewDidAppear(_ animated: Bool) {

        self.navigationController?.hidesBarsOnSwipe = false
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setupBlankView(){
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        let searchBarHeight = self.searchBar.bounds.height
        
        //  var blankView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        blankView.frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        blankView.backgroundColor = UIColor.black
        blankView.alpha = 0.5
        self.view.addSubview(blankView)
        self.blankView.isHidden = true
        
        searchBlankView.frame = CGRect(x: 0.0, y: searchBarHeight, width: width, height: height)
        searchBlankView.backgroundColor = UIColor.black
        searchBlankView.alpha = 0.5
        self.view.addSubview(searchBlankView)
        self.searchBlankView.isHidden = true
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBlankView.isHidden = false
    }
    
    func handleTap(){
        self.searchBlankView.isHidden = true
        self.searchBar.resignFirstResponder()
        
    }
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(_ location:CLLocation, zoomLevel:Double) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * zoomLevel, regionRadius * zoomLevel)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if userLocation.location != nil{
            self.userLocation = userLocation.location
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        OperationQueue().addOperation { 
            let mapBoundsWidth = Double(self.mapView.bounds.size.width)
            let mapRectWidth:Double = self.mapView.visibleMapRect.size.width
            let scale:Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale:scale)
            self.clusteringManager.displayAnnotations(annotationArray, onMapView:self.mapView)
        }
    }

    
    
    /*  Configure annotation view */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var reuseId = ""
        
        if annotation.isKind(of: FBAnnotationCluster.self){
            reuseId = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, options: nil)
            return clusterView
        }else if annotation.isKind(of: MKUserLocation.self) {
            return nil
        } else if annotation.isKind(of: DiscountAnnotation.self){
            let discountAnnotation = annotation as! DiscountAnnotation
            let annotationView = DiscountAnnotationView(annotation: annotation, reuseIdentifier: nil,delegate: self)
            var annotationViewImgFilename = ""
            if discountAnnotation.discount!.catagories[0] == .shopping{
                annotationViewImgFilename = AnnotationPinImg.Shopping.rawValue
            }
            if discountAnnotation.discount!.catagories[0] == .entertainment {
                annotationViewImgFilename = AnnotationPinImg.Entertainment.rawValue
            }
            if discountAnnotation.discount!.catagories[0] == .food {
                annotationViewImgFilename = AnnotationPinImg.Food.rawValue
            }
            if discountAnnotation.discount!.catagories[0] == .service {
                annotationViewImgFilename = AnnotationPinImg.Service.rawValue
            }
            if discountAnnotation.discount!.catagories[0] == .fashion {
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
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegue(withIdentifier: "discountWebViewSegue", sender: view)
    }
    
    func createAnnotationObject(_ discountForAnnotation:Discount) -> DiscountAnnotation{
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
            
            DispatchQueue.main.async(execute: { 
                self.locationAuthStatus()
                // load discounts from core data
                self.loadDiscountFromCoreData()
                
                for discount in self.discounts {
                    // Add Annotations
                    let annotation = self.createAnnotationObject(discount)
                    self.mapView.addAnnotation(annotation as MKAnnotation)
                }
            })
            
        }
    }
    
    @IBAction func currentLocation(_ sender: AnyObject) {
        if userLocation != nil {
            centerMapOnLocation(userLocation!,zoomLevel: 2.0)
        }
    }
    
    @IBAction func showCategoryPopover(_ sender: UIBarButtonItem) {
        
//
//        self.addChildViewController(categoryPopoverCtrl)
//        self.view.addSubview(categoryPopoverCtrl.view)
//        self.presentViewController(categoryPopoverCtrl, animated: true, completion: nil)
        self.blankView.isHidden = false
        categoryPopoverCtrl.modalPresentationStyle = .popover
        let popover = categoryPopoverCtrl.popoverPresentationController!
        categoryPopoverCtrl.preferredContentSize = CGSize(width: 400, height: 113.0)
        popover.barButtonItem = sender
        popover.popoverLayoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        popover.delegate = self
        present(categoryPopoverCtrl, animated: true, completion: nil)
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.blankView.isHidden = true
    }
    
    // Implement Popover Ctrl Delegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    // Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "discountWebViewSegue" {
            let annotationviewController = sender as! MapDiscountDetailViewController
            let destinationCtrl = segue.destination as! PostWebViewController
            //let annotation = annotationview.annotation as! DiscountAnnotation
            destinationCtrl.webRequestURLString = annotationviewController.discount!.link!
            destinationCtrl.navigationItem.setRightBarButton(nil, animated: true)
            destinationCtrl.navigationItem.title = "墨尔本优惠"
            
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let activityIndicatorRect = CGRect(x: 0, y: 0, width: 100.0, height: 80.0)
        let activityInidicatorView = CustomActivityIndicatorView(frame: activityIndicatorRect)
        self.view.addSubview(activityInidicatorView)
        let postsUpdateUtility = PostsUpdateUtility()
        let keyWords = searchBar.text
        postsUpdateUtility.searchDiscountByKeyWords(keyWords!) { (discounts) in
            self.discounts = discounts
            
            self.addAnnotationViewsForDiscounts(discounts)
            activityInidicatorView.stopAnimating()
            activityInidicatorView.willMove(toSuperview: self.view)
        }
        searchBar.resignFirstResponder()
        self.searchBlankView.isHidden = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    
    
    func addAnnotationViewsForDiscounts(_ discounts:[Discount]){
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
    
    func addDiscountDetailViewController(_ discountDetailViewController:MapDiscountDetailViewController){
        
        discountDetailViewController.showed = true
        AnimationEngine.addEaseInFromBottomAnimationToView(discountDetailViewController.view)
        discountDetailViewController.modalTransitionStyle = .coverVertical
        self.addChildViewController(discountDetailViewController)
        var viewRect:CGRect!
        
        

        viewRect = CGRect(x: 0.0, y: self.mapView.frame.height-80.5, width: self.mapView.frame.width, height: 80.5)
        discountDetailViewController.view.frame = viewRect
        
        self.view.addSubview(discountDetailViewController.view)
        discountDetailViewController.didMove(toParentViewController: self)
        
    }
    
    func removeDiscountDetailViewController(_ discountDetailViewController:MapDiscountDetailViewController) {
        AnimationEngine.addEaseOutToBottomAnimationToView(discountDetailViewController.view)
        discountDetailViewController.showed = false
        discountDetailViewController.willMove(toParentViewController: nil)
        discountDetailViewController.view.removeFromSuperview()
        discountDetailViewController.removeFromParentViewController()
    }
    
    func loadAllDiscount(){
        let postUpdateUtility = PostsUpdateUtility()
        
        
        //let loadingAlert = LoadingAlertController(title: "", message: nil, preferredStyle: .Alert)
        //self.addChildViewController(loadingAlert)
        //presentViewController(loadingAlert, animated: true, completion: nil)
        //loadingAlert.activityIndicatorView.center = loadingAlert.view.center
        let activityIndicatorRect = CGRect(x: 0, y: 0, width: 100.0, height: 80.0)
        let activityInidicatorView = CustomActivityIndicatorView(frame: activityIndicatorRect)
        self.view.addSubview(activityInidicatorView)
        
        postUpdateUtility.getAllDiscounts({ (discounts) in
            
            
            self.addAnnotationViewsForDiscounts(discounts)
            self.centerMapOnLocation(self.melbourneLocation, zoomLevel: 10.0)
            activityInidicatorView.stopAnimating()
            activityInidicatorView.willMove(toSuperview: self.view)
            
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
        self.blankView.isHidden = true
        self.filtered = false
        self.loadAllDiscount()
    }
    func didEntertainment() {
        self.blankView.isHidden = true
        catVC?.catID = 1
        self.navigationController?.pushViewController(catVC!, animated: true)
    }
    func didFashion() {
        self.blankView.isHidden = true
        catVC?.catID = 2
        self.navigationController?.pushViewController(catVC!, animated: true)
    }
    func didService() {
        self.blankView.isHidden = true
        catVC?.catID = 3
        self.navigationController?.pushViewController(catVC!, animated: true)
    }
    
    func didFood(){
        self.blankView.isHidden = true
        catVC?.catID = 4
        self.navigationController?.pushViewController(catVC!, animated: true)
    }
    func didShopping() {
        self.blankView.isHidden = true
        catVC?.catID = 5
        self.navigationController?.pushViewController(catVC!, animated: true)
    }
    func UserDidFilterCategory(_ catergoryInt: String, FilteredBool: Bool) {
        
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
        let activityIndicatorRect = CGRect(x: 0, y: 0, width: 100.0, height: 80.0)
        let activityInidicatorView = CustomActivityIndicatorView(frame: activityIndicatorRect)
        self.view.addSubview(activityInidicatorView)
        let postUpdateUtility = PostsUpdateUtility()
        postUpdateUtility.updateFilterDiscounts(self.categoryInt) { (filteredDiscounts, success) in
            if success {
                self.discounts = filteredDiscounts
                DispatchQueue.main.async(execute: {
                    self.addAnnotationViewsForDiscounts(self.discounts)
                    activityInidicatorView.stopAnimating()
                    activityInidicatorView.willMove(toSuperview: self.view)
                    
                })
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
