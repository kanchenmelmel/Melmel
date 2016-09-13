//
//  SearchTableViewController.swift
//  Melmel
//
//  Created by WuKaipeng on 11/06/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import CoreData


class SearchTableViewController: UITableViewController {
    
    var searchText:String?
    let endpointURL = "http://melmel.com.au/wp-json/wp/v2/posts?per_page=5&filter[s]="
    let end2pointURL = "http://melmel.com.au/wp-json/wp/v2/discounts?per_page=5&filter[s]="
    
    var postType:PostType!
    var discounts:[Discount] = []
    var posts:[Post] = []
    let pendingOperations = PendingOperations()
    
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    // var finalURL = endpointURL + searchText!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var navBarTitle = ""
        
        if postType == .Post{
            navBarTitle = "攻略搜索"
        } else {
            navBarTitle = "优惠搜索"
        }
        let textAttributes  = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = navBarTitle
        
        
        
        
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let postUpdateUtility = PostsUpdateUtility()
        
        let activityIndicatorView = CustomActivityIndicatorView(frame: CGRectMake(0, 0, 100, 80))
        
        self.tableView.addSubview(activityIndicatorView)
        
        if postType == .Discount {
            postUpdateUtility.searchDiscountByKeyWords(searchText!, completionHandler: { (discounts) in
                self.discounts = discounts
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    activityIndicatorView.stopAnimating()
                    activityIndicatorView.willMoveToSuperview(self.tableView)
                    }
                )
            })
        } else {
            postUpdateUtility.searchPostsByKeyWords(searchText!, completionHandler: { (posts) in
                self.posts = posts
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    activityIndicatorView.stopAnimating()
                    activityIndicatorView.willMoveToSuperview(self.tableView)
                })
            })
        }
        
        
        
        //        self.updateSearchPosts(self.endpointURL){
        //
        //            dispatch_async(dispatch_get_main_queue(), {
        //                print("Update table view")
        //                print(self.posts.count)
        //                self.tableView.reloadData()
        //
        //            })
        //        }
        
        //        self.updateSearchPosts(self.end2pointURL){
        //
        //            dispatch_async(dispatch_get_main_queue(), {
        //                print("Update table view")
        //                print(self.posts.count)
        //                self.tableView.reloadData()
        //
        //            })
        //        }
        //        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if postType == .Post{
            return posts.count
        } else {
            return discounts.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if postType == .Discount {
            let cell = tableView.dequeueReusableCellWithIdentifier("searchTableViewCell", forIndexPath: indexPath) as! SearchTableViewCell
            
            // Configure the cell...
            
            let discount = self.discounts[indexPath.row]
            cell.titleLabel.text = discount.title!
            //    cell.titleLabel.text = "testing"
            
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            cell.dateLabel.text = "\(dateFormatter.stringFromDate(discount.date!).uppercaseString)" + " "
            
            //            if entertianmentTypes.contains(catagoryId){
            //                return DiscountCatagory.Entertainment
            //            }
            //            if fashionTypes.contains(catagoryId){
            //                return DiscountCatagory.Fashion
            //            }
            //            if serviceTypes.contains(catagoryId){
            //                return DiscountCatagory.Service
            //            }
            //            if foodTypes.contains(catagoryId){
            //                return DiscountCatagory.Food
            //            }
            //            if shoppomgTypes.contains(catagoryId){
            //                return DiscountCatagory.Shopping
            //            }
            var categoryBackgroundFileName = ""
            print ("discount cater is \(discount.catagories[0])")
            switch discount.catagories[0] {
            case .Entertainment:
                cell.typeLabel.text = "娱乐"
                categoryBackgroundFileName = "EntertainmentTag"
            case .Fashion:
                cell.typeLabel.text = "时尚"
                categoryBackgroundFileName = "FashionTag"
            case .Service:
                cell.typeLabel.text = "服务"
                categoryBackgroundFileName = "ServiceTag"
            case .Food:
                cell.typeLabel.text = "美食"
                categoryBackgroundFileName = "FoodTag"
            case .Shopping:
                cell.typeLabel.text = "购物"
                categoryBackgroundFileName = "ShoppingTag"
            default:
                cell.typeLabel.text = "优惠"
            }
            cell.categoryTagBg.image = UIImage(named: categoryBackgroundFileName)
            
            
            
            
            
            
            
            if discount.featured_image_url != nil {
                if discount.featuredImageState == .Downloaded {
                    
                }
                if discount.featuredImageState == .New {
                    if (!tableView.dragging && !tableView.decelerating){
                        startOperationsForPhoto(discount: discount, indexPath: indexPath)
                    }
                }
                cell.featureImage.image = discount.featuredImage
                
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! SearchPostCell
            
            let  post = self.posts[indexPath.row]
            
            
            
            cell.titleLabel.text = post.title!
            
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            cell.dateLabel.text = "\(dateFormatter.stringFromDate(post.date!).uppercaseString)" + " "
            
            if post.featured_image_url != nil {
                if post.featuredImageState == .Downloaded {
                    // Wrong way to do
                    //cell.featuredImage.image = post.featuredImage
                }
                if post.featuredImageState == .New {
                    if (!tableView.dragging && !tableView.decelerating){
                        startOperationsForPhoto(post: post, indexPath: indexPath)
                    }
                }
                
            }
            
            //correct way to do
            cell.featuredImage.image = post.featuredImage
            return cell
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "postWebSegue" {
            let postWebVeiwController = segue.destinationViewController as! PostWebViewController
            let path = tableView.indexPathForSelectedRow!
            postWebVeiwController.webRequestURLString = posts[path.row].link
            postWebVeiwController.navigationItem.title = "原创攻略"
            postWebVeiwController.postid = String(posts[path.row].id!)
        }
        if segue.identifier == "disocuntWebSegue" {
            let postWebVeiwController = segue.destinationViewController as! PostWebViewController
            let path = tableView.indexPathForSelectedRow!
            postWebVeiwController.webRequestURLString = discounts[path.row].link
            postWebVeiwController.navigationItem.title = "墨尔本优惠"
            postWebVeiwController.navigationItem.setRightBarButtonItem(nil, animated: true)
        }
    }
    
    
    
    /*
     Image Downloader operation functions for Post
     */
    func startOperationsForPhoto(post post:Post,indexPath:NSIndexPath) {
        switch (post.featuredImageState) {
        case .New:
            startDownloadFeaturedImageForPost (post:post,indexPath:indexPath)
        default:
            NSLog("Do nothing")
        }
    }
    
    
    /*
     Image Downloader operation functions for Post
     */
    func startDownloadFeaturedImageForPost(post post:Post,indexPath:NSIndexPath) {
        if pendingOperations.downloadsInProgress[indexPath] != nil {
            return
        }
        
        
        let downloader = SearchImageDownloader(post: post)
        
        
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                post.featuredImageState = .Downloaded
            })
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    
    /*
     Image Downloader operation functions for Discount
     */
    
    func startOperationsForPhoto(discount discount:Discount,indexPath:NSIndexPath) {
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
        
        let downloader = SearchDiscountImageDownloader(discount: discount)
        
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
                
                if postType == .Discount{
                    let indexPath = indexPath as NSIndexPath
                    let recordToProcess = self.discounts[indexPath.row]
                    startOperationsForPhoto(discount: recordToProcess, indexPath: indexPath)
                } else {
                    let indexPath = indexPath as NSIndexPath
                    let recordToProcess = self.posts[indexPath.row]
                    startOperationsForPhoto(post: recordToProcess, indexPath: indexPath)
                }
                
            }
            
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
    
    //    func getPostsFromAPI (endURL:String,postsAcquired:(postsArray: NSArray?, success: Bool) -> Void ){
    //
    //        let session = NSURLSession.sharedSession()
    //        let postUrl = endURL + self.searchText!
    //        let postFinalURL = NSURL(string: postUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
    //
    //     //   let postFinalURL = NSURL(string: postUrl.stringByAddingPercentEncodingWithAllowedCharacters(_:))!
    //
    //
    //      //  NSData(contentsOfURL:NSURL(string:post.featured_image_url!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
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
    
    //    func updateSearchPosts(endURL:String, completionHandler:() -> Void){
    //
    //
    //        self.getPostsFromAPI(endURL) { (postsArray, success) in
    //            if success {
    //
    //
    //                // create dispatch group.
    //
    //                for postEntry in postsArray! {
    //                    let post = NSEntityDescription.insertNewObjectForEntityForName("Post", inManagedObjectContext: self.managedObjectContext) as! Post
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
    //                    self.posts.append(post)
    //                    
    //                }//End postsArray Loop
    //                completionHandler()
    //              
    //            }
    //            else {}
    //        } // end getPostsFromAPI
    
    
    //      }
    
    
    
    
}
