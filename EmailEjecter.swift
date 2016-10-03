//
//  EmailEjecter.swift
//  AIL
//
//  Created by Wenyu Zhao on 19/09/2016.
//  Copyright © 2016 au.com.melmel. All rights reserved.
//

import Foundation
import Alamofire

struct Email {
    var from: String
    var to: String
    var title: String
    var content: String
    
}

class EmailEjector {
    
    private enum BodyType {
        case HTML
        case TEXT
    }
    
    private static let DOMAIN = "www.melmel.com.au";
    
    private class func request_url(bodyType: BodyType) -> String {
        switch bodyType {
        case .HTML:
            return "http://\(DOMAIN)/wp-content/plugins/mailgun-rest/html.php"
        case .TEXT:
            return "http://\(DOMAIN)/wp-content/plugins/mailgun-rest/text.php"
        }
    }
    
    private class func eject_email(type: BodyType, email: Email, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        let parameters = [
            "from": email.from,
            "to":  email.to,
            "subject": email.title,
            "body": email.content,
        ]
        Alamofire.request(
            "http://\(DOMAIN)/wp-content/plugins/mailgun-rest/html.php",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.prettyPrinted
        ).responseJSON(completionHandler: completionHandler)
        
    }
    
    class func eject(email: Email, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        eject_email(type: .TEXT, email: email, completionHandler: completionHandler);
    }
    
    class func ejectHTMLEmail(email: Email, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        eject_email(type: .HTML, email: email, completionHandler: completionHandler);
    }
}

