//
//  PostWebViewController.swift
//  Melmel
//
//  Created by Work on 30/10/16.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class PostWebPageViewController: UIViewController,UIWebViewDelegate {

    var loading = false
    var timer:Timer? = nil
    
    var loadingView:UIView? = nil
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var commentButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var webRequestURLString:String?
    var postid:String?
    var postTitle:String?
    
    @IBOutlet weak var postWebView: UIWebView!
    //using the URL, loads the website on the webview
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        if postTitle == nil {
            postTitle = "墨尔本攻略"
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
            let activityVC = UIActivityViewController(activityItems: [postTitle!, nsurl], applicationActivities: nil)
            //activityVC.popoverPresentationController?.sourceView = sender
            
            present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = true
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
