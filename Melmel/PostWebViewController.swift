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
    @IBOutlet weak var commentButton: UIBarButtonItem!
    
    var webRequestURLString:String?
    var postid:String?

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showcommentSegue" {
            let DC = segue.destinationViewController as! ShowCommentTableViewController
            
            DC.postid = self.postid!
            
            
        }
    }
    
    
    // Web View Start Load page
    func webViewDidStartLoad(webView: UIWebView) {
        progressView.progress = 0
        loading = true
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01667, target: self, selector: #selector(self.updateProgressView), userInfo: nil, repeats: true)
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
