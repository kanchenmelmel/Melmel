//
//  ContactUsViewController.swift
//  Melmel
//
//  Created by Wenyu Zhao on 26/9/16.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import MelMobile

class ontactUsViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessageButton.addTarget(self, action: #selector(self.sendMessageButtonPressed), for: .touchUpInside)
    }
    
    func validate() -> Bool {
        return self.nameTextField.text!.match("^.+$") &&
            self.emailTextField.text!.match("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}") &&
            self.mobileTextField.text!.match("^0[0-8]\\d{8}$") &&
            self.contentTextView.text!.match("^.+$")
    }
    
    func showDialog(_ status: String) {
        var alert: UIAlertController
        if status == "success" {
            alert = UIAlertController(title: "发送成功", message: "您的反馈已收到", preferredStyle: .alert)
        } else if status == "invalid" {
            alert = UIAlertController(title: "发送失败", message: "您填写的信息有误", preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "发送失败", message: "网络错误", preferredStyle: .alert)
        }
        alert.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.default) { _ in
            print("done")
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendMessageButtonPressed() {
        
        if !validate() {
            showDialog("invalid")
            return
        }
        
        let name = self.nameTextField.text!
        let _email = self.emailTextField.text!
        let mobile = self.mobileTextField.text!
        let content = self.contentTextView.text!
        
        let email = Email(
            from: "Melmel iOS <contact-us-ios.noreply@melmel.com.au>",
            to: "Melmel Consulting <wenyuzhaox@gmail.com>", // TODO: Replace email address with: pte@ail.vic.edu.au
            title: "Melmel用户留言 (Melmel iOS客户端<联系我们>)",
            content: "姓名：\(name)\n邮箱：\(_email)\n手机：\(mobile)\n\n反馈：\n\n\(content)"
        )
        
        EmailEjector.eject(email: email) { _ in
            self.showDialog("success")
        }
    }

}
