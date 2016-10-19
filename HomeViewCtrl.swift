//
//  HomeViewCtrl.swift
//  Melmel
//
//  Created by Work on 8/06/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class HomeViewCtrl: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    @IBAction func discountButton(_ sender: AnyObject) {
        self.tabBarController?.selectedIndex = 1
    }

    @IBAction func postButton(_ sender: AnyObject) {
        self.tabBarController?.selectedIndex = 0
    }
}
