//
//  BuyTicketScreen.swift
//  Skeuomo
//
//  Created by Satish ios on 11/27/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking
class BuyTicketScreen: UIViewController,UITextFieldDelegate
{
    @IBOutlet var lblMaxTickets     : UILabel!
    @IBOutlet var lblBookedTickets  : UILabel!
    @IBOutlet var lblMaxIndication  : UILabel!
    @IBOutlet var txtNumOFTickets   : MDTextField!
    @IBOutlet var backGroundViews   : [UIView]!
    
    var dicEventDetails = NSDictionary()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        for view in backGroundViews
        {
            view.layer.borderColor = UIColor.lightGray.cgColor
            view.layer.borderWidth = 1
            view.layer.opacity = 0.8
        }
        
        if dicEventDetails.allKeys.count > 0
        {
            
            lblMaxTickets.text = "\(dicEventDetails.object(forKey: "max_tickets")!)"
            lblBookedTickets.text = dicEventDetails.object(forKey: "bookedEvent")! as? String
            
            if dicEventDetails.object(forKey: "event_type") as! String != "free"
            {
                lblMaxIndication.isHidden = true
            }
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIButton Events
    
    @IBAction func btnCloseAction(_sender : UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnBookAction(_sender : UIButton)
    {
        if txtNumOFTickets.text == ""
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter no. of Seats", controller: self)
        }
        else
        {
            let ticketsAvailable = self.checkAvailability()
            
            if ticketsAvailable == true
            {
                HelpingMethods.sharedInstance.ShowHUD()
                self.performSelector(inBackground: #selector(BuyTickets), with: nil)
                
            }
        }
        
        
        
        
    }
    
    // MARK: - UITextField Delegate Method
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let strTotalSeats : NSString = "\(dicEventDetails.object(forKey: "max_tickets")!)" as NSString
        let strBookSeats : NSString = "\(dicEventDetails.object(forKey: "bookedEvent")!)" as NSString
        
        let strAvailableSeats = (strTotalSeats.integerValue - strBookSeats.integerValue)
        
        let selectedSeats = textField.text! as NSString
        
        if dicEventDetails.object(forKey: "event_type") as! String == "free"
        {
            if selectedSeats.integerValue > 4
            {
                HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "You can reserve 4 tickets per user.", controller: self)
                
                txtNumOFTickets.text = ""
            }
        }
        else
        {
            if selectedSeats.integerValue > strAvailableSeats
            {
                HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter upto available Seats", controller: self)
                txtNumOFTickets.text = ""
            }
        }
    }
    
    //MARK: Check Availability
    
    func checkAvailability() -> Bool
    {
        let strTotalSeats : NSString = "\(dicEventDetails.object(forKey: "max_tickets")!)" as NSString
        let strBookSeats : NSString = "\(dicEventDetails.object(forKey: "bookedEvent")!)" as NSString
        
        let strAvailableSeats = (strTotalSeats.integerValue - strBookSeats.integerValue)
        
        let selectedSeats = txtNumOFTickets.text! as NSString
        
        if dicEventDetails.object(forKey: "event_type") as! String == "free"
        {
            if selectedSeats.integerValue > 4
            {
                HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "You can reserve 4 tickets per user.", controller: self)
                
                txtNumOFTickets.text = ""
                
                return false
            }
        }
        else
        {
            if dicEventDetails.valueForNullableKey(key: "max_tickets") == dicEventDetails.valueForNullableKey(key: "bookedEvent") {
                
                
                HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Only 0 ticket remaining", controller: self)
                
                txtNumOFTickets.text = ""
                
                return false

                
            }
            
           else if selectedSeats.integerValue > strAvailableSeats
            {
                HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter upto available Seats", controller: self)
                txtNumOFTickets.text = ""
                
                return false
            }
        }
        
        return true
    }
    
    //MARK: - Web Service Method
    
    func BuyTickets()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        let strEventID = "\(dicEventDetails.object(forKey: "id")!)"
        let strEventType = "\(dicEventDetails.object(forKey: "event_type")!)"
        
        parameters.setValue(strUserid, forKey: "userid")
        parameters.setValue(strEventID, forKey: "event_id")
        parameters.setValue(strEventType, forKey: "event_type")
        parameters.setValue(txtNumOFTickets.text!, forKey: "eventTicket")
        
        print(parameters)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
//        let sortedArray = (arrupperCase as! NSArray).sorted
//            { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending
//        }

        let sortedArray = (arrupperCase as! NSArray).sorted
            { ($0 as! String).compare($1 as! String) == ComparisonResult.orderedAscending
        }
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        
        let token = appDelegate.MD5(strforMD5 as String)
        
        
        
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        //event/placeevent?userid=74&event_id=10&event_type=free&eventTicket=1
        let  url  = String(format: "%@event/placeevent?userid=%@&event_id=%@&event_type=%@&eventTicket=%@", kSkeuomoMainURL,strUserid,strEventID,strEventType,txtNumOFTickets.text!)
        
        print(url)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            
                            self.showConfirmAlert()
                        }
                        else
                        {
                            print("failed")
                            self.showFailedAlert()
                           
                        }
                }
                
        },
                    failure:{(operation, error) in
                        print("Error: " + (error.localizedDescription))
                        DispatchQueue.main.async
                            {
                                HelpingMethods.sharedInstance.hideHUD()
                        }
        })
        
    }
    

    func showConfirmAlert()
    {
        let alert = UIAlertController.init(title: "you have successfully booked tickets", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction.init(title: "OK", style: .default) { (action) in
            
            
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateEventDetail"), object: nil)
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showFailedAlert()
    {
        let alert = UIAlertController.init(title: "You can reserve 4 tickets per user.", message: "", preferredStyle: .alert)
        let okButton = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
    }

}
