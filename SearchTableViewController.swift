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
    
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    
    // var finalURL = endpointURL + searchText!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var navBarTitle = ""
        
        if postType == .Post{
            navBarTitle = "攻略搜索"
        } else {
            navBarTitle = "优惠搜索"
        }
        let textAttributes  = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = navBarTitle
        
        
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let postUpdateUtility = PostsUpdateUtility()
        
        let activityIndicatorView = CustomActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
        
        self.tableView.addSubview(activityIndicatorView)
        
        if postType == .Discount {
            postUpdateUtility.searchDiscountByKeyWords(searchText!, completionHandler: { (discounts) in
                self.discounts = discounts
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    activityIndicatorView.stopAnimating()
                    activityIndicatorView.willMove(toSuperview: self.tableView)
                    }
                )
            })
        } else {
            postUpdateUtility.searchPostsByKeyWords(searchText!, completionHandler: { (posts) in
                self.posts = posts
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    activityIndicatorView.stopAnimating()
                    activityIndicatorView.willMove(toSuperview: self.tableView)
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if postType == .Post{
            return posts.count
        } else {
            return discounts.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if postType == .Discount {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath) as! SearchTableViewCell
            
            // Configure the cell...
            
            let discount = self.discounts[(indexPath as NSIndexPath).row]
            cell.titleLabel.text = discount.title!
            //    cell.titleLabel.text = "testing"
            
            
            
            let dateFormatter = Foundation.DateFormatter()
            dateFormatter.dateStyle = .medium
            cell.dateLabel.text = "\(dateFormatter.string(from: discount.date! as Date).uppercased())" + " "
            
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
            case .entertainment:
                cell.typeLabel.text = "娱乐"
                categoryBackgroundFileName = "EntertainmentTag"
            case .fashion:
                cell.typeLabel.text = "时尚"
                categoryBackgroundFileName = "FashionTag"
            case .service:
                cell.typeLabel.text = "服务"
                categoryBackgroundFileName = "ServiceTag"
            case .food:
                cell.typeLabel.text = "美食"
                categoryBackgroundFileName = "FoodTag"
            case .shopping:
                cell.typeLabel.text = "购物"
                categoryBackgroundFileName = "ShoppingTag"
            default:
                cell.typeLabel.text = "优惠"
            }
            cell.categoryTagBg.image = UIImage(named: categoryBackgroundFileName)
            
            
            
            
            
            
            
            if discount.featured_image_url != nil {
                if discount.featuredImageState == .downloaded {
                    
                }
                if discount.featuredImageState == .new {
                    if (!tableView.isDragging && !tableView.isDecelerating){
                        startOperationsForPhoto(discount: discount, indexPath: indexPath)
                    }
                }
                cell.featureImage.image = discount.featuredImage
                
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! SearchPostCell
            
            let  post = self.posts[(indexPath as NSIndexPath).row]
            
            
            
            cell.titleLabel.text = post.title!
            
            
            
            let dateFormatter = Foundation.DateFormatter()
            dateFormatter.dateStyle = .medium
            cell.dateLabel.text = "\(dateFormatter.string(from: post.date! as Date).uppercased())" + " "
            
            if post.featured_image_url != nil {
                if post.featuredImageState == .downloaded {
                    // Wrong way to do
                    //cell.featuredImage.image = post.featuredImage
                }
                if post.featuredImageState == .new {
                    if (!tableView.isDragging && !tableView.isDecelerating){
                        startOperationsForPhoto(post: post, indexPath: indexPath)
                    }
                }
                
            }
            
            //correct way to do
            cell.featuredImage.image = post.featuredImage
            return cell
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postWebSegue" {
            let postWebVeiwController = segue.destination as! PostWebViewController
            let path = tableView.indexPathForSelectedRow!
            postWebVeiwController.webRequestURLString = posts[(path as NSIndexPath).row].link
            postWebVeiwController.navigationItem.title = "原创攻略"
            postWebVeiwController.postid = String(describing: posts[(path as NSIndexPath).row].id!)
        }
        if segue.identifier == "disocuntWebSegue" {
            let postWebVeiwController = segue.destination as! PostWebViewController
            let path = tableView.indexPathForSelectedRow!
            postWebVeiwController.webRequestURLString = discounts[(path as NSIndexPath).row].link
            postWebVeiwController.navigationItem.title = "墨尔本优惠"
            postWebVeiwController.navigationItem.setRightBarButton(nil, animated: true)
        }
    }
    
    
    
    /*
     Image Downloader operation functions for Post
     */
    func startOperationsForPhoto(post:Post,indexPath:IndexPath) {
        switch (post.featuredImageState) {
        case .new:
            startDownloadFeaturedImageForPost (post:post,indexPath:indexPath)
        default:
            NSLog("Do nothing")
        }
    }
    
    
    /*
     Image Downloader operation functions for Post
     */
    func startDownloadFeaturedImageForPost(post:Post,indexPath:IndexPath) {
        if pendingOperations.downloadsInProgress[indexPath] != nil {
            return
        }
        
        
        let downloader = SearchImageDownloader(post: post)
        
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async(execute: {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
                post.featuredImageState = .downloaded
            })
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    
    /*
     Image Downloader operation functions for Discount
     */
    
    func startOperationsForPhoto(discount:Discount,indexPath:IndexPath) {
        switch (discount.featuredImageState) {
        case .new:
            startDownloadFeaturedImageForPost (discount:discount,indexPath:indexPath)
        default:
            NSLog("Do nothing")
        }
    }
    
    func startDownloadFeaturedImageForPost(discount:Discount,indexPath:IndexPath) {
        if pendingOperations.downloadsInProgress[indexPath] != nil {
            return
        }
        
        let downloader = SearchDiscountImageDownloader(discount: discount)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async(execute: {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
                discount.featuredImageState = .downloaded
            })
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func suspendAllOperations(){
        pendingOperations.downloadQueue.isSuspended = true
    }
    func resumeAllOperations(){
        pendingOperations.downloadQueue.isSuspended = false
    }
    
    func loadImageForOnScreenCells(){
        if let pathsArray = tableView.indexPathsForVisibleRows{
            
            let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray )
            toBeCancelled.subtract(visiblePaths)
            
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations)
            
            for indexPath in toBeCancelled{
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath]{
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                
            }
            
            for indexPath in toBeStarted{
                
                if postType == .Discount{
                    let indexPath = indexPath as IndexPath
                    let recordToProcess = self.discounts[(indexPath as NSIndexPath).row]
                    startOperationsForPhoto(discount: recordToProcess, indexPath: indexPath)
                } else {
                    let indexPath = indexPath as IndexPath
                    let recordToProcess = self.posts[(indexPath as NSIndexPath).row]
                    startOperationsForPhoto(post: recordToProcess, indexPath: indexPath)
                }
                
            }
            
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        suspendAllOperations()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            loadImageForOnScreenCells()
            resumeAllOperations()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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
