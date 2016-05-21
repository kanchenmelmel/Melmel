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

    
    let pendingOperations = PendingOperations()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let discountUpdateUtility = PostsUpdateUtility()
       // let discounts = discountUpdateUtility.fetchDiscounts()
        discounts = discountUpdateUtility.fetchDiscounts()
        
        discountUpdateUtility.updateDiscounts() {
            dispatch_async(dispatch_get_main_queue()){
                print ("main queue")
                self.discounts = discountUpdateUtility.fetchDiscounts()
                print ("main queue2")
                self.tableView.reloadData()
                print ("main queue3")
            }
            
        }
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
        
        self.tableView.reloadData()
    
        
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
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("discountTableViewCell", forIndexPath: indexPath) as! DiscountTableViewCell
        
        // Configure the cell...
        let discount  = discounts[indexPath.row]
        cell.titleLabel.text = discount.title!
        
        if discount.featuredImageState == .Downloaded {
            cell.featuredImage.image = discount.featuredImage
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
        
        let downloader = ImageDownloader(discount: discount)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
