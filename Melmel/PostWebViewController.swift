//
//  PostWebViewController.swift
//  Melmel
//
//  Created by Work on 8/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class PostWebViewController: UIViewController,UIWebViewDelegate {
    
    var loading = false
    var timer:NSTimer? = nil
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var webRequestURLString:String?

    @IBOutlet weak var postWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        progressView.progress  = 0
        let url = NSURL(string:webRequestURLString!)
        let request = NSMutableURLRequest(URL: url!, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 10.0)
        postWebView.loadRequest(request)
        postWebView.delegate = self
    }
    
    
    // Web View Start Load page
    func webViewDidStartLoad(webView: UIWebView) {
        progressView.progress = 0
        loading = true
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01667, target: self, selector: #selector(PostWebViewController.updateProgressView), userInfo: nil, repeats: true)
    }
    
    // Web View Finish Loading Page
    func webViewDidFinishLoad(webView: UIWebView) {
        loading = false
    }
    
    func updateProgressView (){
        if loading {
            
            if progressView.progress < 0.95 {
                progressView.progress += 0.005
            }
            else {
                progressView.progress = 0.95
            }
        }
        else {
            progressView.hidden = true
            timer?.invalidate()
        }
    }
}
