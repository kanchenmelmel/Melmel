//
//  HireEvaluatorViewController.swift
//  Melmel
//
//  Created by Wenyu Zhao on 3/10/16.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class HireEvaluatorViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var wechatTextField: UITextField!
    @IBOutlet weak var selfIntroTextField: UITextView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessageButton.addTarget(self, action: #selector(self.sendMessageButtonPressed), for: .touchUpInside)
    }
    
    func sendMessageButtonPressed() {
        let name = self.nameTextField.text!
        let _email = self.emailTextField.text!
        let mobile = self.mobileTextField.text!
        let wechat = self.wechatTextField.text!
        let content = self.selfIntroTextField.text!
        
        let email = Email(
            from: "Melmel iOS <hire-evaluator-ios.noreply@melmel.com.au>",
            to: "Melmel Consulting <wenyuzhaox@gmail.com>",
            title: "Melmel测评员申请 (Melmel iOS客户端<招募测评员>)",
            content: "姓名：\(name)\n邮箱：\(_email)\n手机：\(mobile)\n微信：\(wechat)\n\n\n自我介绍：\n\(content)"
        )
        
        EmailEjector.eject(email: email) { _ in
            let alert = UIAlertController(
                title: "发送成功",
                message: "您的申请已收到",
                preferredStyle: UIAlertControllerStyle.alert
            )
            alert.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.default) { _ in print("done") })
            self.present(alert, animated: true, completion: nil)
        }
    }

}
