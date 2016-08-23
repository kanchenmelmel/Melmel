//
//  CommentViewController.swift
//  Melmel
//
//  Created by WuKaipeng on 28/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

extension String {
    func isValidMobile() -> Bool{
        
        
        let regex = try! NSRegularExpression(pattern: "^\\({0,1}((0|\\+61)(2|4|3|7|8)){0,1}\\){0,1}(\\ |-){0,1}[0-9]{2}(\\ |-){0,1}[0-9]{2}(\\ |-){0,1}[0-9]{1}(\\ |-){0,1}[0-9]{3}$", options: .CaseInsensitive)
          //  return regex.firstMatchInString(self, options: nil, range: NSMakeRange(0, count(self))) != nil
            return regex.numberOfMatchesInString(self, options: [], range: NSMakeRange(0, self.characters.count)) > 0
    }
}

class CommentViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var mobileInput: UITextField!
    @IBOutlet weak var contentInput: UITextView!
    
    let placeholder = "写下你的评论……"
    
    var postid:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        nameInput.backgroundColor = UIColor.lightGrayColor()
        nameInput.attributedPlaceholder = NSAttributedString(string: "姓名:", attributes: [NSForegroundColorAttributeName : POST_TINT_COLOR])
        
//        mobileInput.backgroundColor = UIColor.lightGrayColor()
        mobileInput.attributedPlaceholder = NSAttributedString(string: "电话:", attributes: [NSForegroundColorAttributeName : POST_TINT_COLOR])
        
        
//        contentInput.backgroundColor = UIColor.lightGrayColor()
        contentInput.layer.cornerRadius = 5.0
        
        contentInput.text = placeholder
        contentInput.delegate = self
        
        mobileInput.delegate = self
        mobileInput.keyboardType = .NumberPad

        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = false
        
        if let userDefaultsMobile = NSUserDefaults.standardUserDefaults().objectForKey("mobileInput") as? String{
            self.mobileInput.text = userDefaultsMobile
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = NSCharacterSet(charactersInString: "0123456789()+ ").invertedSet
        return string.rangeOfCharacterFromSet(invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
    
    @IBAction func submitComment(sender: AnyObject) {
        
        if !(mobileInput.text?.isValidMobile())!{
            let alert = UIAlertController(title: "电话号码格式不正确", message: "请填写正确的电话号码",preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                print("OK")
                
            }
            
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
        }
        
        guard let nameText = nameInput.text where !nameInput.text!.isEmpty else{
            let alert = UIAlertController(title: "用户名字不能为空白", message: "请填写用户姓名",preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                print("OK")
            
            }
            
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        guard let contentText = contentInput.text where (!contentInput.text!.isEmpty && contentInput.text != placeholder) else{
            let alert = UIAlertController(title: "评论内容不能为空白", message: "请填写评论内容",preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                print("OK")
                
            }
            
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        guard let mobileText = mobileInput.text where !mobileInput.text!.isEmpty else{
            let alert = UIAlertController(title: "电话号码不能为空白", message: "请填写电话号码",preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                print("OK")
                
            }
            
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        
//        if !NSUserDefaults.standardUserDefaults().boolForKey("hasSeenIntroduction") {
//            let rootCtrl = storyboard.instantiateViewControllerWithIdentifier("introductionPageViewCtrl")
//            self.window?.rootViewController = rootCtrl
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasSeenIntroduction")
        
        postComment()
        NSUserDefaults.standardUserDefaults().setObject(self.mobileInput.text, forKey: "mobileInput")
        
    }
    
    func postComment(){
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

extension CommentViewController:UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        if self.contentInput.text == placeholder {
            contentInput.text = nil
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if contentInput.text == "" {
            contentInput.text = placeholder
        }
    }
}
