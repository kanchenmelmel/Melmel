//
//  CommentViewController.swift
//  Melmel
//
//  Created by WuKaipeng on 28/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var mobileInput: UITextField!
    @IBOutlet weak var contentInput: UITextView!
    
    
   
    var postid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        

        // Do any additional setup after loading the view.
    }
    @IBAction func submitCom(sender: AnyObject) {
        
        let endpointURL = "http://melmel.com.au/wp-json/wp/v2/comments?"
        let post = "post=\(self.postid!)&"
        let name = "author_name=\(nameInput.text!)&"
        let mobile = "mobile=\(mobileInput.text!)&"
        let content = "content=\(contentInput.text!)"
        
        let urlWithParams = endpointURL+post+name+mobile+content
        

        let myURL = NSURL(string: urlWithParams.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        
        
        
        let request = NSMutableURLRequest(URL: myURL!);
        request.HTTPMethod = "POST"
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()
        
        self.navigationController!.popViewControllerAnimated(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
