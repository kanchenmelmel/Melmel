import Foundation
import Alamofire

extension String {
    public func match(_ pattern: NSRegularExpression) -> Bool {
        return pattern.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count)).count > 0
    }
    public func match(_ pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        do {
            return try self.match(NSRegularExpression(pattern: pattern, options: options))
        } catch {
            return false
        }
    }
}

public struct Email {
    public var from: String
    public var to: String
    public var title: String
    public var content: String
    
    public init(from: String, to: String, title: String, content: String) {
        self.from = from
        self.to = to
        self.title = title
        self.content = content
    }
}

public class EmailEjector {
    
    public enum ContentType {
        case HTML
        case TEXT
    }
    
    private static let DOMAIN = "www.melmel.com.au";
    
    private class func request_url(type: ContentType) -> String {
        switch type {
        case .HTML:
            return "http://\(DOMAIN)/wp-content/plugins/mailgun-rest/html.php"
        case .TEXT:
            return "http://\(DOMAIN)/wp-content/plugins/mailgun-rest/text.php"
        }
    }
    
    public class func eject(type: ContentType, email: Email, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        let parameters = [
            "from": email.from,
            "to":  email.to,
            "subject": email.title,
            "body": email.content,
        ]
        let URL = request_url(type: type)
        Alamofire.request(
            URL,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.prettyPrinted
        ).responseJSON(completionHandler: completionHandler)
        
    }
    
    public class func eject(email: Email, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        eject(type: .TEXT, email: email, completionHandler: completionHandler);
    }
    
    public class func ejectHTMLEmail(email: Email, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        eject(type: .HTML, email: email, completionHandler: completionHandler);
    }
}
