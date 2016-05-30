//
//  ShowCommentTableViewController.swift
//  Melmel
//
//  Created by WuKaipeng on 28/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class ShowCommentTableViewController: UITableViewController {
    
    var postid:String?
    var showcommentArray = Array<Array<String>>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getComments()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func getComments(){
        let endURL = "http://melmel.com.au/wp-json/wp/v2/comments?post=\(self.postid!)&per_page=100"
        
        let commentURL = NSURL(string: endURL)!
        let session = NSURLSession.sharedSession()
        var commentArray: NSArray?
    
        session.dataTaskWithURL(commentURL){ (data:NSData?, response:NSURLResponse?, error: NSError?) -> Void in
            
            if let responseData = data {
                
                
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
                    if let commentsArray = json as? NSArray{
                       // print (commentsArray)
                        commentArray = json as! NSArray
                        for comment in commentArray!{
                            var tmp = [String]()
                            
                            let name = comment["author_name"] as! String
                            
                            let date = comment["comment_date"] as! String
                            
                            let content = comment["content_raw"] as! String
                            
                            tmp.append(name)
                            tmp.append(date)
                            tmp.append(content)
                            
                            self.showcommentArray.append(tmp)

                        }
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.reloadData()
                        })
                        
                        
                    }
                    else {
                        print ("error")
                    }
                } catch {
                    
                    print("could not serialize!")
                }
            }
            }.resume()
        
        

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
        return self.showcommentArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("showcommentIdentifier", forIndexPath: indexPath) as! CommentTableViewCell
        
        let comment = self.showcommentArray[indexPath.row]
        cell.nameLabel.text = comment[0]
        cell.dateLabel.text = comment[1]
        cell.contentLabel.text = comment[2]

        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "commentSegue" {
            let DC = segue.destinationViewController as! CommentViewController
            
            DC.postid = self.postid!
            
            
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}