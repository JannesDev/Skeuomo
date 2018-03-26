//
//  RegisterViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 12/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class RegisterViewController: UIViewController, UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var myScrollBar: UIScrollView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var imgRegisterBG: UIImageView!
    
    var selectedIndex : Int = 0
    
    @IBOutlet var viePickerShow: UIView!
    @IBOutlet weak var pickerDataSet: UIPickerView!
    
    var strCountry : NSString!
    var Pickervalue : Int!
    @IBOutlet weak var btnState: UIButton!
    var arrCountryList = NSArray()
    var arrStateName = NSMutableArray()
    var arrCityName = NSMutableArray()
    
    //ashish 
    var dictUserLoadedData = NSMutableDictionary()
    var imgdata = NSData()
    
    //var appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        if UserDefaults.standard.object(forKey: "CountryList") != nil {
            arrCountryList = UserDefaults.standard.object(forKey: "CountryList") as! NSArray
        }
        
     //    arrCountryName = ["India", "USA", "Japan", "China", "Pak"]

       // pickerTextField.inputView = pickerView
        DispatchQueue.main.async
            {
              self.myScrollBar.contentInset=UIEdgeInsetsMake(0, 0, 0,0)
              self.myScrollBar.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height:780)
             self.imgRegisterBG.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width , height:780)
        }
        
        btnRegister.layer.cornerRadius = 21.0
        btnLogin.layer.cornerRadius = 21.0
        btnLogin.layer.borderColor = UIColor.init(red: 16/255.0, green: 133/255.0, blue: 251/255.0, alpha: 1.0).cgColor
        btnLogin.layer.borderWidth = 1.5
        btnLogin.layer.masksToBounds = true
        
        txtCity.tag = 100
        txtState.tag = 101
        
        //ashish 
        txtEmail.isEnabled = true
        
        if(dictUserLoadedData.allKeys.count > 0)
        {
            HelpingMethods.sharedInstance.ShowHUD()
            
            if(self.dictUserLoadedData.object(forKey: "social_first_name") != nil)
            {
                txtFirstName.text = self.dictUserLoadedData.object(forKey: "social_first_name") as? String
            }
            
            if(self.dictUserLoadedData.object(forKey: "social_last_name") != nil)
            {
                txtLastName.text = self.dictUserLoadedData.object(forKey: "social_last_name") as? String
            }
            
            if(self.dictUserLoadedData.object(forKey: "social_email") != nil)
            {
                txtEmail.text = self.dictUserLoadedData.object(forKey: "social_email") as? String
                txtEmail.isEnabled = false
            }
            
            if(self.dictUserLoadedData.object(forKey: "social_user_name") != nil)
            {
                txtUserName.text = self.dictUserLoadedData.object(forKey: "social_user_name") as? String
                
            }
            
            HelpingMethods.sharedInstance.hideHUD()
            
        }
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    //MARK:- UItextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if (textField.text == "" && string == " ")
        {
            return false
        }
        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        
        if string == " " {
            return false
        }
        
        if ( textField == txtUserName)
        {
            return newLength > 20 ? false : true;
        }
        else  if ( textField == txtPassword || textField == txtConfirmPass)
        {
            return newLength > 20 ? false : true;
            
        }
        else  if ( textField == txtEmail)
        {
            return newLength > 50 ? false : true;
        }
        else  if (textField == txtFirstName || textField == txtLastName || textField == txtCity || textField == txtState)
        {
            return newLength > 16 ? false : true;
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
          self.view.endEditing(true)
       // pickerDataSet.reloadAllComponents()
       if textField == txtCountry
        {
            Pickervalue = 102
            self.viePickerShow.frame = self.view.frame
            self.view.addSubview(viePickerShow)
            pickerDataSet.reloadAllComponents()
             return false
        }
         return true
    }
    
    // MARK: - ButtonsMethods
    
  
    @IBAction func btnDoneAndCancel(_ sender: UIButton)
    {
        self.view.endEditing(true)

        if Pickervalue == 102 && txtCountry.text == ""
        {
            txtCountry.text = (arrCountryList.object(at: 0) as! NSDictionary).object(forKey: "name") as? String
        }
        
        viePickerShow.removeFromSuperview()
    }

    @IBAction func btnRegister(_ sender: Any)
    {
        if txtFirstName.text?.isEmpty == true {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kFirstnameRequiredText, controller: self)
        }
       else if txtLastName.text?.isEmpty == true
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kLastnameRequiredText, controller: self)

        }
        else if txtEmail.text?.isEmpty == true
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kEmailRequiredText, controller: self)
        }
        else if(!(HelpingMethods.sharedInstance.isValidEmail(txtEmail.text!)))
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kEmailVaildText, controller: self)
        }
        else if txtCity.text?.isEmpty == true
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kCityRequiredText, controller: self)
        }
        else if txtState.text?.isEmpty == true
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kStateRequiredText, controller: self)
        }
        else if txtCountry.text?.isEmpty == true
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kCountryRequiredText, controller: self)
        }
        else if txtUserName.text?.isEmpty == true
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kUsernameRequiredText, controller: self)
        }
        else if txtPassword.text?.isEmpty == true
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kPasswordRequiredText, controller: self)
        }
        else if (txtPassword.text?.characters.count)! < 6
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kPasswordLengthText, controller: self)
        }
        else if txtConfirmPass.text?.isEmpty == true
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kConfirmPasswordRequiredText, controller: self)
        }
        else if txtPassword.text != txtConfirmPass.text
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kPasswordMatchRequiredText, controller: self)
        }
        else
        {
            if HelpingMethods.sharedInstance.isInternetAvailable() == false
            {
                self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"No Internet Connection" , strSubtitle: "Make sure your device is connected to the internet.", controller: self)
            }
            else
            {
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(RegisterViewController.RegiterApi), with: nil)
            }
        }
    
    }
    @IBAction func btnLogin(_ sender: Any)
    {
      _ =  self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - PikcerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        
        return arrCountryList.count
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return (arrCountryList.object(at: row) as! NSDictionary).object(forKey: "name") as? String
     
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        txtCountry.text =      (arrCountryList.object(at: row) as! NSDictionary).object(forKey: "name") as? String
        selectedIndex = row
       
    }

   //MARK:- Register Api
    
    func RegiterApi()  {
        
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        let utcTimestamp = Date().timeIntervalSince1970

        let parameters = NSMutableDictionary()
        
        parameters.setObject(txtFirstName.text!, forKey: "first_name" as NSCopying)
        parameters.setObject(txtLastName.text!, forKey: "last_name" as NSCopying)
        parameters.setObject(txtEmail.text!, forKey: "email" as NSCopying)
        parameters.setObject(txtCity.text!, forKey: "city" as NSCopying)
        parameters.setObject(txtState.text!, forKey: "state" as NSCopying)
        parameters.setObject(NSString.init(format: "%d", ((arrCountryList.object(at: selectedIndex) as! NSDictionary).object(forKey: "id") as? Int)!), forKey: "country" as NSCopying)
        parameters.setObject("IOS" ,  forKey: "device_type" as NSCopying)
        parameters.setObject("Simulator" , forKey: "device_token" as NSCopying)
        parameters.setObject(txtUserName.text! , forKey: "username" as NSCopying)
        parameters.setObject(txtPassword.text! , forKey: "password" as NSCopying)
        
        if(dictUserLoadedData.allKeys.count > 0)
        {
            parameters.setObject(dictUserLoadedData.object(forKey: "social_id") as! String ,  forKey: "social_id" as NSCopying)
            parameters.setObject(dictUserLoadedData.object(forKey: "social_type") as! String ,  forKey: "social_type" as NSCopying)
            
            //image
            
            if(self.dictUserLoadedData.object(forKey: "social_type") as! String == "facebook")
            {
                let strFBUserPic = NSString(format:"http://graph.facebook.com/%@/picture?type=large",dictUserLoadedData.object(forKey: "social_id") as! String)
                
                let forecastURL = NSURL(string: strFBUserPic as String)
                
                do
                {
                    self.imgdata = try NSData (contentsOf: forecastURL! as URL)
                }
                catch
                {
                    print(error.localizedDescription)
                }
            }
        }
        else
        {
            parameters.setObject("" ,  forKey: "social_id" as NSCopying)
            parameters.setObject("manually" , forKey: "social_type" as NSCopying)
        }

        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }

        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@register", kSkeuomoMainURL)
        manager.post(url as String, parameters: parameters, constructingBodyWith:{ (fromData)in/*fromData : AFMultipartFormData) in*/
            /*if(self.imgdata.length > 0)
            {
                fromData.appendPart(withFileData: self.imgdata as Data, name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }*/
        },progress:nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            DispatchQueue.main.async
                {
                    HelpingMethods.sharedInstance.hideHUD()
                    print((responseObject as! NSDictionary))
                    
                    if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                    {
//                        UserDefaults.standard.set( ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "user") as! NSDictionary, forKey: "UserDatail")
//                        
//                        if ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "session_id") != nil
//                        {
//                            
//                             UserDefaults.standard.set(((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "session_id") as! String, forKey: "session_id")
//                        }
//                        
//                        
//                        UserDefaults.standard.set("Yes", forKey: "isLogin")
//                        
//                        //let Plans  = AllPlansVC(nibName:"AllPlansVC", bundle:nil)
//                        //self.navigationController?.pushViewController(Plans, animated: true)
//                        
//                        
//                        let Plans  = MemberShipPlansScreen(nibName:"MemberShipPlansScreen", bundle:nil)
//                        self.navigationController?.pushViewController(Plans, animated: true)

                         HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                        
                      _ =  self.navigationController?.popViewController(animated: true)
                        
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
