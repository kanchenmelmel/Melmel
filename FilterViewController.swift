//
//  FilterViewController.swift
//  Melmel
//
//  Created by WuKaipeng on 2/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

protocol FilterPassValueDelegate{
    func UserDidFilterCategory(catergoryInt: String, FilteredBool:Bool)
}
class FilterViewController: UIViewController {
    
    var delegate : FilterPassValueDelegate?
    
    
    @IBAction func didYuleButtonPress(sender: AnyObject) {
        
        print ("Yulelelelele")
        delegate?.UserDidFilterCategory("lalala", FilteredBool: false)
        
      //  self.view.removeFromSuperview()
        
    }
    
    
    @IBAction func didShishangButtonPressed(sender: AnyObject) {
    }
    
    
    @IBAction func didFuwuButtonPressed(sender: AnyObject) {
    }
    
    
    @IBAction func didMeishiButtonPressed(sender: AnyObject) {
    }
    
    
    @IBAction func didGouwuButtonPressed(sender: AnyObject) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView(){
        self.view.layer.shadowOpacity = 1.0
        self.view.layer.shadowRadius = 13.0
        self.view.layer.shadowOffset = CGSizeMake(0.0, -2.0)
        self.view.layer.shadowColor = UIColor(red: 242.0/255.0, green: 109.0/255.0, blue: 125.0/255.0, alpha: 1.0).CGColor
        //self.view.backgroundColor = UIColor(colorLiteralRed: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
       // self.detailButton.backgroundColor = UIColor(red: 242.0/255.0, green: 109.0/255.0, blue: 125.0/255.0, alpha: 1.0)
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
