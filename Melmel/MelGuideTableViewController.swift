//
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
    var posts:[Post]=[]
    var mediaArray:[Media] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Request Posts from Melmel Website
        
        
        let postsUpdateUtility = PostsUpdateUtility()
        
        posts = postsUpdateUtility.fetchPosts()
        
        postsUpdateUtility.updateAllPosts({() -> Void in
            self.posts = postsUpdateUtility.fetchPosts()
            self.tableView.reloadData()
        })
        
        

        
        
        // Initialize Posts
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("rows\(posts.count)")
        return posts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("melGuideTableViewCell", forIndexPath: indexPath) as! MelGuideTableViewCell

        // Configure the cell...
        cell.titleLabel.text = posts[indexPath.row].title!
        

        return cell
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
        }
    }
    
    

}
