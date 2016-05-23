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
    let discount:Discount
    init(discount: Discount) {
        self.discount = discount
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        let imageData = NSData(contentsOfURL:NSURL(string:discount.featured_image_url!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!)
        
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