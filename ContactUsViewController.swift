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
        row = XLFormRowDescriptor(tag: "姓名", rowType: XLFormRowDescriptorTypeText,title:"姓名")
        row.cellConfigAtConfigure.setObject("姓名", forKey: "textField.placeholder" as NSCopying)
        
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "邮箱", rowType: XLFormRowDescriptorTypeEmail,title:"邮箱")
        row.cellConfigAtConfigure.setObject("邮箱", forKey: "textField.placeholder" as NSCopying)
        
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "手机", rowType: XLFormRowDescriptorTypePhone,title:"手机")
        row.cellConfigAtConfigure.setObject("手机", forKey: "textField.placeholder" as NSCopying)
        
        section.addFormRow(row)
        
        
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "留言", rowType: XLFormRowDescriptorTypeTextView)
        row.cellConfigAtConfigure.setObject("留言", forKey: "textView.placeholder" as NSCopying)
        
        section.addFormRow(row)
       
        self.form = form
    }

}
