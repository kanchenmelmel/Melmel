//
//  PostsUpdateUitility.swift
//  Melmel
//
//  Created by Work on 8/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import CoreData




class PostsUpdateUtility {
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // UpdatePosts
    func updateAllPosts(completionHandler:() -> Void){
        var posts:[Post] = []
        let apiHelper = APIHelper()
        
        
        
        
        apiHelper.getPostsFromAPI { (postsArray, success) in
            if success {
                
                
                // create dispatch group
                
                for postEntry in postsArray! {
                    let post = NSEntityDescription.insertNewObjectForEntityForName("Post", inManagedObjectContext: self.managedObjectContext) as! Post
                    //id
                    post.id = postEntry["id"] as! Int
                    
                    //Date
                    let dateString = postEntry["date"] as! String
                    let dateFormatter = DateFormatter()
                    post.date = dateFormatter.formatDateStringToMelTime(dateString)
                    //Title
                    post.title = postEntry["title"] as! String
                    
                    //Link
                    post.link = postEntry["link"] as! String
                    
                    //Media
                    
                    post.featured_image_downloaded = false
                    
                    if postEntry["featured_image_url"] != nil {
                        post.featured_image_url = postEntry["thumbnail_url"] as? String
                    }


                    posts.append(post)
                    
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
    func updateDiscounts(completionHandler:() -> Void){
        let apiHelper = APIHelper()
        
        apiHelper.getDiscountsFromAPI { (discountArray, success) in
            if success {
                
                for discountEntry in discountArray! {
                    let discount = NSEntityDescription.insertNewObjectForEntityForName("Discount", inManagedObjectContext: self.managedObjectContext) as! Discount
                        //id
                    discount.id = discountEntry["id"] as! Int
                    
                    //Date
                    let dateString = discountEntry["date"] as! String
                    let dateFormatter = DateFormatter()
                    discount.date = dateFormatter.formatDateStringToMelTime(dateString)
                    //Title
                    discount.title = discountEntry["title"] as! String
                    
                    //Link
                    discount.link = discountEntry["link"] as! String
                    //Coordinate and address

                    discount.featured_image_downloaded = false
                    discount.address = discountEntry["address"] as! String
                    
                    
                    let latitudeString = discountEntry["latitude"] as! String
                    let longitudeString = discountEntry["longtitude"] as! String

                    discount.latitude = Double(latitudeString)


                    discount.longtitude = Double(longitudeString)


                    //Featured image Link
                    discount.featured_image_url = discountEntry["thumbnail_url"] as? String
                    
                }//End of for-in loop
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                }
            }
            completionHandler()
            
        }// end getPostsFromAPI
    }
    
    func getPreviousPosts(beforeDate:NSDate,excludeId:Int,completionHandler:() -> Void){
        var posts:[Post] = []
        let apiHelper = APIHelper()
        
        
        

        apiHelper.getPreviousPosts(.Post, beforeDate: beforeDate, excludeId: excludeId)
        { (postsArray, success) in
            if success {
                
                // create dispatch group
                
                
                for postEntry in postsArray! {
                   
                    let post = NSEntityDescription.insertNewObjectForEntityForName("Post", inManagedObjectContext: self.managedObjectContext) as! Post
                    
                    
                    //id
                    post.id = postEntry["id"] as! Int
                    
                    //Date
                    let dateString = postEntry["date"] as! String
                    let dateFormatter = DateFormatter()
                    post.date = dateFormatter.formatDateStringToMelTime(dateString)
                    //Title
                    post.title = postEntry["title"] as! String
                    
                    //Link
                    post.link = postEntry["link"] as! String
                    
                    //Media
                    
                    if postEntry["featured_image_url"] != nil {
                        post.featured_image_url = postEntry["featured_image_url"] as? String
                    }
                    
                    
                    posts.append(post)
                    
                }//End postsArray Loop
                
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                }
                
                
                completionHandler()
            }
            else {}
        } // end getPostsFromAPI
        
}
    
    func getPreviousDiscounts(beforeDate:NSDate,excludeId:Int,completionHandler:() -> Void){
       
        let apiHelper = APIHelper()
        
        
        
        
        apiHelper.getPreviousPosts(.Discount, beforeDate: beforeDate, excludeId: excludeId)
        { (postsArray, success) in
            if success {
                
                // create dispatch group
                
                
                for discountEntry in postsArray! {
                    
                    let discount = NSEntityDescription.insertNewObjectForEntityForName("Discount", inManagedObjectContext: self.managedObjectContext) as! Discount
                    
                    
                    //id
                    discount.id = discountEntry["id"] as! Int
                    
                    //Date
                    let dateString = discountEntry["date"] as! String
                    let dateFormatter = DateFormatter()
                    discount.date = dateFormatter.formatDateStringToMelTime(dateString)
                    //Title
                    discount.title = discountEntry["title"] as! String
                    
                    //Link
                    discount.link = discountEntry["link"] as! String
                    
                    //Coordinate and address
                    
                    discount.featured_image_downloaded = false
                    discount.address = discountEntry["address"] as! String
                    
                    
                    let latitudeString = discountEntry["latitude"] as! String
                    let longitudeString = discountEntry["longtitude"] as! String
                    
                    discount.latitude = Double(latitudeString)
                    
                    
                    discount.longtitude = Double(longitudeString)
                    
                    //Media
                    
                    if discountEntry["featured_image_url"] != nil {
                        discount.featured_image_url = discountEntry["featured_image_url"] as? String
                    }
                    
                    
                    
                }//End postsArray Loop
                
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                }
                
                
                completionHandler()
            }
            else {}
        } // end getPostsFromAPI
        
    }

    
    
    
    func fetchPosts() -> [Post] {
        
        let request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName("Post", inManagedObjectContext: managedObjectContext)
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors=[dateSort]
        do{
            let results = try managedObjectContext.executeFetchRequest(request) as! [Post]
            
            return results
        }catch {}
        return [Post]()
    }
    
    func fetchDiscounts() -> [Discount] {
        
        let request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName("Discount", inManagedObjectContext: managedObjectContext)
        do{
            let results = try managedObjectContext.executeFetchRequest(request) as! [Discount]
            
            return results
        }catch {}
        return [Discount]()
    }
    
    
    
}
