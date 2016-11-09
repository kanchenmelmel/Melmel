//
//  File.swift
//  Melmel
//
//  Created by Work on 2/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//  This class is used to send HTTP request to WordPress
//

import Foundation
import UIKit

/// Enumeration type that represent post types. the raw value is the resourse name used in URI
///
/// - Post: represent "攻略" post type
/// - Discount: represent "优惠" post type
/// - Comment: represents "评论" post type
/// - Media: represents "多媒体" post type
enum PostType:String {
    case Post="posts"
    case Discount="discounts"
    case Comment = "comments"
    case Media = "media"
}

/// Enumeration type wich represents CRUD method
///
/// - Get: GET method
/// - Post: POST method
enum HTTPMethod:String {
    case Get = "GET"
    case Post = "POST"
}

/// A class to uses NSURL session that loads the RESTful request and return a JSON object
class APIHelper {
    let melmelRESTURL = "http://www.melmel.com.au/wp-json/wp/v2/"
    let postUrlPathString = "http://www.melmel.com.au/wp-json/wp/v2/posts/"
    let discountUrlPathString = "http://www.melmel.com.au/wp-json/wp/v2/discounts/"
    let mediaUrlPathString = "http://www.melmel.com.au/wp-json/wp/v2/media/"
    let commentUrlPathString = "http://melmel.com.au/wp-json/wp/v2/comments/"
    
    
    let searchPostURL = "http://melmel.com.au/wp-json/wp/v2/posts?per_page=5&filter[s]="
    
    let postLastUpdateTimeKey = "postLastUpdateTime"
    let discountLastUpdateTimeKey = "discountLastUpdateTime"
    
    
    let session = URLSession.shared
  
    
    
    
    
    func getPostsFromAPI (_ postsAcquired:@escaping (_ postsArray: NSArray?, _ success: Bool) -> Void ){
        let session = URLSession.shared
        let postUrl:URL
        
        if let lastUpdateTimeObject = UserDefaults.standard.object(forKey: self.postLastUpdateTimeKey) {
            let lastUpdateTime = lastUpdateTimeObject as! Date
            let dateFormatter = DateFormatter()
            postUrl = URL(string: postUrlPathString+"?after=\(dateFormatter.formatDateToDateString(lastUpdateTime))")!
            print(dateFormatter.formatDateToDateString(lastUpdateTime))
            
        } else {
            postUrl = URL(string: postUrlPathString)!
        }
        
        
        
        session.dataTask(with: postUrl, completionHandler: { (data, response, error) in
            if let responseData = data {
                let date = Date()
                //NSUserDefaults.standardUserDefaults().setObject(date, forKey: self.postLastUpdateTimeKey)
                
                do{
                    let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                    if let postsArray = json as? NSArray{
                        postsAcquired(postsArray,true)
                        UserDefaults.standard.set(date, forKey: self.postLastUpdateTimeKey)
                    }
                    else {
                        postsAcquired(nil,false)
                    }
                } catch {
                    postsAcquired(nil,false)
                    print("could not serialize!")
                }
                
            }
        }).resume()
        
        
    }
    
    // Get discounts from API
    func getDiscountsFromAPI (_ discountsAcquired:@escaping (_ discountsArray: NSArray?, _ success: Bool) -> Void ){
        
        let session = URLSession.shared
        let postUrl:URL
        
        if let lastUpdateTimeObject = UserDefaults.standard.object(forKey: self.discountLastUpdateTimeKey) {
            let lastUpdateTime = lastUpdateTimeObject as! Date
            let dateFormatter = DateFormatter()
            postUrl = URL(string: discountUrlPathString+"?after=\(dateFormatter.formatDateToDateString(lastUpdateTime))")!
            print(postUrl.absoluteString)
            
        } else {
            postUrl = URL(string: discountUrlPathString)!
        }
        
        
        
        session.dataTask(with: postUrl, completionHandler: { data, response, error in
            
            if let responseData = data {
                let date = Date()
                
                
                do{
                    let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                    if let postsArray = json as? NSArray{
                        discountsAcquired(postsArray,true)
                        UserDefaults.standard.set(date, forKey: self.discountLastUpdateTimeKey)
                    }
                    else {
                        discountsAcquired(nil,false)
                    }
                } catch {
                    discountsAcquired(nil,false)
                    print("could not serialize!")
                }
            }
        }).resume()
        
        
    }
    
    
    
    /* Get All Media */
    func getAllMediaFromAPI(_ mediaAcquired:@escaping (_ mediaArray:NSArray?,_ success:Bool) -> Void){
        let url = URL(string: mediaUrlPathString)
        session.dataTask(with: url!, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            if let responseData = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                    if let mediaList = json as? NSArray{
                        mediaAcquired(mediaList,true)
                    }
                    else {
                        mediaAcquired(nil, false)
                    }
                } catch{
                    mediaAcquired(nil, false)
                }
            }
        } as! (Data?, URLResponse?, Error?) -> Void) .resume()
    }
    

    
    
    func getPreviousPosts(_ postType: PostType, beforeDate: Date, excludeId: Int, completionHandler:@escaping (_ resultsArray:NSArray?, _ success:Bool) -> Void ) {
        var baseURIString:String!
        switch postType {
        case .Post:baseURIString = postUrlPathString
        case .Discount:baseURIString = discountUrlPathString
        case .Comment:baseURIString = commentUrlPathString
        default:break
        }
        
        
        let session = URLSession.shared
        
        let dateFormatter = DateFormatter()
        let beforeDateString = dateFormatter.formatDateToDateString(beforeDate)

        let url = URL(string: "\(baseURIString)?before=\(beforeDateString)&exclude=\(excludeId)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlFragmentAllowed)!)
        print("\(baseURIString)?before=\(beforeDateString)&exclude=\(excludeId)")
        
        session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error)
            }

            if let responseData = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                    if let resultsArray = json as? NSArray{
                        completionHandler(resultsArray,true)
                    }
                    else {
                        completionHandler(nil, false)
                    }
                }catch{
                    completionHandler(nil, false)
                }
            }

        }.resume()
        
        
    }
    
    
    
    
    // General Purpose get Posts
    func getPostsFromAPI(_ postType:PostType,params:[(String,String)],completionHandler:@escaping (_ postsArray: NSArray?, _ success: Bool) -> Void ) {
        
        let session = URLSession.shared
        let url = buildURLComponent(postType, params: params)
        
        
        session.dataTask(with: url.url!, completionHandler: { data, response, error in
            
            if let responseData = data {
                //let date = NSDate()
                //NSUserDefaults.standardUserDefaults().setObject(date, forKey: self.postLastUpdateTimeKey)
                
                do{
                    let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                    if let postsArray = json as? NSArray{
                        completionHandler(postsArray,true)
                    }
                    else {
                        completionHandler(nil,false)
                    }
                } catch {
                    completionHandler(nil,false)
                    print("could not serialize!")
                }
            }
        }).resume()
    }
    
    func postPostToAPI(_ postType:PostType,params:[(String,String)],completionHandler:@escaping ()->Void){
        let url = buildURLComponent(.Comment, params: params)
        //let request = NSMutableURLRequest(url: url.url!)
        
        //request.httpMethod = HTTPMethod.Post.rawValue
        var request = URLRequest(url: url.url!)
        request.httpMethod = HTTPMethod.Post.rawValue
        

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil && data != nil
                else {
                    print("error\(error)")
                    return
            }
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            completionHandler()
        }.resume()
        
        
    }
    
    
    
    
    /*
     Build URL using NSURLComponents
     */
    func buildURLComponent(_ postType:PostType,params:[(String,String)]) -> URLComponents{
        var url = URLComponents()
        url.scheme = "http"
        url.host = "www.melmel.com.au"
        
        url.path = "/wp-json/wp/v2/\(postType.rawValue)"
        var queryItems = [URLQueryItem]()
        
        for param in params {
            queryItems.append(URLQueryItem(name: param.0, value: param.1))
        }
        
        url.queryItems = queryItems
        print(url.string!)
        return url
    }
}
    
    
//    func searchPosts(searchText:String,completionHandler:(resultsArray:NSArray?, success:Bool) -> Void ){
//        
//        let session = NSURLSession.sharedSession()
//        let postURL = searchPostURL + searchText
//        let postFinalURL = NSURL(string: postURL)!
//       // let postUrl = self.endpointURL + self.searchText!
//      //  let postFinalURL = NSURL(string: postUrl)!
//        
//        
//        
//        session.dataTaskWithURL(postFinalURL){ (data:NSData?, response:NSURLResponse?, error: NSError?) -> Void in
//            
//            if let responseData = data {
//                
//                do{
//                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments)
//                    if let postsArray = json as? NSArray{
//                        postsAcquired(postsArray:postsArray,success:true)
//                    }
//                    else {
//                        postsAcquired(postsArray:nil,success:false)
//                    }
//                } catch {
//                    postsAcquired(postsArray:nil,success:false)
//                    print("could not serialize!")
//                }
//            }
//            }.resume()
//        
//        

