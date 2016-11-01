//
//  XLForm.swift
//  Melmel
//
//  Created by Work on 21/10/16.
//  Copyright © 2016 Melmel. All rights reserved.
//

import XLForm
import MelMobile

extension XLFormViewController {
    
    /// Extension Methods for sending a form to the email address
    ///
    /// - parameter title:  the name of the form
    /// - parameter values: field name and the value of the field
    func sendXLFormValuesAsEmail(title:String,values:[(String,String)]){
        var contentString = ""
        
        for value in values {
            contentString += "\(value.0):\(value.1)\n"
        }
        
        let email = Email(
            from: "Melmel iOS <contact-us-ios.noreply@melmel.com.au>",
            to: "Melmel Consulting <info@melmel.com.au>", // TODO: Replace email address with: pte@ail.vic.edu.au
            title: "Melmel用户留言 (Melmel iOS客户端<\(title)>)",
            content: contentString
        )
        let loadingAlert = UIAlertController(title: "发送中……", message: nil, preferredStyle: .alert)
        self.present(loadingAlert, animated: true, completion: nil)
        EmailEjector.eject(email: email) { _ in
            loadingAlert.dismiss(animated: true, completion: nil)
            let successAlert = UIAlertController(title: "表单发送成功", message: "我们已经受到您的信息！", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            
            successAlert.addAction(alertAction)
            self.present(successAlert, animated: true, completion: nil)
        }
    }
    
    
}
