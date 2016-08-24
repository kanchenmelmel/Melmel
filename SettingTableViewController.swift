//
//  SettingTableViewController.swift
//  Melmel
//
//  Created by Work on 24/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

}
