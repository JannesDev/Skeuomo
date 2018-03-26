//
//  ForgotPassWordScreen.swift
//  BusyB
//
//  Created by Satish ios on 05/04/17.
//  Copyright © 2017 NineHertzIndia. All rights reserved.
//

import UIKit
import AFNetworking

class ForgotPassWordScreen: UIViewController,UITextFieldDelegate
{
    @IBOutlet var txtEmail:UITextField!

    @IBOutlet weak var vieTextEmail: UIView!
    @IBOutlet weak var btnSumbit: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        DispatchQueue.main.async
        {
            self.vieTextEmail.layer.masksToBounds = true
            self.vieTextEmail.layer.cornerRadius = 2.0
            self.vieTextEmail.layer.borderWidth = 1.0
            self.vieTextEmail.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
            
            self.btnSumbit.layer.masksToBounds = true
            self.btnSumbit.layer.cornerRadius =  self.btnSumbit.frame.size.height / 2
        }

       btnSumbit.layer.cornerRadius = 4.0
       
       txtEmail.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     //MARK: - TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    //MARK: - UIButton Action
    @IBAction func method_Back(_sender: AnyObject)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UItextField Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField.text == "" && string == " ")
        {
            return false
        }
        
        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        
        if string == " "
        {
            return false
        }

        return newLength > 50 ? false : true;
    }
    
    
    @IBAction func method_submit(_sender: AnyObject)
    {
        txtEmail.text = txtEmail.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if txtEmail.text?.isEmpty == true
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kEmailRequiredText, controller: self)
        }
        else if(!(HelpingMethods.sharedInstance.isValidEmail(txtEmail.text!)))
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kEmailVaildText, controller: self)
        }
        else
        {
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(ForgotPasswordAPI), with: nil)
        }
    }
    
    func ForgotPasswordAPI()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        parameters.setObject(txtEmail.text!, forKey: "email" as NSCopying)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        
        
        
        let  url  = String(format: "%@forgotpassword", kSkeuomoMainURL)
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
