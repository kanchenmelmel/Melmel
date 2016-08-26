//
//  DiscountTableViewController.swift
//  Melmel
//
//  Created by WuKaipeng on 19/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import CoreData

class DiscountTableViewController: UITableViewController,FilterPassValueDelegate,FilterViewControllerDelegate,UISearchBarDelegate,UIPopoverPresentationControllerDelegate{
    
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // var discountList=[(Discount,UIImage)]()
    var discounts:[Discount] = []
    //var filteredDiscounts:[Discount] = []
    
    var reachabilityManager = ReachabilityManager.sharedReachabilityManager
    var isLoading = false
    let pendingOperations = PendingOperations()
    var alert = Alert()
    
    var categoryInt:String?
    var filtered = false
    
    var numOfDiscounts:Int?
    var reachToTheEnd = false
    
    var positionY : CGFloat = 0
    
    @IBOutlet weak var loadMorePostsLabel: UILabel!
    @IBOutlet weak var LoadMoreActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredViewController:FilterViewController = FilterViewController()
    
    let catVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("testid") as? CategoryTableViewController
    
    // var blankView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
    
    var blankView = UIView()
    
    var searchBlankView = UIView()
    
    let activityIndicatorView = CustomActivityIndicatorView(frame: CGRectMake(0, 0, 100, 80))
    
    @IBAction func didFilterButtonPress(sender: UIBarButtonItem) {
        
        
        //        let filterViewController = FilterViewController()
        
        self.blankView.hidden = false
        
        filteredViewController.modalPresentationStyle = .Popover
        filteredViewController.preferredContentSize = CGSizeMake(400.0, 113.0)
        let popover = filteredViewController.popoverPresentationController!
        popover.barButtonItem = sender
        popover.delegate = self
        presentViewController(filteredViewController, animated: true, completion: nil)
        
        
        
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        self.blankView.hidden = true
    }
    
    
    
    // Implement Popover Ctrl Delegate
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    //    override func scrollViewDidScroll(scrollView: UIScrollView) {
    //
    //        var frame: CGRect = self.filteredViewController.view.frame
    //        positionY = scrollView.contentOffset.y
    //        frame.origin.y = positionY
    //        self.filteredViewController.view.frame = frame
    //        self.view.bringSubviewToFront(self.filteredViewController.view)
    //
    //
    //
    //    }
    func ShouldCloseSubview() {
        
    }
    
    func UserDidFilterCategory(catergoryInt: String, FilteredBool: Bool) {
        
        self.categoryInt = catergoryInt
        self.filtered = FilteredBool
        if self.filtered == false{
            let postUpdateUtility = PostsUpdateUtility()
            discounts = postUpdateUtility.fetchDiscounts()
            self.updateDiscounts()
            
            self.categoryInt = "canLoadMore"
            if self.reachToTheEnd == false{
                self.loadMorePostsLabel.hidden = false
                self.LoadMoreActivityIndicator.hidden = false
            }
            self.tableView.reloadData()
            activityIndicatorView.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
            self.tableView.allowsSelection = true
           // activityIndicatorView.willMoveToSuperview(self.tableView)
        }
        else{
            print ("filter is \(self.filtered)")
            self.discounts.removeAll()
            // self.filtered = false
            tableView.scrollEnabled = false
            self.filterCategory()
        }
        
    }
    
    
    // Implement FilterPassValueDelegate
    func didFindAll(){
        self.activityIndicatorView.startAnimating()
        self.tableView.addSubview(activityIndicatorView)
        self.blankView.hidden = true
        self.filtered = false
        self.updateDiscounts()
        

        
    }
    
    func didEntertainment() {
        self.activityIndicatorView.startAnimating()
        self.tableView.addSubview(activityIndicatorView)
        self.blankView.hidden = true
        catVC?.catID = 1
        self.navigationController?.pushViewController(catVC!, animated: true)
    }
    func didFashion() {
        self.activityIndicatorView.startAnimating()
        self.tableView.addSubview(activityIndicatorView)
        self.blankView.hidden = true
        catVC?.catID = 2
        self.navigationController?.pushViewController(catVC!, animated: true)
    }
    func didService() {
        self.activityIndicatorView.startAnimating()
        self.tableView.addSubview(activityIndicatorView)
        self.blankView.hidden = true
        catVC?.catID = 3
        self.navigationController?.pushViewController(catVC!, animated: true)
    }
    
    func didFood(){
        self.activityIndicatorView.startAnimating()
        self.tableView.addSubview(activityIndicatorView)
        self.blankView.hidden = true
        catVC?.catID = 4
        self.navigationController?.pushViewController(catVC!, animated: true)
    }
    func didShopping() {
        self.activityIndicatorView.startAnimating()
        self.tableView.addSubview(activityIndicatorView)
        self.blankView.hidden = true
        catVC?.catID = 5
        self.navigationController?.pushViewController(catVC!, animated: true)
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBlankView.hidden = true
        self.tableView.scrollEnabled = true
        self.searchBar.resignFirstResponder()
        self.performSegueWithIdentifier("discountSearchResultSegue", sender: self.searchBar)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBlankView.hidden = false
        self.tableView.scrollEnabled = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBlankView.hidden = true
    }
    
    
    
    
    override func viewDidLoad() {
        
        resumeAllOperations()
        
        filteredViewController.delegate = self
        catVC?.delegate = self
        filteredViewController.catVC = catVC
        self.tableView.setContentOffset(CGPoint(x: 0,y:self.searchBar.bounds.height), animated: true)
        
        
        super.viewDidLoad()
        
        setupBlankView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DiscountTableViewController.handleTap))
        self.searchBlankView.addGestureRecognizer(tap)
        
        searchBar.delegate = self
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = GLOBAL_TINT_COLOR
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: #selector(self.updateDiscounts), forControlEvents: .ValueChanged)
        self.refreshControl?.beginRefreshing()
        
        
    }
    
    func handleTap(){
        self.searchBlankView.hidden = true
        self.searchBar.resignFirstResponder()
        self.tableView.scrollEnabled = true
        
    }
    
    func setupBlankView(){
        
        let width = self.tableView.frame.size.width
        let height = self.tableView.frame.size.height
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
        self.searchBlankView.hidden = true
        self.tableView.scrollEnabled = true
        
        
        activityIndicatorView.center = self.tableView.center
        self.activityIndicatorView.startAnimating()
        self.tableView.addSubview(activityIndicatorView)
        self.tableView.allowsSelection = false
        
        
        navigationController?.navigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = true
        if self.filtered == false{
            let postUpdateUtility = PostsUpdateUtility()
            discounts = postUpdateUtility.fetchDiscounts()
            self.updateDiscounts()
            
            self.categoryInt = "canLoadMore"
            if self.reachToTheEnd == false{
                self.loadMorePostsLabel.hidden = false
                self.LoadMoreActivityIndicator.hidden = false
            }
            self.tableView.reloadData()
        }
        else{
            print ("filter is \(self.filtered)")
            self.discounts.removeAll()
            // self.filtered = false
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
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.removeFromSuperview()
                    self.tableView.allowsSelection = true
                   // self.activityIndicatorView.willMoveToSuperview(self.tableView)
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
        print(discounts.count)
        let discount  = discounts[indexPath.row]
        
        // cell.contentView.alpha = 0.5
        
        cell.titleLabel.text = discount.title
        
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
        
        if discount.discountTag != nil {
            cell.discountTagLabel.text = discount.discountTag
        } else {
            cell.discountTagLabel.text = "墨尔本优惠"
        }
        
        print ("discount cater is \(discount.catagories[0])")
        if discount.catagories.count != 0 {
            cell.categoryLabel.hidden = false
            cell.categoryBackground.hidden = false
            var categoryBackgroundFileName = ""
            if discount.catagories[0] == .Shopping{
                
                cell.categoryLabel.text = "购物"
                categoryBackgroundFileName = "ShoppingTag"
            }else if discount.catagories[0] == .Food {
                
                cell.categoryLabel.text = "美食"
                categoryBackgroundFileName = "FoodTag"
                //print("yes")
            } else if discount.catagories[0] == .Service {
                
                cell.categoryLabel.text = "服务"
                categoryBackgroundFileName = "ServiceTag"
            }else if discount.catagories[0] == .Fashion{
                
                cell.categoryLabel.text = "时尚"
                categoryBackgroundFileName = "FashionTag"
                
            }else if discount.catagories[0] == .Entertainment{
                cell.categoryLabel.text = "娱乐"
                categoryBackgroundFileName = "EntertainmentTag"
            } else {
                cell.categoryLabel.hidden = true
                cell.categoryBackground.hidden = true
                print("no")
            }
            //print(categoryBackgroundFileName)
            cell.categoryBackground.image = UIImage(named: categoryBackgroundFileName)
        } else {
            cell.categoryLabel.hidden = true
            cell.categoryBackground.hidden = true
        }
        
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
        
        if self.filtered == true{
            self.refreshControl?.endRefreshing()
            return
        }
        if reachabilityManager.isReachable(){
            print("is Reachable")
            let postUpdateUtility = PostsUpdateUtility()
            postUpdateUtility.updateDiscounts {
                
                dispatch_async(dispatch_get_main_queue(), {
                    print("Update table view")
                    self.discounts = postUpdateUtility.fetchDiscounts()
                    self.tableView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                    self.activityIndicatorView.removeFromSuperview()
                    self.tableView.allowsSelection = true
                   // self.activityIndicatorView.willMoveToSuperview(self.tableView)
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
            
            let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray )
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
        
        if segue.identifier == "discountSearchResultSegue" {
            let searchResultTableViewCtrl = segue.destinationViewController as! SearchTableViewController
            searchResultTableViewCtrl.searchText = self.searchBar.text
            searchResultTableViewCtrl.postType = .Discount
            
        }
    }
    
    func filterCategory() {
        self.discounts.removeAll()
        //let endpointURL = "http://melmel.com.au/wp-json/wp/v2/discounts?filter[posts_per_page]=-1&item_category="
        
        self.updateFilterDiscounts(){
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.removeFromSuperview()
                self.tableView.allowsSelection = true
               // self.self.activityIndicatorView.willMoveToSuperview(self.tableView)
                self.tableView.scrollEnabled = true
                self.loadMorePostsLabel.hidden = true
                self.LoadMoreActivityIndicator.hidden = true
            })
        }
    }
    
    //    func getPostsFromAPI (endURL:String,postsAcquired:(postsArray: NSArray?, success: Bool) -> Void ){
    //
    //        let session = NSURLSession.sharedSession()
    //        let postUrl = endURL + self.categoryInt!
    //        print (postUrl)
    //        let postFinalURL = NSURL(string: postUrl)!
    //
    //
    //
    //        session.dataTaskWithURL(postFinalURL){ (data:NSData?, response:NSURLResponse?, error: NSError?) -> Void in
    //
    //            if let responseData = data {
    //
    //                do{
    //                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
    //                    if let postsArray = json as? NSArray{
    //                        postsAcquired(postsArray:postsArray,success:true)
    //                    }
    //                    else {
    //                        postsAcquired(postsArray:nil,success:false)
    //                    }
    //                } catch {
    //                    postsAcquired(postsArray:nil,success:false)
    //                    print("could not serialize!")
    //                }
    //            }
    //            }.resume()
    //
    //
    //    }
    
    func updateFilterDiscounts(completionHandler:() -> Void){
        
        
        //        self.getPostsFromAPI(endURL) { (postsArray, success) in
        //            if success {
        //
        //
        //                // create dispatch group
        //
        //                for postEntry in postsArray! {
        //                    let post = NSEntityDescription.insertNewObjectForEntityForName("Discount", inManagedObjectContext: self.managedObjectContext) as! Discount
        //                    //id
        //                    post.id = postEntry["id"] as! Int
        //
        //                    //Date
        //                    let dateString = postEntry["date"] as! String
        //                    let dateFormatter = DateFormatter()
        //                    post.date = dateFormatter.formatDateStringToMelTime(dateString)
        //                    //Title
        //                    post.title = postEntry["title"] as! String
        //
        //                    //Link
        //                    post.link = postEntry["link"] as! String
        //
        //                    //Media
        //
        //                    post.featured_image_downloaded = false
        //                    
        //                    if postEntry["featured_image_url"] != nil {
        //                        post.featured_image_url = postEntry["thumbnail_url"] as? String
        //                    }
        //                    
        //                    
        //                    self.discounts.append(post)
        //                    
        //                }//End postsArray Loop
        //                completionHandler()
        //                
        //            }
        //            else {}
        //        } // end getPostsFromAPI
        let postUpdateUtility = PostsUpdateUtility()
        postUpdateUtility.updateFilterDiscounts(self.categoryInt!) { (filteredDiscounts, success) in
            if success {
                self.discounts = filteredDiscounts
            }
            completionHandler()
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        suspendAllOperations()
    }
    
    
}
