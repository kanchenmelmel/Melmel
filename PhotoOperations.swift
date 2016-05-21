//
//  PhotoOperation.swift
//  Melmel
//
//  Created by Work on 21/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class PhotoOperations {
    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class ImageDownloader:NSOperation {
    let image:Image
    init(image: Image) {
        self.image = image
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        let imageData = NSData(contentsOfURL:image.url)
        
        if self.cancelled {
            return
        }
        
        if imageData?.length != 0 {
            self.image.image = UIImage(data: imageData!)
            self.image.state = .Downloaded
            
        }
        
        else {
            self.image.state = .Failed
            self.image.image = UIImage(named: "failed")
            
        }
    }
    
    
}