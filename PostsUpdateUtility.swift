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
                    let mediaId = postEntry["featured_media"] as! Int
                    apiHelper.getMediaById(mediaId, mediaAcquired: { (mediaDictionary, success) in
                        if success {
                            let featuredMedia = NSEntityDescription.insertNewObjectForEntityForName("Media", inManagedObjectContext: self.managedObjectContext) as! Media
                            
                            // Media Id
                            featuredMedia.id = mediaId
                            // Media Link
                            
                            featuredMedia.link = mediaDictionary!["source_url"] as! String
                            post.featured_media = featuredMedia
                            self.posts.append(post)
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                            }
                            
                        } else {}
                    })// End getMediaById
                
                }//End postsArray Loop
               
            
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
