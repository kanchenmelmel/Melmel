



//  MelGuideTableViewController.swift
//  Melmel
//
//  Created by Work on 30/03/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import CoreData

class MelGuideTableViewController: UITableViewController,UISearchBarDelegate {
    
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var posts:[Post] = []
    let pendingOperations = PendingOperations()
    var isLoading = false
    
    var reachabilityManager = ReachabilityManager.sharedReachabilityManager
    var alert = Alert()
    
    var numOfPosts:Int?
    var reachToTheEnd = false

    @IBOutlet weak var loadMorePostsLabel: UILabel!
    @IBOutlet weak var LoadMoreActivityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Request Posts from Melmel Website
        
        
        // Configure Conponents
        
        LoadMoreActivityIndicator.hidden = true
        
        
        
        // Initialize Posts
        let coreDataUtility = CoreDataUtility()
        print("Earliest Date: \(coreDataUtility.getEarliestDate(EntityType.Post))")
        
        
        // Initialize the refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = GLOBAL_TINT_COLOR
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: #selector(self.updatePosts), forControlEvents: .ValueChanged)
        self.refreshControl?.beginRefreshing()
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let postUpdateUtility = PostsUpdateUtility()
        posts = postUpdateUtility.fetchPosts()
        updatePosts()
        
        
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
        
        print(post.featured_image_downloaded)
        cell.titleLabel.text = post.title!
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        cell.dateLabel.text = dateFormatter.stringFromDate(post.date!)
        print(post.featured_image_downloaded)
        
        
        // Configure featured image
        
        if post.featured_image_downloaded == true {
            let fileDownloader = FileDownloader()
            post.featuredImage = fileDownloader.imageFromFile(post.id! as Int, fileName: FEATURED_IMAGE_NAME)
            
        } else {
            if post.featured_image_url != nil {
                if post.featuredImageState == .Downloaded {
                    
                }
                if post.featuredImageState == .New {
                    startOperationsForPhoto(post, indexPath: indexPath)
                }
                
            }

        }
        cell.featuredImage.image = post.featuredImage
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == posts.count-1) && !isLoading{
            isLoading = true
            if reachToTheEnd == false{
                self.LoadMoreActivityIndicator.hidden = false
                self.LoadMoreActivityIndicator.startAnimating()
            
                self.loadMorePostsLabel.text = "加载中……"
                let oldestPost = posts[indexPath.row]
                self.numOfPosts = self.posts.count
            loadPreviousPosts(oldestPost.date!,excludeId: oldestPost.id as! Int)
            }
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
        
        if reachabilityManager.isReachable(){
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
        
        
    }
    
    
    
    func updatePosts(){
        if reachabilityManager.isReachable(){
            print("is Reachable")
            let postUpdateUtility = PostsUpdateUtility()
            postUpdateUtility.updateAllPosts {
                
                dispatch_async(dispatch_get_main_queue(), {
                    print("Update table view")
                    self.posts = postUpdateUtility.fetchPosts()
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
            }
        } else {
            print("No Internet Connection")
            self.refreshControl?.endRefreshing()
          //  popUpWarningMessage("No Internet Connection")
            alert.showAlert(self)
            
        }
        
        
    }
    
    func loadPreviousPosts(oldestPostDate:NSDate,excludeId:Int){
        
        if reachabilityManager.isReachable(){
            
            let postsUpdateUtility = PostsUpdateUtility()
            postsUpdateUtility.getPreviousPosts(oldestPostDate,excludeId: excludeId) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.posts = postsUpdateUtility.fetchPosts()
                    self.tableView.reloadData()
                    self.isLoading = false
                    self.LoadMoreActivityIndicator.stopAnimating()
                    self.LoadMoreActivityIndicator.hidden = true
                    if self.numOfPosts == self.posts.count{
                        self.reachToTheEnd = true
                        self.loadMorePostsLabel.hidden = true
                        self.LoadMoreActivityIndicator.hidden = true
                    }
                })
            }
        } else {
            //popUpWarningMessage("No Internet Connection")
            alert.showAlert(self)
            self.isLoading = false
        }
        
        
    }
    
    func displayNavBarPrompt(message:String){
        self.navigationItem.prompt = message
    }
    
    func hidenNavBarPrompt(){
        self.navigationItem.prompt = nil
    }
    
    func popUpWarningMessage(message:String){
        displayNavBarPrompt(message)
        let dispatchAfterTime = dispatch_time(DISPATCH_TIME_NOW, 5 * Int64(NSEC_PER_SEC))
        dispatch_after(dispatchAfterTime, dispatch_get_main_queue(), {
            self.hidenNavBarPrompt()
        })
    }
    
}
