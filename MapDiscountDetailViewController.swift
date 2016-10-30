//
//  MapDiscountDetailViewController.swift
//  Melmel
//
//  Created by Work on 1/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import Presentr

class MapDiscountDetailViewController: UIViewController {
    
    var viewTintColor:UIColor?
    var showed = false
    
    var discount:Discount!

    @IBOutlet weak var discountTypeImgView: UIImageView!
    
    @IBOutlet weak var discountTagLabel: UILabel!
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var detailButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        setupView()
    }
    
//    init(){
//        super.init(nibName: nil, bundle: nil)
//    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        self.view.layer.shadowOpacity = 0.7
        self.view.layer.shadowRadius = 5.0
        self.view.layer.shadowOffset = CGSize(width: 0.0, height: -5.0)
        self.view.layer.shadowColor = viewTintColor?.cgColor
        self.view.backgroundColor = UIColor(colorLiteralRed: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        self.detailButton.backgroundColor = viewTintColor
    }

}

extension MapDiscountDetailViewController:PresentrDelegate {
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        return !keyboardShowing
    }
}
