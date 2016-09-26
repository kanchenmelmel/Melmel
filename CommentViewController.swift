//
//  CommentViewController.swift
//  Melmel
//
//  Created by WuKaipeng on 28/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

extension String {
    //regex for Australia mobile
    func isValidMobile() -> Bool{
        
        
        let regex = try! NSRegularExpression(pattern: "^\\({0,1}((0|\\+61)(2|4|3|7|8)){0,1}\\){0,1}(\\ |-){0,1}[0-9]{2}(\\ |-){0,1}[0-9]{2}(\\ |-){0,1}[0-9]{1}(\\ |-){0,1}[0-9]{3}$", options: .caseInsensitive)
          //  return regex.firstMatchInString(self, options: nil, range: NSMakeRange(0, count(self))) != nil
            return regex.numberOfMatches(in: self, options: [], range: NSMakeRange(0, self.characters.count)) > 0
    }
    
    //regex for email
    func isValidEmail() -> Bool{
        
        
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        //  return regex.firstMatchInString(self, options: nil, range: NSMakeRange(0, count(self))) != nil
        return regex.numberOfMatches(in: self, options: [], range: NSMakeRange(0, self.characters.count)) > 0
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
        mobileInput.attributedPlaceholder = NSAttributedString(string: "邮箱:", attributes: [NSForegroundColorAttributeName : POST_TINT_COLOR])
        
        
//        contentInput.backgroundColor = UIColor.lightGrayColor()
        contentInput.layer.cornerRadius = 5.0
        
        contentInput.text = placeholder
        contentInput.delegate = self
        
        mobileInput.delegate = self
        //mobileInput.keyboardType = .NumberPad

        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = false
        
        if let userDefaultsMobile = UserDefaults.standard.object(forKey: "mobileInput") as? String{
            self.mobileInput.text = userDefaultsMobile
        }
        
        if let userDefaultsName = UserDefaults.standard.object(forKey: "nameInput") as? String{
            self.nameInput.text = userDefaultsName
        }
    }
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        let invalidCharacters = NSCharacterSet(charactersInString: "0123456789()+ ").invertedSet
//        return string.rangeOfCharacterFromSet(invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
//    }
    
    @IBAction func submitComment(_ sender: AnyObject) {
        
        if !(mobileInput.text?.isValidEmail())!{
            let alert = UIAlertController(title: "邮箱地址格式不正确", message: "请填写正确的邮箱地址",preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK")
                
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        guard let _ = nameInput.text , !nameInput.text!.isEmpty else{
            let alert = UIAlertController(title: "用户名字不能为空白", message: "请填写用户姓名",preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK")
            
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let _ = contentInput.text , (!contentInput.text!.isEmpty && contentInput.text != placeholder) else{
            let alert = UIAlertController(title: "评论内容不能为空白", message: "请填写评论内容",preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK")
                
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let _ = mobileInput.text , !mobileInput.text!.isEmpty else{
            let alert = UIAlertController(title: "电话号码不能为空白", message: "请填写电话号码",preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("OK")
                
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
//        if !NSUserDefaults.standardUserDefaults().boolForKey("hasSeenIntroduction") {
//            let rootCtrl = storyboard.instantiateViewControllerWithIdentifier("introductionPageViewCtrl")
//            self.window?.rootViewController = rootCtrl
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasSeenIntroduction")
        
        postComment()
        UserDefaults.standard.set(self.mobileInput.text, forKey: "mobileInput")
        UserDefaults.standard.set(self.nameInput.text, forKey: "nameInput")
        
    }
    //using POST method to post a comment
    func postComment(){
        let endpointURL = "http://melmel.com.au/wp-json/wp/v2/comments?"
        let post = "post=\(self.postid!)&"
        let name = "author_name=\(nameInput.text!)&"
        let mobile = "author_email=\(mobileInput.text!)&"
        let content = "content=\(contentInput.text!)"
        
        let urlWithParams = endpointURL+post+name+mobile+content
        
        
        let myURL = URL(string: urlWithParams.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        
        
        var request = URLRequest(url: myURL!);
        request.httpMethod = "POST"
        
<<<<<<< Updated upstream
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
=======
        
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
>>>>>>> Stashed changes
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
        }
        task.resume()
        
        self.navigationController!.popViewController(animated: true)
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.contentInput.text == placeholder {
            contentInput.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentInput.text == "" {
            contentInput.text = placeholder
        }
    }
}
