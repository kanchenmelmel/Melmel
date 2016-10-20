//
//  BusinessContactFormTableViewController.swift
//  Melmel
//
//  Created by Work on 20/10/16.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import MelMobile

class BusinessContactFormTableViewController: ContactFormTableViewController{

    @IBOutlet weak var discountTypePickerView: UIPickerView!
    
    @IBOutlet weak var businessNameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var contactPersonTextField: UITextField!
    
    @IBOutlet weak var contactTextField: UITextField!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var sendMessageButton: UITableViewSection!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        discountTypePickerView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessageButton.addTarget(self, action: #selector(self.sendMessageButtonPressed), for: .touchUpInside)
    }
    
    func validate() -> Bool {
        return self.nameTextField.text!.match("^.+$") &&
            self.emailTextField.text!.match("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}") &&
            self.mobileTextField.text!.match("^0[0-8]\\d{8}$") &&
            self.wechatTextField.text!.match("^.+$") &&
            self.selfIntroTextField.text!.match("^.+$")
    }
    
    func showDialog(_ status: String) {
        var alert: UIAlertController
        if status == "success" {
            alert = UIAlertController(title: "发送成功", message: "您的申请已收到", preferredStyle: .alert)
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
        let wechat = self.wechatTextField.text!
        let content = self.selfIntroTextField.text!
        
        let email = Email(
            from: "Melmel iOS <hire-evaluator-ios.noreply@melmel.com.au>",
            to: "Melmel Consulting <\(ReceiverEmailAddress)>",
            title: "Melmel测评员申请 (Melmel iOS客户端<招募测评员>)",
            content: "姓名：\(name)\n邮箱：\(_email)\n手机：\(mobile)\n微信：\(wechat)\n\n自我介绍：\n\n\(content)"
        )
        
        EmailEjector.eject(email: email) { _ in
            self.showDialog("success")
        }
    }


    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

extension BusinessContactFormTableViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0: return "10% Off"
        case 1: return "20% Off"
        case 2: return "其他"
        default:break
        }
        return ""
    }
    
}
