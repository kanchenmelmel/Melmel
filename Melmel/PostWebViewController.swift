//
//  PostWebViewController.swift
//  Melmel
//
//  Created by Work on 8/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class PostWebViewController: UIViewController {
    
    var webRequestURLString:String?

    @IBOutlet weak var postWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let url = NSURL(string:webRequestURLString!)
        let request = NSURLRequest(URL: url!)
        postWebView.loadRequest(request)
    }
    
    @IBAction func backToPreviousView(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
