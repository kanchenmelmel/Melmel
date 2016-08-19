//
//  PhotoOperation.swift
//  Melmel
//
//  Created by Work on 21/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class PendingOperations {
    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    
    
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class ImageDownloader:NSOperation {
    let post:Post
    
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    init(post: Post) {
        self.post = post
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        
        
        if self.cancelled {
            return
        }
        
        
        let imageData = NSData(contentsOfURL:NSURL(string:post.featured_image_url!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
        
        if imageData?.length != 0 {
            let image = UIImage(data: imageData!)
            self.post.featuredImage = image
            
            let saver = FileDownloader()
            saver.saveImageFile(image!, postId: post.id! as Int, fileName: FEATURED_IMAGE_NAME)
            post.featured_image_downloaded = true
            try! post.managedObjectContext?.save()
        }
            
        else {
            self.post.featuredImageState = .Failed
            self.post.featuredImage = UIImage(named: "failed")
            
        }
    }
    
}


class DiscountImageDownloader:NSOperation {
    let discount:Discount
    init(discount: Discount) {
        self.discount = discount
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        let imgUrl = NSURL(string:discount.featured_image_url!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        let imageData = NSData(contentsOfURL:imgUrl!)
        
        if self.cancelled {
            return
        }
        
        if imageData?.length != 0 {
            let image = UIImage(data: imageData!)
            self.discount.featuredImage = image
            
            let saver = FileDownloader()
            saver.saveImageFile(image!, postId: discount.id! as Int, fileName: FEATURED_IMAGE_NAME)
            discount.featured_image_downloaded = true
            try! discount.managedObjectContext?.save()
            
        //    self.discount.featuredImage = UIImage(data: imageData!)
        //    self.discount.featuredImageState = .Downloaded
            
        }
            
        else {
            self.discount.featuredImageState = .Failed
            self.discount.featuredImage = UIImage(named: "failed")
            
        }
    }
    
    
    
}


class SearchImageDownloader:NSOperation {
    let post:Post
    init(post: Post) {
        self.post = post
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        let imageData = NSData(contentsOfURL:NSURL(string:post.featured_image_url!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
        
        if self.cancelled {
            return
        }
        
        if imageData?.length != 0 {
            self.post.featuredImage = UIImage(data: imageData!)
            self.post.featuredImageState = .Downloaded
            
        }
            
        else {
            self.post.featuredImageState = .Failed
            self.post.featuredImage = UIImage(named: "failed")
            
        }
    }
    
    
    
}

class SearchDiscountImageDownloader:NSOperation {
    let discount:Discount
    init(discount: Discount) {
        self.discount = discount
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        let imageData = NSData(contentsOfURL:NSURL(string:discount.featured_image_url!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
        
        if self.cancelled {
            return
        }
        
        if imageData?.length != 0 {
            self.discount.featuredImage = UIImage(data: imageData!)
            self.discount.featuredImageState = .Downloaded
            
        }
            
        else {
            self.discount.featuredImageState = .Failed
            self.discount.featuredImage = UIImage(named: "failed")
            
        }
    }
    
    
    
}