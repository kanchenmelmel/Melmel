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
                    post.date=NSDate()
                    //Title
                    let titleObject = postEntry["title"] as! Dictionary<String,String>
                    
                    post.title = titleObject["rendered"]!
                    //Link
                    post.link = postEntry["link"] as! String
                    
                    self.posts.append(post)
                }
                print(self.posts.count)
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
                        do{
                            try self.managedObjectContext.save()
                        } catch {
                            print("There is error while saving managed objects")
                        }
                        completeHandler()
                        
                    }
                    else {
                        print("There is problem while getting featured image!")
                    }
                    
                }) // End getAllMediaFromAPI

                
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
