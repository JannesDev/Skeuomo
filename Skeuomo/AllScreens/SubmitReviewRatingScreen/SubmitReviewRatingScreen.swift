//
//  SubmitReviewRatingScreen.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 06/02/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class SubmitReviewRatingScreen: UIViewController, UITextViewDelegate, UITextFieldDelegate
{
    @IBOutlet weak var txtSubject: MDTextField!
    @IBOutlet weak var viewReviewBG: UIView!
    @IBOutlet weak var txtReview: UITextView!
    @IBOutlet weak var ratingView: DXStarRatingView!
    @IBOutlet weak var viewSubjectBG: UIView!
    @IBOutlet weak var viewContent: UIView!
    
    
    @IBOutlet weak var tool: UIToolbar!

    
    var strModule = ""
    var strID = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewContent.layer.masksToBounds = true
        viewContent.layer.cornerRadius = 5.0
        
        viewSubjectBG.layer.masksToBounds = true
        viewSubjectBG.layer.cornerRadius = 2.0
        viewSubjectBG.layer.borderWidth = 1.0
        viewSubjectBG.layer.borderColor = UIColor.lightGray.cgColor
        
        viewReviewBG.layer.masksToBounds = true
        viewReviewBG.layer.cornerRadius = 2.0
        viewReviewBG.layer.borderWidth = 1.0
        viewReviewBG.layer.borderColor = UIColor.lightGray.cgColor
        
        
        ratingView.isUserInteractionEnabled =  true
        ratingView.setStars(1, callbackBlock: nil)
        
        txtReview.inputAccessoryView = tool
        txtSubject.inputAccessoryView = tool
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - UIButton Methods
    
    @IBAction func hideKeyboard(_ sender: Any)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func btnCommentNowClick(_ sender: Any)
    {
        if txtSubject.text!.characters.count == 0 {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter subject", controller: self)
            return
        }
        else if txtReview.text!.characters.count == 0 {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter review", controller: self)
            return
        }
        else if txtReview.text!.characters.count < 50
        {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter minimum 50 characters in review", controller: self)
            return
        }
        
        
        self.view.endEditing(true)
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(submitReview), with: nil)

        
    }
    
    @IBAction func btnClose(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextField Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.text?.characters.count == 0 && string == " "
        {
            return false
        }
        
        return true
    }
    
    
    // MARK: - UITextView Methods

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text.characters.count == 0 && text == " "
        {
            return false
        }
        
        return true
    }
    
    // MARK: - Webservices Methods
    
    func submitReview()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        parameters.setObject(strModule, forKey: "module_name" as NSCopying)
        
        parameters.setObject(strID, forKey: "id" as NSCopying)
        
        parameters.setObject(txtSubject.text!, forKey: "subject" as NSCopying)

        parameters.setObject(String.init(format: "%d", ratingView.stars), forKey: "rating" as NSCopying)

        parameters.setObject(txtReview.text!, forKey: "review" as NSCopying)

        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@comment/create", kSkeuomoMainURL)
        manager.post(url as String, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            DispatchQueue.main.async
                {
                    HelpingMethods.sharedInstance.hideHUD()
                    
                    print((responseObject as! NSDictionary))
                    
                    if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                    {
                        
                        HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                        
                        self.dismiss(animated: true, completion: nil)

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
            }
            
        }
        
    }

    

}
