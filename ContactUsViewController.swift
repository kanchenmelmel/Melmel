//
//  ContactUsViewController.swift
//  Melmel
//
//  Created by Wenyu Zhao on 26/9/16.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessageButton.addTarget(self, action: #selector(self.sendMessageButtonPressed), for: .touchUpInside)
    }
    
    func sendMessageButtonPressed() {
        let name = self.nameTextField.text!
        let _email = self.emailTextField.text!
        let mobile = self.mobileTextField.text!
        let content = self.contentTextView.text!
        
        let email = Email(
            from: "Melmel iOS <contact-us-ios.noreply@melmel.com.au>",
            to: "Melmel Consulting <wenyuzhaox@gmail.com>", // TODO: Replace email address with: pte@ail.vic.edu.au
            title: "Melmel用户留言 (Melmel iOS客户端<联系我们>)",
            content: "姓名：\(name)\n邮箱：\(_email)\n手机：\(mobile)\n\n\n\(content)"
        )
        
        (EmailEjector.eject(email: email)) { _ in
            let alert = UIAlertController(
                title: "发送成功",
                message: "您的反馈已收到",
                preferredStyle: UIAlertControllerStyle.alert
            )
            alert.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.default) { _ in
                print("done")
            })
            self.present(alert, animated: true, completion: nil)
        }
    }

}
