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
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let postUpdateUtility = PostsUpdateUtility()
        
        if postType == .Post {
            postUpdateUtility.getAllDiscounts { (discounts) in
                self.discounts = discounts
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        } else {
            postUpdateUtility.searchPostsByKeyWords(searchText!, completionHandler: { (posts) in
                self.posts = posts
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
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
        return self.posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if postType == .Discount {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchTableViewCell", forIndexPath: indexPath) as! SearchTableViewCell
        
        // Configure the cell...
        
        let discount = self.discounts[indexPath.row]
        
     
        cell.titleLabel.text = discount.title!
        
    
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        cell.dateLabel.text = "\(dateFormatter.stringFromDate(discount.date!).uppercaseString)" + " "
        
        if discount.featured_image_url != nil {
            if discount.featuredImageState == .Downloaded {
                cell.featureImage.image = discount.featuredImage
            }
            if discount.featuredImageState == .New {
                startOperationsForPhoto(post, indexPath: indexPath)
            }
            
        }
        
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! SearchPostCell
            
            return cell

        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "searchLinkSegue" {
            let postWebVeiwController = segue.destinationViewController as! PostWebViewController
            let path = tableView.indexPathForSelectedRow!
            print (posts[path.row].link)
            postWebVeiwController.webRequestURLString = posts[path.row].link
            postWebVeiwController.postid = String(posts[path.row].id!)
        }
    }
    
    func startOperationsForPhoto(post:Post,indexPath:NSIndexPath) {
        switch (post.featuredImageState) {
        case .New:
            startDownloadFeaturedImageForPost (post:post,indexPath:indexPath)
        default:
            NSLog("Do nothing")
        }
    }
    
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
            })
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func getPostsFromAPI (endURL:String,postsAcquired:(postsArray: NSArray?, success: Bool) -> Void ){
        
        let session = NSURLSession.sharedSession()
        let postUrl = endURL + self.searchText!
        let postFinalURL = NSURL(string: postUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        
     //   let postFinalURL = NSURL(string: postUrl.stringByAddingPercentEncodingWithAllowedCharacters(_:))!
        
        
      //  NSData(contentsOfURL:NSURL(string:post.featured_image_url!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
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
    
    func updateSearchPosts(endURL:String, completionHandler:() -> Void){
       
    
        self.getPostsFromAPI(endURL) { (postsArray, success) in
            if success {
                
                
                // create dispatch group.
                
                for postEntry in postsArray! {
                    let post = NSEntityDescription.insertNewObjectForEntityForName("Post", inManagedObjectContext: self.managedObjectContext) as! Post
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
                    
                    
                    self.posts.append(post)
                    
                }//End postsArray Loop
                completionHandler()
              
            }
            else {}
        } // end getPostsFromAPI
        
        
    }
    
    
    

}
