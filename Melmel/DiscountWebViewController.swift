//
//  PostWebViewController.swift
//  Melmel
//
//  Created by Work on 8/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class DiscountWebViewController: UIViewController,UIWebViewDelegate {
    
    var loading = false
    var timer:Timer? = nil
    
    var loadingView:UIView? = nil
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var commentButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var webRequestURLString:String?
    var postid:String?
    var discountTitle:String?
    

    @IBOutlet weak var postWebView: UIWebView!
    //using the URL, loads the website on the webview
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        
        if discountTitle == nil {
            discountTitle = "墨尔本优惠"
        }
        
        loadingView = self.showLoadingBlockView()
        
        postWebView.delegate = self
        progressView.progress  = 0
        let url = URL(string:webRequestURLString!)
        let request = NSMutableURLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10.0)
        postWebView.loadRequest(request as URLRequest)
        postWebView.delegate = self
        if shareButton != nil {
            shareButton.target = self
            shareButton.action = #selector(self.presentSocialShareActivityView)
        }
    }
    
    func presentSocialShareActivityView() {
        let url = webRequestURLString!
        if let nsurl = NSURL(string: url) {
            let image = UIImage(named: "WechatShareIcon")
            let activityVC = UIActivityViewController(activityItems: [discountTitle!, nsurl,image!], applicationActivities: nil)
            //activityVC.popoverPresentationController?.sourceView = sender
            
            present(activityVC, animated: true, completion: nil)
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showcommentSegue" {
            let DC = segue.destination as! ShowCommentTableViewController
            
            DC.postid = self.postid!
            
            
        }
    }
    
    
    // Web View Start Load page
    func webViewDidStartLoad(_ webView: UIWebView) {
        progressView.progress = 0
        loading = true
        timer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(self.updateProgressView), userInfo: nil, repeats: true)
    }
    
    // Web View Finish Loading Page
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading = false
        self.applyCSSToUIWebView(webView: webView)
        
        self.hideLoadingBlockView(loadingView: loadingView!)
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
            progressView.isHidden = true
            timer?.invalidate()
        }
    }
}
