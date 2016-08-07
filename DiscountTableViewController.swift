//
//  DiscountTableViewController.swift
//  Melmel
//
//  Created by WuKaipeng on 19/05/2016.
//  Copyright © 2016 Melmel. All rights reserved..
//

import UIKit
import CoreData

class DiscountTableViewController: UITableViewController,FilterPassValueDelegate{
    
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
   // var discountList=[(Discount,UIImage)]()
    var discounts:[Discount] = []
    var filteredDiscounts:[Discount] = []
    
    var reachabilityManager = ReachabilityManager.sharedReachabilityManager
    var isLoading = false
    let pendingOperations = PendingOperations()
    var alert = Alert()
    
    var categoryInt:String?
    var filtered = false
    
    var numOfDiscounts:Int?
    var reachToTheEnd = false

    @IBOutlet weak var loadMorePostsLabel: UILabel!
    @IBOutlet weak var LoadMoreActivityIndicator: UIActivityIndicatorView!
    
    var FilteredViewController:FilterViewController = FilterViewController()
    
    
    @IBAction func didFilterButtonPress(sender: AnyObject) {
        
        //  FilteredViewController.view.viewWithTag(101)
        
        
        if (FilteredViewController.view.tag == 100) {
            //  if (FilteredViewController.view != nil){
            FilteredViewController.view.tag = 101
            FilteredViewController.view.removeFromSuperview()
            print ("aprilllll")
        }
        else{
            print ("aaaaaaaaaaaaaaa")
            FilteredViewController.delegate = self
            FilteredViewController.view.tag = 100
            self.addChildViewController(FilteredViewController)
            //  FilteredViewController.view.frame = CGRectMake(0.0, self.view.frame.height-74.0, self.view.frame.width, 74.0)
            //   FilteredViewController.view.center = CGPoint(FilteredViewController.view.x + self.view.conten)
            
            self.view.addSubview(FilteredViewController.view)
        }
        
        
    }
    
    func UserDidFilterCategory(catergoryInt: String, FilteredBool: Bool) {
        print ("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print(catergoryInt)
        print(FilteredBool)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = GLOBAL_TINT_COLOR
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: #selector(self.updateDiscounts), forControlEvents: .ValueChanged)
        self.refreshControl?.beginRefreshing()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.discounts.removeAll()
        if self.filtered == false{
//        let discountUpdateUtility = PostsUpdateUtility()
//        discounts = discountUpdateUtility.fetchDiscounts()
        
        self.updateDiscounts()
        
        self.categoryInt = "canLoadMore"
        if self.reachToTheEnd == false{
            self.loadMorePostsLabel.hidden = false
            self.LoadMoreActivityIndicator.hidden = false
        }
        self.tableView.reloadData()
        }
        else{
            self.filtered = false
            tableView.scrollEnabled = false
            self.filterCategory()
        }
      
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return discounts.count
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (self.categoryInt == "canLoadMore"){
        if (indexPath.row == discounts.count-1) && !isLoading{
            isLoading = true
            if reachToTheEnd == false{
                self.LoadMoreActivityIndicator.hidden = false
                self.LoadMoreActivityIndicator.startAnimating()
            
                self.loadMorePostsLabel.text = "加载中……"
                let oldestPost = discounts[indexPath.row]
                self.numOfDiscounts = self.discounts.count
                loadPreviousPosts(oldestPost.date!,excludeId: oldestPost.id as! Int)
            }
        }
        }
//        else{
//         //   self.categoryInt = "unlockFilter" 1
//        }
    }
    
    func loadPreviousPosts(oldestPostDate:NSDate,excludeId:Int){
        
        if reachabilityManager.isReachable(){
            
            let postsUpdateUtility = PostsUpdateUtility()
            postsUpdateUtility.getPreviousDiscounts(oldestPostDate,excludeId: excludeId) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.discounts = postsUpdateUtility.fetchDiscounts()
                    self.tableView.reloadData()
                    self.isLoading = false
                    self.LoadMoreActivityIndicator.stopAnimating()
                    self.LoadMoreActivityIndicator.hidden = true
                    
                    if self.numOfDiscounts == self.discounts.count{
                        self.reachToTheEnd = true
                        self.loadMorePostsLabel.hidden = true
                        self.LoadMoreActivityIndicator.hidden = true
                    }
                })
            }
        } else {
            alert.showAlert(self)
            self.isLoading = false
        }
        
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("discountCell", forIndexPath: indexPath) as! DiscountTableViewCell
        
        // Configure the cell...
        let discount  = discounts[indexPath.row]
        cell.titleLabel.text = discount.title!
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        cell.dateLabel.text = "\(dateFormatter.stringFromDate(discount.date!).uppercaseString)" + " "
        
        
        
        // Configure featured image
        
        if discount.featured_image_downloaded == true {
            let fileDownloader = FileDownloader()
            discount.featuredImage = fileDownloader.imageFromFile(discount.id! as Int, fileName: FEATURED_IMAGE_NAME)
            discount.featuredImageState = .Downloaded
        } else {
            if discount.featured_image_url != nil {
                if discount.featuredImageState == .Downloaded {
                    
                }
                if discount.featuredImageState == .New {
                    if (!tableView.dragging && !tableView.decelerating){
                        startOperationsForPhoto(discount, indexPath: indexPath)
                    }
                }
                
            }
            
        }
       // cell.featureImage.contentMode = .ScaleAspectFit
        cell.featureImage.image = discount.featuredImage
        
        
        
        
        return cell;
    }
    
    func startOperationsForPhoto(discount:Discount,indexPath:NSIndexPath) {
        switch (discount.featuredImageState) {
        case .New:
            startDownloadFeaturedImageForPost (discount:discount,indexPath:indexPath)
        default:
            NSLog("Do nothing")
        }
    }
    
    func startDownloadFeaturedImageForPost(discount discount:Discount,indexPath:NSIndexPath) {
        if pendingOperations.downloadsInProgress[indexPath] != nil {
            return
        }
        
        if reachabilityManager.isReachable(){
        let downloader = DiscountImageDownloader(discount: discount)
        
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                discount.featuredImageState = .Downloaded
            })
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
            
        }
    }
    
    
    
    func updateDiscounts(){
        
        if reachabilityManager.isReachable(){
            print ("hello Please ")
            print("is Reachable")
            let postUpdateUtility = PostsUpdateUtility()
            postUpdateUtility.updateDiscounts {
                
                dispatch_async(dispatch_get_main_queue(), {
                    print("Update table view")
                    self.discounts = postUpdateUtility.fetchDiscounts()
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
            }
        } else {
            print("No Internet Connection")
            self.refreshControl?.endRefreshing()
          //  popUpWarningMessage("No Internet Connection")
          //  self.showAlert()
            alert.showAlert(self)
            
            
        }
        
        
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        suspendAllOperations()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            loadImageForOnScreenCells()
            resumeAllOperations()
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        loadImageForOnScreenCells()
        resumeAllOperations()
    }
    
    func suspendAllOperations(){
        pendingOperations.downloadQueue.suspended = true
    }
    
    func resumeAllOperations(){
        pendingOperations.downloadQueue.suspended = false
    }
    
    func loadImageForOnScreenCells(){
        if let pathsArray = tableView.indexPathsForVisibleRows{
            
            var allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray as! [NSIndexPath])
            toBeCancelled.subtractInPlace(visiblePaths)
            
            var toBeStarted = visiblePaths
            toBeStarted.subtractInPlace(allPendingOperations)
            
            for indexPath in toBeCancelled{
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath]{
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                
            }
            
            for indexPath in toBeStarted{
                let indexPath = indexPath as NSIndexPath
                let recordToProcess = self.discounts[indexPath.row]
                startOperationsForPhoto(recordToProcess, indexPath: indexPath)         
            }
            
        }
    }
    

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
//    func showAlert(){
//        
//                let attributedString = NSAttributedString(string: "请检查你的网络", attributes: [
//            NSFontAttributeName : UIFont.systemFontOfSize(20),
//            NSForegroundColorAttributeName : UIColor.whiteColor()
//            ])
//        
//        
//        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .Alert)
//        self.presentViewController(alertController, animated: true, completion: nil)
//        alertController.setValue(attributedString, forKey: "attributedMessage")
//        
//        
//        let subview :UIView = alertController.view.subviews.last! as UIView
//        let alertContentView = subview.subviews.last! as UIView
//        alertContentView.backgroundColor = UIColor(red: 252/255, green: 50/255, blue: 0/255, alpha: 1.0)
//        alertContentView.layer.cornerRadius = 10
//     
//        
//        let delay = 2.0 * Double(NSEC_PER_SEC)
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//        dispatch_after(time, dispatch_get_main_queue(), {
//            alertController.dismissViewControllerAnimated(true, completion: nil)
//        })
//    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "discountSegue" {
            let postWebVeiwController = segue.destinationViewController as! PostWebViewController
            let path = tableView.indexPathForSelectedRow!
            postWebVeiwController.webRequestURLString = discounts[path.row].link
            postWebVeiwController.navigationItem.setRightBarButtonItem(nil, animated: true)
        }
    }
    
    func filterCategory() {
        self.discounts.removeAll()
        let endpointURL = "http://melmel.com.au/wp-json/wp/v2/discounts?filter[posts_per_page]=-1&item_category="
        
        self.updateFilterDiscounts(endpointURL){
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.tableView.scrollEnabled = true
                self.loadMorePostsLabel.hidden = true
                self.LoadMoreActivityIndicator.hidden = true
            })
        }
    }
    
    func getPostsFromAPI (endURL:String,postsAcquired:(postsArray: NSArray?, success: Bool) -> Void ){
        
        let session = NSURLSession.sharedSession()
        let postUrl = endURL + self.categoryInt!
        print (postUrl)
        let postFinalURL = NSURL(string: postUrl)!
        
        
        
        session.dataTaskWithURL(postFinalURL){ (data:NSData?, response:NSURLResponse?, error: NSError?) -> Void in
            
            if let responseData = data {
                
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                    if let postsArray = json as? NSArray{
                        postsAcquired(postsArray:postsArray,success:true)
                    }
                    else {
                        postsAcquired(postsArray:nil,success:false)
                    }
                } catch {
                    postsAcquired(postsArray:nil,success:false)
                    print("could not serialize!")
                }
            }
            }.resume()
        
        
    }
    
    func updateFilterDiscounts(endURL:String, completionHandler:() -> Void){
        
        
        self.getPostsFromAPI(endURL) { (postsArray, success) in
            if success {
                
                
                // create dispatch group
                
                for postEntry in postsArray! {
                    let post = NSEntityDescription.insertNewObjectForEntityForName("Discount", inManagedObjectContext: self.managedObjectContext) as! Discount
                    //id
                    post.id = postEntry["id"] as! Int
                    
                    //Date
                    let dateString = postEntry["date"] as! String
                    let dateFormatter = DateFormatter()
                    post.date = dateFormatter.formatDateStringToMelTime(dateString)
                    //Title
                    post.title = postEntry["title"] as! String
                    
                    //Link
                    post.link = postEntry["link"] as! String
                    
                    //Media
                    
                    post.featured_image_downloaded = false
                    
                    if postEntry["featured_image_url"] != nil {
                        post.featured_image_url = postEntry["thumbnail_url"] as? String
                    }
                    
                    
                    self.discounts.append(post)
                    
                }//End postsArray Loop
                completionHandler()
                
            }
            else {}
        } // end getPostsFromAPI
        
        
    }
 

}
