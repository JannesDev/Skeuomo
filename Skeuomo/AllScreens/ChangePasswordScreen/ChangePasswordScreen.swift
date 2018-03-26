//
//  ChangePasswordScreen.swift
//  BusyB
//
//  Created by Satish ios on 06/04/17.
//  Copyright © 2017 NineHertzIndia. All rights reserved.
//

import UIKit
import AFNetworking

class ChangePasswordScreen: UIViewController,UITextFieldDelegate {
    @IBOutlet var txtOldPass:UITextField!
    @IBOutlet var txtNewPass:UITextField!
    @IBOutlet var txtConfirmPass:UITextField!
    @IBOutlet var vieOldPass: UIView!
   
    @IBOutlet var vieNewPass: UIView!
    @IBOutlet var vieConfirmPass: UIView!
    @IBOutlet var btnSubmit: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        vieNewPass.layer.cornerRadius = 2.0
        vieNewPass.layer.borderWidth = 1.0
        vieNewPass.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
        
        vieConfirmPass.layer.cornerRadius = 2.0
        vieConfirmPass.layer.borderWidth = 1.0
        vieConfirmPass.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
        
        vieOldPass.layer.cornerRadius = 2.0
        vieOldPass.layer.borderWidth = 1.0
        vieOldPass.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
        
        btnSubmit.layer.cornerRadius = 4.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIButton Actions
    @IBAction func method_Back(_sender: AnyObject)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UITextfield Delegate Methods
    
    //MARK:- UItextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        
        if ( textField == txtOldPass || textField == txtNewPass || textField == txtConfirmPass)
        {
            return newLength > 20 ? false : true;
            
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtOldPass
        {
            txtNewPass.becomeFirstResponder()
        }
        else if textField == txtNewPass
        {
            txtConfirmPass.becomeFirstResponder()
        }
        else if textField == txtConfirmPass
        {
            txtConfirmPass.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func method_submit(_ sender: AnyObject)
    {
        txtOldPass.text = txtOldPass.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        txtNewPass.text = txtNewPass.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        txtConfirmPass.text = txtConfirmPass.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        
        if(txtOldPass.text?.isEmpty == true)
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kOldPasswordRequiredText, controller: self)
        }
        else if(txtNewPass.text?.isEmpty == true)
        {
             self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kNewPasswordRequiredText, controller: self)
        }
        else if(txtConfirmPass.text?.isEmpty == true)
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kConfirmPasswordRequiredText, controller: self)
        }
        else if(txtNewPass.text != txtConfirmPass.text)
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kPasswordMatchRequiredText, controller: self)
        }
        else
        {
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(ChangePasswordAPI), with: nil)
            
        }
        
    }
 
    
    func ChangePasswordAPI()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        parameters.setObject(txtOldPass.text!, forKey: "old_password" as NSCopying)
        parameters.setObject(txtNewPass.text!, forKey: "password" as NSCopying)
        parameters.setObject(txtConfirmPass.text!, forKey: "confirm_password" as NSCopying)
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        
        
        let  url  = String(format: "%@changePasswordUser", kSkeuomoMainURL)
        manager.post(url as String, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            DispatchQueue.main.async
                {
                    HelpingMethods.sharedInstance.hideHUD()
                    print((responseObject as! NSDictionary))
                    
                    if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                    {
                        HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                        
                        _ = self.navigationController?.popViewController(animated: true)
                        
                        // let Plans  = AllPlansVC(nibName:"AllPlansVC", bundle:nil)
                        //self.navigationController?.pushViewController(Plans, animated: true)
                        
                    }
                        
                    else
                    {
                        print("failed")
                        
                        HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                        
                        
                        
                    }
            }
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            print("POST fails with error \(error.localizedDescription)")
            DispatchQueue.main.async
                {
                    
                    HelpingMethods.sharedInstance.hideHUD()
                    
                    HelpingMethods.sharedInstance.Showerrormessage(error: error, controller: self)
                    
                    
                    
                    
                    
                    //  MBProgressHUD.hide(for: self.appDelegate.window!, animated: true)
                    
            }
            
        }
        
    }

}
