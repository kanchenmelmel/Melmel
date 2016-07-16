//
//  InputSearchViewController.swift
//  Melmel
//
//  Created by WuKaipeng on 11/06/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class InputSearchViewController: UIViewController,UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
//        
//        self.navigationController?.navigationBar.barTintColor=UIColor.redColor();

        // Do any additional setup after loading the view.
        
        searchBar.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOutside))
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.performSegueWithIdentifier("searchSegue", sender: self)
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "searchSegue" {
            let DC = segue.destinationViewController as! SearchTableViewController
            
            DC.searchText = self.searchBar.text!
            
            
        }
    }
    
    func tapOutside(){
        searchBar.resignFirstResponder()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
