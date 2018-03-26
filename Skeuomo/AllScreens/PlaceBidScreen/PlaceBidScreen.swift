//
//  PlaceBidScreen.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 07/11/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class PlaceBidScreen: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var lblTotalBid: UILabel!
    @IBOutlet weak var lblHighestBid: UILabel!
    @IBOutlet weak var lblStartPrice: UILabel!
    @IBOutlet weak var txtBidPrice: UITextField!
    @IBOutlet var tool: UIToolbar!
    
    var totalBid : Int?
    var highestBid : Int?
    var startPrice : Int?
    
    var strAuctionId = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lblStartPrice.text = String(format: "$%d", startPrice!)
        lblHighestBid.text = String(format: "$%d", highestBid!)
        lblTotalBid.text = String(describing: totalBid!)
        txtBidPrice.inputAccessoryView = tool
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIButton Events
    
    @IBAction func btnBack(_ sender: AnyObject)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPlaceBid(_ sender: AnyObject)
    {
        self.view.endEditing(true)
        
        if txtBidPrice.text!.characters.count == 0
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter bid price", controller: self)
            return
        }
        else if Int(txtBidPrice.text!)! <= highestBid! && highestBid! != 0
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Bid price must be greater than highest bid price", controller: self)
            return
        }
        else if Int(txtBidPrice.text!)! <= startPrice!
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Bid price must be greater than start bid price", controller: self)
            return
        }
        else
        {
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(PlaceBidApi), with: nil)
        }
    }

    @IBAction func btnDoneKeyboard(_ sender: AnyObject)
    {
        self.view.endEditing(true)
    }
 
    //MARK: - UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string == " "
        {
            return false
        }
        
        return true
    }
    
    //MARK: - Webservice Methods
    
    func PlaceBidApi()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        parameters.setObject(txtBidPrice.text!, forKey: "price" as NSCopying)
        parameters.setObject(strAuctionId, forKey: "auction_id" as NSCopying)
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@bid/place", kSkeuomoMainURL)
        manager.post(url as String, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            DispatchQueue.main.async
                {
                    HelpingMethods.sharedInstance.hideHUD()
                    
                    print((responseObject as! NSDictionary))
                    
                    if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                    {
                        HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UPDATEAUCTIONDETAIL"), object: nil)
                        
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
