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
                    let titleObject = postEntry["title"] as! Dictionary<String,String>
                    
                    post.title = titleObject["rendered"]!
                    //Link
                    post.link = postEntry["link"] as! String
                    
                    //Media
                    
                    if postEntry["featured_image_url"] != nil {
                        post.featured_image_url = postEntry["featured_image_url"] as? String
                    }
//                    apiHelper.getMediaById(mediaId, mediaAcquired: { (mediaDictionary, success) in
//                        if success {
//                            let featuredMedia = NSEntityDescription.insertNewObjectForEntityForName("Media", inManagedObjectContext: self.managedObjectContext) as! Media
//                            
//                            // Media Id
//                            featuredMedia.id = mediaId
//                            // Media Link
//                            
//                            featuredMedia.link = mediaDictionary!["source_url"] as! String
//                            post.featured_media = featuredMedia
//                            
//                            
//                            
//                        } else {}
//                    })// End getMediaById
//                    // leave dispatch group

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
                    let titleObject = discountEntry["title"] as! Dictionary<String,String>
                    
                    discount.title = titleObject["rendered"]!
                    //Link
                    discount.link = discountEntry["link"] as! String
                    //Coordinate and address
                    let locationObject = discountEntry["location"] as! Dictionary<String,String>
                    let latitudeString = locationObject["latitude"]!
                    discount.latitude = Double(latitudeString)
                    let longtitudeString = locationObject["longtitude"]!
                    discount.longtitude = Double(longtitudeString)
                    discount.address = locationObject["address"]!
                    //Featured image Link
                    discount.featured_image_url = discountEntry["featured_image_url"] as? String
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                    }
                }//End of for-in loop
            }
            completionHandler()
            
        }// end getPostsFromAPI
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
