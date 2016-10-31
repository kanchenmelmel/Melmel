//
//  ViewController.swift
//  Melmel
//
//  Created by Work on 21/10/16.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import XLForm

class ContactUsViewController: XLFormViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    func initializeForm() {
        let form = XLFormDescriptor(title: "联系我们")
        
        var section = XLFormSectionDescriptor.formSection()
        
        form.addFormSection(section)
        
        
        var row:XLFormRowDescriptor!
        row = XLFormRowDescriptor(tag: "name", rowType: XLFormRowDescriptorTypeText,title:"姓名")
        row.cellConfigAtConfigure.setObject("姓名", forKey: "textField.placeholder" as NSCopying)
        
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "email", rowType: XLFormRowDescriptorTypeEmail,title:"邮箱")
        row.cellConfigAtConfigure.setObject("邮箱", forKey: "textField.placeholder" as NSCopying)
        
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "mobile", rowType: XLFormRowDescriptorTypePhone,title:"手机")
        row.cellConfigAtConfigure.setObject("手机", forKey: "textField.placeholder" as NSCopying)
        
        section.addFormRow(row)
        
        
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "message", rowType: XLFormRowDescriptorTypeTextView)
        row.cellConfigAtConfigure.setObject("留言", forKey: "textView.placeholder" as NSCopying)
        
        section.addFormRow(row)
       
        self.form = form
    }
    @IBAction func submitButtonClicked(_ sender: AnyObject) {
        sendValues()
    }
    
    
    /// Construct the form values and end it to email address via sendXLFormValuesAsEmail method
    func sendValues() {
        var values = [(String,String)]()
        values.append(("姓名",self.formValues()["name"] as! String))
        values.append(("邮箱",self.formValues()["email"] as! String))
        values.append(("电话",self.formValues()["mobile"] as! String))
        values.append(("留言",self.formValues()["message"] as! String))
        
        self.sendXLFormValuesAsEmail(title: "联系我们", values: values)
    }

}
