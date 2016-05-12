//
//  FileDownloader.swift
//  Melmel
//
//  Created by Work on 9/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class FileDownloader {
    func downloadImageFromUrlAndSave(imageUrlString:String, imageStorageLocationString:String, completionHandler:(image:UIImage) -> Void){
        let session = NSURLSession.sharedSession()
        
        let URL = NSURL(string: imageUrlString)!
        
        session.dataTaskWithURL(URL) { (data:NSData?, response:NSURLResponse?, error:NSError?) in
            if data != nil {
                let image = UIImage(data: data!)
                completionHandler(image: image!)
            }
        }.resume()
    }
    
    func saveImageFile(image:UIImage, postId:Int,fileName:String) {
        let imgData = UIImagePNGRepresentation(image)
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        imgData!.writeToFile(documentDirectory+"/post/\(postId)/\(fileName)", atomically:true)//Write image to disk
    }
}
