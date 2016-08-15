//
//  CategoryTableViewController.swift
//  Melmel
//
//  Created by WuKaipeng on 20/06/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

//protocol filterCategoryDelegate {
//    func filterCategory()
//}

class CategoryTableViewController: UITableViewController {
    
    var categories: [DiscountCategory] = []
  //  var delegate: filterCategoryDelegate?

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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       // return self.categories.count
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath) as! CategoryTableViewCell
//        
//        
//        let cate = categories[indexPath.row]
//        
//        cell.titleLabel.text = cate.name

        // Configure the cell...
        cell.nameLabel.text = "testing"

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    //    print("You selected cell #\(indexPath.row)!")
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        
        let DCInt = self.navigationController!.viewControllers.count - 3;
        
        let path = tableView.indexPathForSelectedRow!
        
        let DC = self.navigationController?.viewControllers[DCInt] as! DiscountTableViewController
        
        DC.categoryInt = categories[path.row].category
        DC.filtered = true
        
      //  print ("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk")
        //print (DC.categoryInt)


     //   DC.filterCategory()
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        
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
