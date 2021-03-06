//
//  CategoryTableViewController.swift
//  Melmel
//
//  Created by WuKaipeng on 20/06/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit


protocol FilterPassValueDelegate{
    func UserDidFilterCategory(_ catergoryInt: String, FilteredBool:Bool)
}

//this controll class creates every category group for the discount posts
class CategoryTableViewController: UITableViewController {
    
    var categories: [DiscountCategory] = []
    
    var catID : Int?
    
    var delegate : FilterPassValueDelegate?
    
    var filterCat1: [DiscountCategory] = []
    var filterCat2: [DiscountCategory] = []
    var filterCat3: [DiscountCategory] = []
    var filterCat4: [DiscountCategory] = []
    var filterCat5: [DiscountCategory] = []
    
  //  var delegate: filterCategoryDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let cat001 = DiscountCategory(name:"所有娱乐",category: "141")
        let cat002 = DiscountCategory(name:"KTV",category: "433")
        let cat003 = DiscountCategory(name:"桌球",category: "306")
        let cat004 = DiscountCategory(name:"果园",category: "79")
        let cat005 = DiscountCategory(name:"密室逃脱",category: "1037")
        
        let cat011 = DiscountCategory(name:"美妆",category: "280")
        let cat012 = DiscountCategory(name:"美甲",category: "532")
        let cat013 = DiscountCategory(name:"美发",category: "300")
        let cat014 = DiscountCategory(name:"美容",category: "533")
        
        let cat021 = DiscountCategory(name:"所有服务",category: "272")
        let cat022 = DiscountCategory(name:"手机",category: "294")
        let cat023 = DiscountCategory(name:"快递",category: "455")
        let cat024 = DiscountCategory(name:"宠物",category: "536")
        let cat025 = DiscountCategory(name: "医药", category: "273")
        let cat026 = DiscountCategory(name: "留学移民", category: "487")
        
        let cat031 = DiscountCategory(name: "所有美食", category: "103")
        let cat032 = DiscountCategory(name: "中餐", category: "104")
        let cat033 = DiscountCategory(name: "西餐",category: "205")
        let cat034 = DiscountCategory(name: "咖啡", category: "127")
        let cat035 = DiscountCategory(name: "日本料理", category: "360")
        let cat036 = DiscountCategory(name: "川菜", category: "144")
        let cat037 = DiscountCategory(name: "烧烤", category: "162")
        let cat038 = DiscountCategory(name: "粤饮茶",category: "161")
        let cat039 = DiscountCategory(name: "火锅", category: "153")
        let cat0301 = DiscountCategory(name: "饮品", category: "422")
        let cat0302 = DiscountCategory(name: "甜品", category: "474")
        let cat0303 = DiscountCategory(name: "中快餐", category: "159")
        let cat0304 = DiscountCategory(name: "自助餐", category: "349")
        let cat0305 = DiscountCategory(name: "小吃", category: "151")
        let cat0306 = DiscountCategory(name: "面包", category: "148")
        let cat0307 = DiscountCategory(name: "东北菜", category: "152")
        let cat0308 = DiscountCategory(name: "夜宵", category: "154")
        
        let cat041 = DiscountCategory(name: "所有购物", category: "17")
        let cat042 = DiscountCategory(name: "厨具", category: "1201")
        
        filterCat1.append(cat001)
        filterCat1.append(cat002)
        filterCat1.append(cat003)
        filterCat1.append(cat004)
        filterCat1.append(cat005)
        
        filterCat2.append(cat011)
        filterCat2.append(cat012)
        filterCat2.append(cat013)
        filterCat2.append(cat014)
        
        filterCat3.append(cat021)
        filterCat3.append(cat022)
        filterCat3.append(cat023)
        filterCat3.append(cat024)
        filterCat3.append(cat025)
        filterCat3.append(cat026)
        
        filterCat4.append(cat031)
        filterCat4.append(cat032)
        filterCat4.append(cat033)
        filterCat4.append(cat034)
        filterCat4.append(cat035)
        filterCat4.append(cat036)
        filterCat4.append(cat037)
        filterCat4.append(cat038)
        filterCat4.append(cat039)
        filterCat4.append(cat0301)
        filterCat4.append(cat0302)
        filterCat4.append(cat0303)
        filterCat4.append(cat0304)
        filterCat4.append(cat0305)
        filterCat4.append(cat0306)
        filterCat4.append(cat0307)
        filterCat4.append(cat0308)
        
        filterCat5.append(cat041)
        filterCat5.append(cat042)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        switch self.catID!{
//        case 1 :
//            self.categories = self.filterCat1
//            print (self.categories)
//        
//        case 2 :
//            self.categories = self.filterCat2
//        
//        case 3 :
//            self.categories = self.filterCat3
//            
//        case 4 :
//            self.categories = self.filterCat4
//        
//        case 5 :
//            self.categories = self.filterCat5
//        
//        default :
//            self.categories = []
//        }
        print ("catID is \(self.catID)")
        
        switch self.catID!{
        case 1 :
            self.categories = self.filterCat1
            print (self.categories)
            
        case 2 :
            self.categories = self.filterCat2
            
        case 3 :
            self.categories = self.filterCat3
            
        case 4 :
            self.categories = self.filterCat4
            
        case 5 :
            self.categories = self.filterCat5
            
        default :
            self.categories = []
        }
        self.tableView.reloadData()

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
        return self.categories.count
      
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        
        let cate = categories[(indexPath as NSIndexPath).row]
        
        cell.nameLabel.text = cate.name


     

        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
//    //    print("You selected cell #\(indexPath.row)!")
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
//        
//        let DCInt = self.navigationController!.viewControllers.count - 3;
//        
//        let path = tableView.indexPathForSelectedRow!
//        
//        let DC = self.navigationController?.viewControllers[DCInt] as! DiscountTableViewController
//        
//        DC.categoryInt = categories[path.row].category
//        DC.filtered = true
//        
//        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
//        
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        delegate!.UserDidFilterCategory(categories[(indexPath as NSIndexPath).row].category, FilteredBool: true)
        let _ = self.navigationController?.popViewController(animated: true)
        
        
    }
    
    func setupTable() {
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
