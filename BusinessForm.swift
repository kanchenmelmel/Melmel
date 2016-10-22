//
//  BusinessForm.swift
//  Melmel
//
//  Created by Work on 22/10/16.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import XLForm

class BusinessFormViewController:XLFormViewController {
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    func initializeForm() {
        let form = XLFormDescriptor(title: "我是商家")
        
        
        var section = XLFormSectionDescriptor.formSection()
        
        form.addFormSection(section)
        
        
        var row:XLFormRowDescriptor!
        row = XLFormRowDescriptor(tag: "businessName", rowType: XLFormRowDescriptorTypeText,title:"商家姓名")
        row.cellConfigAtConfigure.setObject("商家姓名", forKey: "textField.placeholder" as NSCopying)
        
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "address", rowType: XLFormRowDescriptorTypeEmail,title:"地址")
        row.cellConfigAtConfigure.setObject("地址", forKey: "textField.placeholder" as NSCopying)
        
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "contact", rowType: XLFormRowDescriptorTypeEmail,title:"联系人")
        row.cellConfigAtConfigure.setObject("联系人", forKey: "textField.placeholder" as NSCopying)
        
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "mobile", rowType: XLFormRowDescriptorTypePhone,title:"联系方式")
        row.cellConfigAtConfigure.setObject("联系方式", forKey: "textField.placeholder" as NSCopying)
        
        section.addFormRow(row)
        
        
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "discountType", rowType: XLFormRowDescriptorTypeSelectorAlertView,title:"优惠类型")
        //row.cellConfigAtConfigure.setObject("微信", forKey: "textField.placeholder" as NSCopying)
        row.selectorOptions = ["10% OFF","20% OFF","其他"]
        row.value = "10% OFF"
        
        section.addFormRow(row)
        
        
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        row = XLFormRowDescriptor(tag: "message", rowType: XLFormRowDescriptorTypeTextView)
        row.cellConfigAtConfigure.setObject("留言", forKey: "textView.placeholder" as NSCopying)
        
        section.addFormRow(row)
        
        self.form = form
    }
    
    @IBAction func submitButtonClick(_ sender: AnyObject) {
        sendValues()
    }
    
    
    /// Construct the form values and end it to email address via sendXLFormValuesAsEmail method
    func sendValues() {
        var values = [(String,String)]()
        values.append(("商家名称",self.formValues()["businessName"] as! String))
        values.append(("地址",self.formValues()["address"] as! String))
        values.append(("联系人",self.formValues()["contact"] as! String))
        values.append(("联系方式",self.formValues()["mobile"] as! String))
        values.append(("优惠类型",self.formValues()["discountType"] as! String))
        values.append(("留言",self.formValues()["message"] as! String))
        
        self.sendXLFormValuesAsEmail(title: "我是商家", values: values)
    }
    
}
