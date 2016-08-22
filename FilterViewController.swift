//
//  FilterViewController.swift
//  Melmel
//
//  Created by WuKaipeng on 7/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

protocol CloseFilterSubview{
    func ShouldCloseSubview()
    func didFindAll()
}


class FilterViewController: UIViewController {
    
    
    
    convenience init() {
        self.init(nibName: "FilterViewController", bundle: nil)
    }

    
    var catVC : CategoryTableViewController?
    
    var delegate : CloseFilterSubview?
    
    @IBAction func didAll(sender: AnyObject) {
        
        delegate?.didFindAll()
        delegate?.ShouldCloseSubview()
        self.view.removeFromSuperview()
        
    }
    @IBAction func didYuleButtonPress(sender: AnyObject) {
        //  self.view.removeFromSuperview()
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let catVC = storyboard.instantiateViewControllerWithIdentifier("testid") as?CategoryTableViewController
       
        catVC?.catID = 1
        self.navigationController?.pushViewController(catVC!, animated: true)
        delegate?.ShouldCloseSubview()
        self.view.removeFromSuperview()
     //   self.navigationC ontroller?.presentViewController(catVC!, animated: true, completion: nil)

    }
    
    @IBAction func didShishangButtonPress(sender: AnyObject) {
      
        catVC?.catID = 2
        self.navigationController?.pushViewController(catVC!, animated: true)
        delegate?.ShouldCloseSubview()
        self.view.removeFromSuperview()
       // self.presentViewController(catVC!, animated: true, completion: nil)
    }
    
    
    @IBAction func didFuwuButtonPress(sender: AnyObject) {
        
        catVC?.catID = 3
        self.navigationController?.pushViewController(catVC!, animated: true)
        delegate?.ShouldCloseSubview()
        self.view.removeFromSuperview()
    }
    
    
    @IBAction func didMeishiButtonPress(sender: AnyObject) {

        catVC?.catID = 4
        self.navigationController?.pushViewController(catVC!, animated: true)
        delegate?.ShouldCloseSubview()
        self.view.removeFromSuperview()
    }
    
    
    
    @IBAction func didGouwuButtonPress(sender: AnyObject) {
        catVC?.catID = 5
        self.navigationController?.pushViewController(catVC!, animated: true)
        delegate?.ShouldCloseSubview()
        self.view.removeFromSuperview()
        
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
