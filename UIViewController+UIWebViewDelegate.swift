//
//  UIViewController+UIWebViewDelegate.swift
//  Melmel
//
//  Created by Work on 26/10/16.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    func applyCSSToUIWebView(webView:UIWebView) {
        let cssString = ".entry-author-info-wrap,#back-to-top,#comments,.nav-single,.sidebar-right,header {display:none;}"
        let javascriptString = "var style = document.createElement('style'); style.innerHTML = '%@'; document.head.appendChild(style)"
        let javascriptWithCssString = String(format: javascriptString, cssString)
        webView.stringByEvaluatingJavaScript(from: javascriptWithCssString)
        
    }
}
