//
//  FilterTableViewController.swift
//  Melmel
//
//  Created by WuKaipeng on 20/06/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {

    var filters: [DiscountFilter] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var filterCat1: [DiscountCategory] = []
        var filterCat2: [DiscountCategory] = []
        var filterCat3: [DiscountCategory] = []
        var filterCat4: [DiscountCategory] = []
        var filterCat5: [DiscountCategory] = []
        
        let cat001 = DiscountCategory(name:"娱乐类",category: "141")
        let cat002 = DiscountCategory(name:"KTV",category: "433")
        let cat003 = DiscountCategory(name:"桌球",category: "306")
        let cat004 = DiscountCategory(name:"果园",category: "79")
        let cat005 = DiscountCategory(name:"密室逃脱",category: "1037")
        
        filterCat1.append(cat001)
        filterCat1.append(cat002)
        filterCat1.append(cat003)
        filterCat1.append(cat004)
        filterCat1.append(cat005)
        
        
        
        
        
        
        let filter1 = DiscountFilter(name: "娱乐类", category: filterCat1)
        let filter2 = DiscountFilter(name: "时尚类", category: [])
        let filter3 = DiscountFilter(name: "服务类", category: [])
        let filter4 = DiscountFilter(name: "美食类", category: [])
        let filter5 = DiscountFilter(name: "购物类", category: [])
        
        filters.append(filter1)
        filters.append(filter2)
        filters.append(filter3)
        filters.append(filter4)
        filters.append(filter5)
        

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
        return filters.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath) as! FilterTableViewCell
        
        let filter = filters[indexPath.row]
        
        cell.titleLabel.text = filter.name
        // Configure the cell...

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "filterSegue" {
            let DC = segue.destinationViewController as! CategoryTableViewController
            let path = tableView.indexPathForSelectedRow!
            DC.categories = filters[path.row].category
            
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
