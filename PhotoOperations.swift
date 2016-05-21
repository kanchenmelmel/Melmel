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
    init(post: Post) {
        self.post = post
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        let imageData = NSData(contentsOfURL:NSURL(string:post.featured_media!.link!)!)
        
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