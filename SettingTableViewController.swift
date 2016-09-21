//
//  SettingTableViewController.swift
//  Melmel
//
//  Created by Work on 24/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }

}
