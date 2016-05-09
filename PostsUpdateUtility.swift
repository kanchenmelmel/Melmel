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
    
    
    func updateAllPosts(){
        let apiHelper = APIHelper()
        
        apiHelper.getPostsFromAPI { (postsArray, success) in
            if success {
                
                
                for postEntry in postsArray! {
                    let post = NSEntityDescription.insertNewObjectForEntityForName("Post", inManagedObjectContext: self.managedObjectContext) as! Post
                    //id
                    post.id = postEntry["id"] as! Int
                
                    //Date
                    post.date=NSDate()
                    //Title
                    let titleObject = postEntry["title"] as! Dictionary<String,String>
                    
                    post.title = titleObject["rendered"]!
                    //Link
                    post.link = postEntry["link"] as! String
                    
                    self.posts.append(post)
                }
                
            }
            else {}
        } // end getPostsFromAPI
        
        //Media
        apiHelper.getAllMediaFromAPI({ (mediaList, success) in
            if success {
                for post in self.posts {
                    
                    var mediaIndex = 0
                    while mediaIndex < mediaList!.count && post.id != mediaList![mediaIndex]["post"] as! Int {
                        mediaIndex += 1
                    }
                    if mediaList!.count != 0 && mediaIndex != mediaList!.count {
                        let media = NSEntityDescription.insertNewObjectForEntityForName("Media", inManagedObjectContext: self.managedObjectContext) as! Media
                        // Media Link
                        let guidObject = mediaList![mediaIndex]["guid"] as! Dictionary<String,String>
                        media.link = guidObject["rendered"]
                        
                        // Media Id
                        media.id = mediaList![mediaIndex]["id"] as! Int
                        
                        
                        post.featured_media = media
                    }
                }
                
//                let media = NSEntityDescription.insertNewObjectForEntityForName("Media", inManagedObjectContext: self.managedObjectContext) as! Media
//                let guidObject = mediaDictionary!["guid"] as! Dictionary<String,String>
//                
//                media.link = guidObject["rendered"]
//                post.featured_media=media
//                self.mediaArray.append(media)
                
            }
            else {
                print("There is problem while getting featured image!")
            }
            
        })
        
        

    }
}
