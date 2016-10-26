//
//  PostsUpdateUitility.swift
//  Melmel
//
//  Created by Work on 8/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import CoreData



//this class manages the data storage using coredtata, it ultilises the APIhelper class to download the data, then save the data into Coredata
class PostsUpdateUtility {
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    // UpdatePosts
    func updateAllPosts(_ completionHandler:@escaping () -> Void){
        var posts:[Post] = []
        let apiHelper = APIHelper()
        let coreDataUtility = CoreDataUtility()
        
        
        
        
        apiHelper.getPostsFromAPI { (postsArray, success) in
            if success {
                
                
                // create dispatch group
                
                for postEntry in postsArray! {
                    
                    let _post = postEntry as! [String:AnyObject]
                    //id
                    let id = _post["id"] as! Int
                    if !coreDataUtility.checkIdExist(id, entityType: .Post) {
                        let post = NSEntityDescription.insertNewObject(forEntityName: "Post", into: self.managedObjectContext) as! Post
                        post.id = id as NSNumber?
                        
                        //Date
                        let dateString = _post["date"] as! String
                        let dateFormatter = DateFormatter()
                        post.date = dateFormatter.formatDateStringToMelTime(dateString)
                        //Title
                        post.title = _post["title"] as? String
                        
                        //Link
                        post.link = _post["link"] as? String
                        
                        //Media
                        
                        post.featured_image_downloaded = false
                        
                        if _post["featured_image_url"] != nil {
                            post.featured_image_url = _post["thumbnail_url"] as? String
                        }
                        
                        
                        posts.append(post)
                    }
                    
                }//End postsArray Loop
                
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                }
                
                
                print(posts.count)
                completionHandler()
            }
            else {}
        } // end getPostsFromAPI
        
        
    }
    
    
    /* Update discounts */
    func updateDiscounts(_ completionHandler:@escaping () -> Void){
        let apiHelper = APIHelper()
        
        apiHelper.getDiscountsFromAPI { (discountArray, success) in
            if success {
                
                let _ = JSONParser.parseDiscountJSONArrayToDiscountArray(discountArray, checkConsistency: true, ifInsertIntoManagedContext: true)
                
                do {
                    try self.managedObjectContext.save()
                } catch {}
            }
            completionHandler()
            
        }// end getPostsFromAPI
    }
    
    /*
     Get filtered discounts from api
     */
    func updateFilterDiscounts(_ categoryId:String, completionHandler:@escaping (_ filteredDiscounts:[Discount],_ success:Bool) -> Void) {
        var discounts = [Discount]()
        let apiHelper = APIHelper()
        
        var params = [(String,String)]()
        params.append(("filter[posts_per_page]","-1"))
        params.append(("item_category",categoryId))
        apiHelper.getPostsFromAPI(.Discount, params: params) { (postsArray, success) in
            if success {
                discounts = JSONParser.parseDiscountJSONArrayToDiscountArray(postsArray, checkConsistency: false, ifInsertIntoManagedContext: false)
                
                print(discounts.count)
                DispatchQueue.main.async(execute: {
                    completionHandler(discounts,success)
                })
                
            }
            else {}
            
        }
    }
    
    
    
    func getPreviousPosts(_ beforeDate:Date,excludeId:Int,completionHandler:@escaping () -> Void) {
        var posts:[Post] = []
        let apiHelper = APIHelper()
        let coreDataUitility = CoreDataUtility()
        
        
        var params = [(String,String)]()
        let dateFormatter = DateFormatter()
        let beforeDateString = dateFormatter.formatDateToDateString(beforeDate)
        
        params.append(("before",beforeDateString))
        params.append(("exclude","\(excludeId)"))
        
        apiHelper.getPostsFromAPI(.Post, params: params) { (postsArray, success) in
            if success {
                for postEntry in postsArray! {
                    let _post = postEntry as! [String: AnyObject]
                    
                    let post = NSEntityDescription.insertNewObject(forEntityName: "Post", into: self.managedObjectContext) as! Post
                    
                    
                    //id
                    
                    let id = _post["id"] as! Int
                    if !coreDataUitility.checkIdExist(id, entityType: .Post){
                        post.id = id as NSNumber?
                        
                        //Date
                        let dateString = _post["date"] as! String
                        let dateFormatter = DateFormatter()
                        post.date = dateFormatter.formatDateStringToMelTime(dateString)
                        //Title
                        post.title = _post["title"] as? String
                        
                        //Link
                        post.link = _post["link"] as? String
                        
                        //Media
                        
                        if _post["featured_image_url"] != nil {
                            post.featured_image_url = _post["featured_image_url"] as? String
                        }
                        
                        
                        posts.append(post)
                    }
                    
                }//End postsArray Loop
                
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                }
                
                
                completionHandler()
            } else {
                print("There is something wrong while request previous posts!")
            }
        }
    }
    
    
    //    func _getPreviousPosts(_ beforeDate:Date,excludeId:Int,completionHandler:@escaping () -> Void){
    //        var posts:[Post] = []
    //        let apiHelper = APIHelper()
    //        let coreDataUitility = CoreDataUtility()
    //
    //
    //        apiHelper.getPreviousPosts(.Post, beforeDate: beforeDate, excludeId: excludeId)
    //        { (postsArray, success) in
    //            if success {
    //
    //                // create dispatch group
    //
    //
    //                for postEntry in postsArray! {
    //                    let _post = postEntry as! [String: AnyObject]
    //
    //                    let post = NSEntityDescription.insertNewObject(forEntityName: "Post", into: self.managedObjectContext) as! Post
    //
    //
    //                    //id
    //
    //                    let id = _post["id"] as! Int
    //                    if !coreDataUitility.checkIdExist(id, entityType: .Post){
    //                        post.id = id as NSNumber?
    //
    //                        //Date
    //                        let dateString = _post["date"] as! String
    //                        let dateFormatter = DateFormatter()
    //                        post.date = dateFormatter.formatDateStringToMelTime(dateString)
    //                        //Title
    //                        post.title = _post["title"] as? String
    //
    //                        //Link
    //                        post.link = _post["link"] as? String
    //
    //                        //Media
    //
    //                        if _post["featured_image_url"] != nil {
    //                            post.featured_image_url = _post["featured_image_url"] as? String
    //                        }
    //
    //
    //                        posts.append(post)
    //                    }
    //
    //                }//End postsArray Loop
    //
    //
    //                do {
    //                    try self.managedObjectContext.save()
    //                } catch {
    //                }
    //
    //
    //                completionHandler()
    //            }
    //            else {
    //                print("There is something wrong while requesting previous posts!")
    //            }
    //        } // end getPostsFromAPI
    
    //    }
    
    func getPreviousDiscounts(_ beforeDate:Date,excludeId:Int,completionHandler:@escaping () -> Void){
        
        let apiHelper = APIHelper()
        
        //let coreDataUitility = CoreDataUtility()
        
        
        var params = [(String,String)]()
        let dateFormatter = DateFormatter()
        let beforeDateString = dateFormatter.formatDateToDateString(beforeDate)
        
        params.append(("before",beforeDateString))
        params.append(("exclude","\(excludeId)"))
        
        apiHelper.getPostsFromAPI(.Discount, params: params) { (postsArray, success) in
            if success {
                
                // create dispatch group
                
                
                let _ = JSONParser.parseDiscountJSONArrayToDiscountArray(postsArray, checkConsistency: true, ifInsertIntoManagedContext: true)
                
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                }
                
                
                completionHandler()
            }
            else {}
        }
        
        
        
        
        
        // Old Function Block
        //        apiHelper.getPreviousPosts(.Discount, beforeDate: beforeDate, excludeId: excludeId)
        //        { (postsArray, success) in
        //            if success {
        //
        //                // create dispatch group
        //
        //
        //                let _ = JSONParser.parseDiscountJSONArrayToDiscountArray(postsArray, checkConsistency: true, ifInsertIntoManagedContext: true)
        //
        //
        //                do {
        //                    try self.managedObjectContext.save()
        //                } catch {
        //                }
        //
        //
        //                completionHandler()
        //            }
        //            else {}
        //        } // end getPostsFromAPI
        
    }
    
    
    
    
    func fetchPosts() -> [Post] {
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = NSEntityDescription.entity(forEntityName: "Post", in: managedObjectContext)
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors=[dateSort]
        do{
            let results = try managedObjectContext.fetch(request) as! [Post]
            return results
        }catch {}
        return [Post]()
    }
    
    func fetchDiscounts() -> [Discount] {
        
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = NSEntityDescription.entity(forEntityName: "Discount", in: managedObjectContext)
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors=[dateSort]
        do{
            let results = try managedObjectContext.fetch(request) as! [Discount]
            for result in results {
                let discountCategoryArray = result.discountCategories?.allObjects as! [DiscountCategoryEntity]
                for discountCatagory in discountCategoryArray {
                    if let catagoryId = discountCatagory.categoryId as? Int {
                        
                        let catagory = DiscountCatagoryRecognizer.recognizeCatagory(catagoryId, postType: .Discount)
                        if !result.catagories.contains(catagory) {
                            result.catagories.append(catagory)
                        }
                    }
                }
            }
            return results
        }catch {}
        return [Discount]()
    }
    
    
    func getAllDiscounts(_ completionHandler:@escaping (_ discounts:[Discount])->Void) {
        var discounts = [Discount]()
        let apiHelper = APIHelper()
        
        var params = [(String,String)]()
        params.append(("filter[posts_per_page]","-1"))
        apiHelper.getPostsFromAPI(.Discount, params: params) { (postsArray, success) in
            if success {
                discounts = JSONParser.parseDiscountJSONArrayToDiscountArray(postsArray, checkConsistency: false, ifInsertIntoManagedContext: false)
                
                print(discounts.count)
                DispatchQueue.main.async(execute: {
                    completionHandler(discounts)
                })
                
            }
            else {}
            
        }
    }
    
    func searchDiscountByKeyWords (_ keyWords:String, completionHandler:@escaping (_ discounts:[Discount]) -> Void) {
        var discounts = [Discount]()
        let apiHelper = APIHelper()
        
        var params = [(String,String)]()
        params.append(("search",keyWords))
        params.append(("filter[posts_per_page]","-1"))
        apiHelper.getPostsFromAPI(.Discount, params: params) { (postsArray, success) in
            if success {
                
                
                // create dispatch group
                
                for postEntry in postsArray! {
                    let _post = postEntry as! [String:AnyObject]
                    let discountDescription = NSEntityDescription.entity(forEntityName: "Discount", in: self.managedObjectContext)
                    let discount = Discount(entity: discountDescription!, insertInto: nil)
                    //id
                    discount.id = _post["id"] as? NSNumber
                    
                    //Date
                    let dateString = _post["date"] as! String
                    let dateFormatter = DateFormatter()
                    discount.date = dateFormatter.formatDateStringToMelTime(dateString)
                    //Title
                    discount.title = _post["title"] as? String
                    
                    //Link
                    discount.link = _post["link"] as? String
                    
                    //Media
                    
                    discount.featured_image_downloaded = false
                    
                    //Address and coordinates
                    discount.address = _post["address"] as? String
                    
                    
                    let latitudeString = _post["latitude"] as! String
                    let longitudeString = _post["longtitude"] as! String
                    
                    discount.latitude = Double(latitudeString) as NSNumber?
                    //print(discount.latitude)
                    
                    discount.longtitude = Double(longitudeString) as NSNumber?
                    
                    if _post["featured_image_url"] != nil {
                        discount.featured_image_url = _post["thumbnail_url"] as? String
                    }
                    let discountTag = _post["brand"] as? String
                    if discountTag != nil {
                        discount.discountTag = discountTag
                    }
                    
                    if let discountCatagories = _post["category"] as? NSArray{
                        for catagoryEntry in discountCatagories {
                            if let catagoryId = catagoryEntry as? Int {
                                
                                let catagory = DiscountCatagoryRecognizer.recognizeCatagory(catagoryId, postType: .Discount)
                                if !discount.catagories.contains(catagory) {
                                    discount.catagories.append(catagory)
                                    
                                }
                            }
                        }
                    }
                    
                    discounts.append(discount)
                    
                }//End postsArray Loop
                
                
                
                
                
                print(discounts.count)
                DispatchQueue.main.async(execute: {
                    completionHandler(discounts)
                })
                
            }
            else {}
            
        }
    }
    
    func searchPostsByKeyWords(_ keyWords:String, completionHandler:@escaping (_ posts:[Post]) -> Void) {
        var posts = [Post]()
        let apiHelper = APIHelper()
        
        var params = [(String,String)]()
        params.append(("search",keyWords))
        params.append(("filter[posts_per_page]","-1"))
        apiHelper.getPostsFromAPI(.Post, params: params) { (postsArray, success) in
            for postEntry in postsArray! {
                let _post = postEntry as! [String:AnyObject]
                
                let postDescription = NSEntityDescription.entity(forEntityName: "Post", in: self.managedObjectContext)
                
                let post = Post(entity: postDescription!, insertInto: nil)
                
                //id
                let id = _post["id"] as! Int
                post.id = id as NSNumber?
                
                //Date
                let dateString = _post["date"] as! String
                let dateFormatter = DateFormatter()
                post.date = dateFormatter.formatDateStringToMelTime(dateString)
                //Title
                post.title = _post["title"] as? String
                
                //Link
                post.link = _post["link"] as? String
                
                //Media
                
                post.featured_image_downloaded = false
                
                if _post["featured_image_url"] != nil {
                    post.featured_image_url = _post["thumbnail_url"] as? String
                }
                
                posts.append(post)
                
                
            }//End postsArray Loop
            completionHandler(posts)
            
        }
    }
    
    func getDiscountsForCatagory(){}
    
    func getPostComments(_ postID:String, completionHandler:@escaping (_ comments:[Comment]) -> Void) {
        let apiHelper = APIHelper()
        var commentsArray = [Comment]()
        
        var params = [(String,String)]()
        params.append(("post",postID))
        params.append(("filter[posts_per_page]","-1"))
        
        apiHelper.getPostsFromAPI(.Comment, params: params) { (commentArray, success) in
            if success {
                print (commentsArray.count)
                print ("--------------------")
                for commentEntry in commentArray!{
                    let _commeny = commentEntry as! [String:AnyObject]
                    
                    let comment = Comment()
                    
                    if let name = _commeny["author_name"] as? String {
                        comment.autherName = name
                    }
                    
                    if let date = _commeny["date"] as? String {
                        let dateFormatter = DateFormatter()
                        comment.date = dateFormatter.formatDateStringToMelTime(date)
                    }
                    
                    if let content = _commeny["content_raw"] as? String {
                        comment.content = content
                    }
                    
                    if let avatarDic = _commeny["author_avatar_urls"] as? Dictionary<String,String>{
                        comment.avatar = avatarDic["96"]!
                    }
                    
                    
                    commentsArray.append(comment)
                    
                }
                
                DispatchQueue.main.async(execute: {
                    completionHandler(commentsArray)
                })
            }
            else{}
        }
    }
    
}


class JSONParser {
    /* postArray: JSON Array
     postType; Type of post
     checkConsistency: if check the posts have already been in core data
     */
    
    static func parseDiscountJSONArrayToDiscountArray(_ postsArray:NSArray?,checkConsistency:Bool,ifInsertIntoManagedContext:Bool) -> [Discount]{
        let coreDataUtility = CoreDataUtility()
        
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var discounts = [Discount]()
        for postEntry in postsArray! {
            let post = postEntry as! [String : AnyObject]
            let status = post["status"] as! String
            if status == "publish" {
                let id = post["id"] as! Int
                if checkConsistency{
                    if !coreDataUtility.checkIdExist(id,entityType: .Discount){
                        
                        
                        let discountDescription = NSEntityDescription.entity(forEntityName: "Discount", in: managedObjectContext)
                        var managedObjectContextToBeInserted:NSManagedObjectContext?
                        managedObjectContextToBeInserted = managedObjectContext
                        if !ifInsertIntoManagedContext {
                            managedObjectContextToBeInserted = nil
                        }
                        let discount = Discount(entity: discountDescription!, insertInto: managedObjectContextToBeInserted)
                        //id
                        discount.id = post["id"] as! NSNumber?
                        
                        //Date
                        let dateString = post["date"] as! String
                        let dateFormatter = DateFormatter()
                        discount.date = dateFormatter.formatDateStringToMelTime(dateString)
                        //Title
                        discount.title = post["title"] as? String
                        
                        //Link
                        discount.link = post["link"] as? String
                        
                        //Media
                        
                        discount.featured_image_downloaded = false
                        
                        //Address and coordinates
                        discount.address = post["address"] as? String
                        
                        
                        let latitudeString = post["latitude"] as! String
                        let longitudeString = post["longtitude"] as! String
                        
                        discount.latitude = Double(latitudeString) as NSNumber?
                        //print(discount.latitude)
                        
                        discount.longtitude = Double(longitudeString) as NSNumber?
                        
                        if post["featured_image_url"] != nil {
                            discount.featured_image_url = post["thumbnail_url"] as? String
                        }
                        
                        let discountTag = post["brand"] as? String
                        if discountTag != nil {
                            discount.discountTag = discountTag
                        }
                        
                        if let discountCategories = post["category"] as? NSArray{
                            for catagoryEntry in discountCategories {
                                if let catagoryId = catagoryEntry as? Int {
                                    let discountCategoryEntityDescription = NSEntityDescription.entity(forEntityName: "DiscountCategoryEntity", in: managedObjectContext)
                                    
                                    let discountCategoryEntity = DiscountCategoryEntity(entity: discountCategoryEntityDescription!, insertInto: managedObjectContextToBeInserted)
                                    discountCategoryEntity.categoryId = catagoryId as NSNumber?
                                    
                                    discount.mutableSetValue(forKey: "discountCategories").add(discountCategoryEntity)
                                    let catagory = DiscountCatagoryRecognizer.recognizeCatagory(catagoryId, postType: .Discount)
                                    if !discount.catagories.contains(catagory) {
                                        discount.catagories.append(catagory)
                                        
                                    }
                                }
                            }
                        }
                        
                        discounts.append(discount)
                    }
                    
                }// end of checkConsistency
                else {
                    let discountDescription = NSEntityDescription.entity(forEntityName: "Discount", in: managedObjectContext)
                    var managedObjectContextToBeInserted:NSManagedObjectContext?
                    managedObjectContextToBeInserted = managedObjectContext
                    if !ifInsertIntoManagedContext {
                        managedObjectContextToBeInserted = nil
                    }
                    let discount = Discount(entity: discountDescription!, insertInto: managedObjectContextToBeInserted)
                    //id
                    discount.id = post["id"] as! NSNumber?
                    
                    //Date
                    let dateString = post["date"] as! String
                    let dateFormatter = DateFormatter()
                    discount.date = dateFormatter.formatDateStringToMelTime(dateString)
                    //Title
                    discount.title = post["title"] as? String
                    
                    //Link
                    discount.link = post["link"] as? String
                    
                    //Media
                    
                    discount.featured_image_downloaded = false
                    
                    //Address and coordinates
                    discount.address = post["address"] as? String
                    
                    
                    let latitudeString = post["latitude"] as! String
                    let longitudeString = post["longtitude"] as! String
                    
                    discount.latitude = Double(latitudeString) as NSNumber?
                    //print(discount.latitude)
                    
                    discount.longtitude = Double(longitudeString) as NSNumber?
                    
                    if post["featured_image_url"] != nil {
                        discount.featured_image_url = post["thumbnail_url"] as? String
                    }
                    let discountTag = post["brand"] as? String
                    if discountTag != nil {
                        discount.discountTag = discountTag
                    }
                    
                    if let discountCatagories = post["category"] as? NSArray{
                        for catagoryEntry in discountCatagories {
                            if let catagoryId = catagoryEntry as? Int {
                                
                                let catagory = DiscountCatagoryRecognizer.recognizeCatagory(catagoryId, postType: .Discount)
                                if !discount.catagories.contains(catagory) {
                                    discount.catagories.append(catagory)
                                }
                            }
                        }
                    }
                    discounts.append(discount)
                }
            }
            
            
        }//End postsArray Loop
        return discounts
    }
}
