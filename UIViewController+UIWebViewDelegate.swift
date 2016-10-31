//
//  UIViewController+UIWebViewDelegate.swift
//  Melmel
//
//  Created by Work on 26/10/16.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import ALThreeCircleSpinner
import Presentr


extension UIViewController {
    
    
    func applyCSSToUIWebView(webView:UIWebView) {
        let cssString = ".entry-author-info-wrap,#back-to-top,#comments,.nav-single,.sidebar-right,header {display:none;}"
        let javascriptString = "var style = document.createElement('style'); style.innerHTML = '%@'; document.head.appendChild(style)"
        let javascriptWithCssString = String(format: javascriptString, cssString)
        webView.stringByEvaluatingJavaScript(from: javascriptWithCssString)
        
    }
    
    func showLoadingBlockView() -> UIView {
        
        let rect = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 108.0)
        let containerView = UIView(frame: rect)
        containerView.tag = 110
        let spinner = ALThreeCircleSpinner(frame: CGRect(x:0,y:0,width:44,height:44))
        spinner.center = containerView.center
        spinner.tintColor = UIColor.lightGray
        
        containerView.addSubview(spinner)
        self.view.addSubview(containerView)
        return containerView
        
        
    }
    
    func hideLoadingBlockView(loadingView:UIView) {
        loadingView.removeFromSuperview()
    }
    
    
    func showMessageView(string:String) {
        let messagePresenter:Presentr = {
            let width = ModalSize.full
            let height = ModalSize.custom(size: 32.0)
            //        let screenHeight = UIScreen.main.bounds.height
            let center = ModalCenterPosition.customOrigin(origin: CGPoint(x:0,y:64.0))
            let presenter = Presentr(presentationType: .custom(width: width, height: height, center: center))
            presenter.transitionType = TransitionType.crossDissolve
            presenter.backgroundOpacity = 0
            presenter.roundCorners = false
            
            return presenter
        }()
        
        let messageVC = MessageVC()
        
        messageVC.messageString = string
        customPresentViewController(messagePresenter, viewController: messageVC, animated: true, completion: nil)
        
        let delay = 2.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            messageVC.dismiss(animated: true, completion: nil)
        })
    }
}
