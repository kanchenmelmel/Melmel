//
//  FileDownloader.swift
//  Melmel
//
//  Created by Work on 9/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class FileDownloader {
    func downloadFeaturedImageForPostFromUrlAndSave(imageUrlString:String, postId:Int, completionHandler:(image:UIImage) -> Void){
        let session = NSURLSession.sharedSession()
        
        let URL = NSURL(string: imageUrlString)!
        let request = NSURLRequest(URL: URL, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 10)
        
        session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            if data != nil {
                let image = UIImage(data: data!)
                
                self.saveImageFile(image!, postId: postId, fileName: "featured_image.jpg")
                
                
                completionHandler(image: image!)
            }
        }.resume()
    }
    
    func saveImageFile(image:UIImage, postId:Int,fileName:String) {
        let imgData = UIImageJPEGRepresentation(image, 1.0)
        
        let fileManager = NSFileManager.defaultManager()
        
        
        
        let documentDirectory = try! NSFileManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        let postDirectoryLocation = documentDirectory.URLByAppendingPathComponent("posts")
        // Create post Directory
        do {
            try fileManager.createDirectoryAtURL(postDirectoryLocation, withIntermediateDirectories: true, attributes: nil)
        } catch {
            
        }
        
        let imageLocation = postDirectoryLocation.URLByAppendingPathComponent("\(postId)")
        // Create image Directory
        do {
            try fileManager.createDirectoryAtURL(imageLocation, withIntermediateDirectories: true, attributes: nil)
        }catch{}//
        
        let imageURL = imageLocation.URLByAppendingPathComponent(fileName)
        imgData!.writeToFile(imageURL.path!, atomically:true)//Write image to disk
    }
    
    
    func imageFromFile(postId:Int,fileName:String) -> UIImage{
        let documentDirectory = try! NSFileManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        let postDirectoryLocation = documentDirectory.URLByAppendingPathComponent("posts")
        
        let imageLocation = postDirectoryLocation.URLByAppendingPathComponent("\(postId)").URLByAppendingPathComponent("\(fileName)")
        
        let image = UIImage(contentsOfFile: imageLocation.path!)
        return image!
    }
}
