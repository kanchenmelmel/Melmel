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
    var posts:[Post] = []
    
    
    func updateAllPosts(completeHandler:() -> Void){
        let apiHelper = APIHelper()
        
        

        
        apiHelper.getPostsFromAPI { (postsArray, success) in
            if success {
                
                
                // create dispatch group
                let downloadGroup = dispatch_group_create()
                

                
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
                    
                    
                    dispatch_group_enter(downloadGroup) // enter dispatch group
                    //Media
                    let mediaId = postEntry["featured_media"] as! Int
                    apiHelper.getMediaById(mediaId, mediaAcquired: { (mediaDictionary, success) in
                        if success {
                            let featuredMedia = NSEntityDescription.insertNewObjectForEntityForName("Media", inManagedObjectContext: self.managedObjectContext) as! Media
                            
                            // Media Id
                            featuredMedia.id = mediaId
                            // Media Link
                            
                            featuredMedia.link = mediaDictionary!["source_url"] as! String
                            post.featured_media = featuredMedia
                            
                            
                            
                        } else {}
                    })// End getMediaById
                    // leave dispatch group
                    dispatch_group_leave(downloadGroup)
                    self.posts.append(post)
                
                }//End postsArray Loop

                
                
                dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER)
                do {
                    try self.managedObjectContext.save()
                } catch {
                }
               
            
                print(self.posts.count)
   
            }
            else {}
        } // end getPostsFromAPI
        

        
        
        
        

    }
    
    
    func fetchPosts() -> [Post] {
        let request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName("Post", inManagedObjectContext: managedObjectContext)
        do{
            let results = try managedObjectContext.executeFetchRequest(request) as! [Post]
            
            return results
        }catch {}
     return [Post]()
    }
    
    
    
}
