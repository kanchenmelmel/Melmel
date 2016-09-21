//
//  PhotoOperation.swift
//  Melmel
//
//  Created by Work on 21/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit


class PendingOperations {
    lazy var downloadsInProgress = [IndexPath:Operation]()
    
    
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}


//this class inherits NSOperation, using operation queues to download posts images at the background thread
class ImageDownloader:Operation {
    let post:Post
    
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    init(post: Post) {
        self.post = post
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        
        
        if self.isCancelled {
            return
        }
        
        
        let imageData = try? Data(contentsOf: URL(string:post.featured_image_url!.addingPercentEscapes(using: String.Encoding.utf8)!)!)
        
        if imageData?.count != 0 {
            let image = UIImage(data: imageData!)
            self.post.featuredImage = image
            
            let saver = FileDownloader()
            saver.saveImageFile(image!, postId: post.id! as Int, fileName: FEATURED_IMAGE_NAME)
            post.featured_image_downloaded = true
            do {
                try post.managedObjectContext?.save()
            } catch {
                print("unable to update image to core data")
            }
            
            
        }
            
        else {
            self.post.featuredImageState = .failed
            self.post.featuredImage = UIImage(named: "failed")
            
        }
    }
    
}

//this class inherits NSOperation, using operation queues to download discount images at the background thread
class DiscountImageDownloader:Operation {
    let discount:Discount
    init(discount: Discount) {
        self.discount = discount
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        let imgUrl = URL(string:discount.featured_image_url!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        let imageData = try? Data(contentsOf: imgUrl!)
        
        if self.isCancelled {
            return
        }
        
        if imageData?.count != 0 {
            let image = UIImage(data: imageData!)
            self.discount.featuredImage = image
            
            let saver = FileDownloader()
            saver.saveImageFile(image!, postId: discount.id! as Int, fileName: FEATURED_IMAGE_NAME)
            discount.featured_image_downloaded = true
            
            do {
                try discount.managedObjectContext?.save()
            } catch {
                print("unable to save discount image to core data")
            }
            
            
        //    self.discount.featuredImage = UIImage(data: imageData!)
        //    self.discount.featuredImageState = .Downloaded
            
        }
            
        else {
            self.discount.featuredImageState = .failed
            self.discount.featuredImage = UIImage(named: "failed")
            
        }
    }
    
    
    
}

//this class inherits NSOperation, using operation queues to download searched posts images at the background thread
class SearchImageDownloader:Operation {
    let post:Post
    init(post: Post) {
        self.post = post
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        let imageData = try? Data(contentsOf: URL(string:post.featured_image_url!.addingPercentEscapes(using: String.Encoding.utf8)!)!)
        
        if self.isCancelled {
            return
        }
        
        if imageData?.count != 0 {
            self.post.featuredImage = UIImage(data: imageData!)
            self.post.featuredImageState = .downloaded
            
        }
            
        else {
            self.post.featuredImageState = .failed
            self.post.featuredImage = UIImage(named: "failed")
            
        }
    }
    
    
    
}
//this class inherits NSOperation, using operation queues to download searched discounts images at the background thread
class SearchDiscountImageDownloader:Operation {
    let discount:Discount
    init(discount: Discount) {
        self.discount = discount
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        if self.isCancelled {
            return
        }
        
        let imageData = try? Data(contentsOf: URL(string:discount.featured_image_url!.addingPercentEscapes(using: String.Encoding.utf8)!)!)
        
        
        
        if imageData?.count != 0 {
            self.discount.featuredImage = UIImage(data: imageData!)
            self.discount.featuredImageState = .downloaded
            
        }
            
        else {
            self.discount.featuredImageState = .failed
            self.discount.featuredImage = UIImage(named: "failed")
            
        }
    }
    
    
    
}
