



//  MelGuideTableViewController.swift
//  Melmel
//
//  Created by Work on 30/03/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import CoreData

class MelGuideTableViewController: UITableViewController {
    
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var posts:[Post] = []
    let pendingOperations = PendingOperations()
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Request Posts from Melmel Website
        
        
        
        
        
        // Initialize Posts
        let coreDataUtility = CoreDataUtility()
        print("Earliest Date: \(coreDataUtility.getEarliestDate(EntityType.Post))")
        
        
        
        // Initialize the refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor(red: 236.0/255.0, green: 28.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: #selector(self.updatePosts), forControlEvents: .ValueChanged)
        self.refreshControl?.beginRefreshing()
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let postUpdateUtility = PostsUpdateUtility()
        posts = postUpdateUtility.fetchPosts()
        updatePosts(){}
        
        
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("melGuideTableViewCell", forIndexPath: indexPath) as! MelGuideTableViewCell
        
        // Configure the cell...
        let post = posts[indexPath.row]
        cell.titleLabel.text = post.title!
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        cell.dateLabel.text = dateFormatter.stringFromDate(post.date!)
        
        
        if post.featured_image_url != nil {
            if post.featuredImageState == .Downloaded {
                cell.featuredImage.image = post.featuredImage
            }
            if post.featuredImageState == .New {
                startOperationsForPhoto(post, indexPath: indexPath)
            }

        }

        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == posts.count-1) && !isLoading{
            isLoading = true
            let oldestPost = posts[indexPath.row]
            loadPreviousPosts(oldestPost.date!,excludeId: oldestPost.id as! Int)
        }
    }
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
    
    /*
     MARK: - Navigation
     
     In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "postSegue" {
            let postWebVeiwController = segue.destinationViewController as! PostWebViewController
            let path = tableView.indexPathForSelectedRow!
            //            if posts[path.row].featured_media!.link != nil {
            //                print("There is featuredMedia")
            //            }
            postWebVeiwController.webRequestURLString = posts[path.row].link
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
        
        let downloader = ImageDownloader(post: post)
        
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
    
    
    
    func updatePosts(completionHandler:()->Void){
        
        let postUpdateUtility = PostsUpdateUtility()
        postUpdateUtility.updateAllPosts {
            
            dispatch_async(dispatch_get_main_queue(), {
                print("Update table view")
                self.posts = postUpdateUtility.fetchPosts()
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
        }
    }
    
    func loadPreviousPosts(oldestPostDate:NSDate,excludeId:Int){
        let postsUpdateUtility = PostsUpdateUtility()
        postsUpdateUtility.getPreviousPosts(oldestPostDate,excludeId: excludeId) {
            dispatch_async(dispatch_get_main_queue(), {
                print("Load Previous Data")
                self.posts = postsUpdateUtility.fetchPosts()
                self.tableView.reloadData()
                self.isLoading = false
            })
        }
        
    }
    
    
}
