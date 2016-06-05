//
//  DiscountTableViewController.swift
//  Melmel
//
//  Created by WuKaipeng on 19/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import CoreData

class DiscountTableViewController: UITableViewController {
    
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
   // var discountList=[(Discount,UIImage)]()
    var discounts:[Discount] = []
    
    var reachabilityManager = ReachabilityManager.sharedReachabilityManager
    var isLoading = false
    let pendingOperations = PendingOperations()
    var alert = Alert()

    @IBOutlet weak var loadMorePostsLabel: UILabel!
    @IBOutlet weak var LoadMoreActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor(red: 236.0/255.0, green: 28.0/255.0, blue: 41.0/255.0, alpha: 1.0)
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: #selector(self.updateDiscounts), forControlEvents: .ValueChanged)
        self.refreshControl?.beginRefreshing()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let discountUpdateUtility = PostsUpdateUtility()
        discounts = discountUpdateUtility.fetchDiscounts()
        
        self.updateDiscounts()
        
        
        self.tableView.reloadData()
     /*
            for discount in discounts {
                
                    if discount.downloaded == nil {
                        print (discount.featured_image_url!)
                      
                        let imageDownloader = FileDownloader()
                        imageDownloader.downloadFeaturedImageForPostFromUrlAndSave(discount.featured_image_url! as String, postId: discount.id! as Int) { (image) in
                            discount.downloaded = true
                            do {
                                try self.managedObjectContext.save()
                                print("save featured successfully")
                            }catch {
                            }
                            
                            self.discountList.append((discount,image))
                            
                        }
                    } else {
                        let documentDirectory = try! NSFileManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
                        
                        let imagePath = documentDirectory.URLByAppendingPathComponent("posts/\(discount.id!)/featrued_image.jpg")
                        
                        let image = UIImage(contentsOfFile: imagePath.path!)
                        self.discountList.append((discount,image!))
                        print("append image successfully")
                    }
                
        */
        
      
    
        
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
        if (indexPath.row == discounts.count-1) && !isLoading{
            isLoading = true
            self.LoadMoreActivityIndicator.hidden = false
            self.LoadMoreActivityIndicator.startAnimating()
            self.loadMorePostsLabel.text = "加载中……"
            let oldestPost = discounts[indexPath.row]
            loadPreviousPosts(oldestPost.date!,excludeId: oldestPost.id as! Int)
        }
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
        dateFormatter.dateStyle = .LongStyle
        cell.dateLabel.text = dateFormatter.stringFromDate(discount.date!)
        
        if discount.featuredImageState == .Downloaded {
            cell.featureImage.image = discount.featuredImage
        }
        if discount.featuredImageState == .New {
            startOperationsForPhoto(discount, indexPath: indexPath)
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
            })
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
            
        }
    }
    
    
    
    func updateDiscounts(){
        
        if reachabilityManager.isReachable(){
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
        }
    }
 

}
