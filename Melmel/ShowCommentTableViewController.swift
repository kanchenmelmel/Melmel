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
    var comments = [Comment]()
    var featuredImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = true
        
        let activityIndicatorView = CustomActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
        activityIndicatorView.center = self.tableView.center
        self.tableView.addSubview(activityIndicatorView)
        let postUpdateUtility = PostsUpdateUtility()
        postUpdateUtility.getPostComments(self.postid!) {(comments) in
            self.comments = comments
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
                
                activityIndicatorView.stopAnimating()
                activityIndicatorView.willMove(toSuperview: self.tableView)
                
                if comments.count == 0 {
                    self.showMessageView(string: "没有任何评论！")
                }
            })
        }
        
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
        return self.comments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showcommentIdentifier", for: indexPath) as! CommentTableViewCell

        
        let comment = self.comments[(indexPath as NSIndexPath).row]
        cell.nameLabel.text = comment.autherName
        let dateFormatter = DateFormatter()
        cell.dateLabel.text = dateFormatter.formatDateToDateStringForDisplay(comment.date!)
        cell.contentLabel.text = comment.content
        
        let gravatarURL = comment.avatar?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlFragmentAllowed)
        let imageData = try? Data(contentsOf: URL(string:gravatarURL!)!)
        self.featuredImage = UIImage(data: imageData!)
        cell.avatarImage.image = self.featuredImage

        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentSegue" {
            let DC = segue.destination as! CommentViewController
            
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
