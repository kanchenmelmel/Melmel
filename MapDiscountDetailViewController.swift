//
//  MapDiscountDetailViewController.swift
//  Melmel
//
//  Created by Work on 1/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class MapDiscountDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupView(){
        self.view.layer.shadowOpacity = 0.8
        self.view.layer.shadowRadius = 5.0
        self.view.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        self.view.layer.shadowColor = UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1.0).CGColor
    }

}
