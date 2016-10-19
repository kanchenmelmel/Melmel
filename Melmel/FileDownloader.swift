//
//  FileDownloader.swift
//  Melmel
//
//  Created by Work on 9/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

//this class uses a image url string and then downloads the image of the url and returns an image in completionHandler
class FileDownloader {
    func downloadFeaturedImageForPostFromUrlAndSave(_ imageUrlString:String, postId:Int, completionHandler:@escaping (_ image:UIImage) -> Void){
        let session = URLSession.shared
        
        let URL = Foundation.URL(string: imageUrlString)!
        let request = URLRequest(url: URL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        
        session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) in
            if data != nil {
                let image = UIImage(data: data!)
                
                self.saveImageFile(image!, postId: postId, fileName: "featured_image.jpg")
                
                
                completionHandler(image!)
            }
        } as! (Data?, URLResponse?, Error?) -> Void) .resume()
    }
    
    func saveImageFile(_ image:UIImage, postId:Int,fileName:String) {
        let imgData = UIImageJPEGRepresentation(image, 1.0)
        
        let fileManager = FileManager.default
        
        
        
        let documentDirectory = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let postDirectoryLocation = documentDirectory.appendingPathComponent("posts")
        // Create post Directory
        do {
            try fileManager.createDirectory(at: postDirectoryLocation, withIntermediateDirectories: true, attributes: nil)
        } catch {
            
        }
        
        let imageLocation = postDirectoryLocation.appendingPathComponent("\(postId)")
        // Create image Directory
        do {
            try fileManager.createDirectory(at: imageLocation, withIntermediateDirectories: true, attributes: nil)
        }catch{}//
        
        let imageURL = imageLocation.appendingPathComponent(fileName)
        try? imgData!.write(to: URL(fileURLWithPath: imageURL.path), options: [.atomic])//Write image to disk
    }
    
    
    func imageFromFile(_ postId:Int,fileName:String) -> UIImage{
        let documentDirectory = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let postDirectoryLocation = documentDirectory.appendingPathComponent("posts")
        
        let imageLocation = postDirectoryLocation.appendingPathComponent("\(postId)").appendingPathComponent("\(fileName)")
        
        let image = UIImage(contentsOfFile: imageLocation.path)
        return image!
    }
}
