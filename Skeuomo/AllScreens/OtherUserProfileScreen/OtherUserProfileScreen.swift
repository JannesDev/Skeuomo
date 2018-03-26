//
//  OtherUserProfileScreen.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 08/02/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class OtherUserProfileScreen: UIViewController, UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet var viewHeaderAbout: UIView!
    @IBOutlet var viewHeaderArtworkForSale: UIView!
    @IBOutlet var viewHeaderArtworkAuctioned: UIView!
    
    @IBOutlet   var     tblProflieDetails   : UITableView!

    var strID = ""
    
    var dictUser = NSDictionary()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - UIButton Events
    
    @IBAction func btnBack(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    //MARK: - UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 2
        }
        if section == 1
        {
            return 2
        }
        else
        {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 0
        }
        else
        {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 1
        {
            return viewHeaderAbout
        }
        if section == 2
        {
            return viewHeaderArtworkForSale
        }
        else if section == 3
        {
            return viewHeaderArtworkAuctioned
        }
        else
        {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                return 266
            }
            else
            {
                return 50
            }
        }
        else if indexPath.section == 1
        {
                return 70
        }
        else if indexPath.section == 2
        {
                return 44
        }
        else
        {
            if indexPath.row == 0 || indexPath.row == 1
            {
                return 70
            }
            else
            {
                return 100
            }
        }
        
        
    }
    
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        let cellIdentifier:String = "MyProfileIMGTblCell"
//        var cell:MyProfileIMGTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MyProfileIMGTblCell
//
//        if (cell == nil)
//        {
//            let nib:Array = Bundle.main.loadNibNamed("MyProfileIMGTblCell", owner: nil, options: nil)! as [Any]
//
//            cell = nib[0] as? MyProfileIMGTblCell
//            cell!.selectionStyle = UITableViewCellSelectionStyle.none
//            cell?.backgroundColor = (UIColor.clear);
//        }
//
//        return cell!
//
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            
            if indexPath.row == 0
            {
                let cellIdentifier:String = "MyProfileIMGTblCell"
                var cell:MyProfileIMGTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MyProfileIMGTblCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("MyProfileIMGTblCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? MyProfileIMGTblCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                
                //image code
                
                let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(self.dictUser.object(forKey: "profile_picture") as? String)!)
                
                let urlImage : NSURL = NSURL(string: urlStr as String)!
                
                
                cell?.imgProfile.sd_setImage(with: urlImage as URL!, placeholderImage: UIImage.init(named:"user_place"), options: .refreshCached, completed: nil)
                
                
                cell?.imgProfile.layer.cornerRadius = (cell?.imgProfile.frame.size.width)! / 2
                cell?.imgProfile.layer.masksToBounds =  true
                
                cell?.imgProfile.layer.borderWidth = 1.0
                cell?.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
                
                
                //background image
                let urlStr1 = NSString(format: "%@%@",kSkeuomoImageURL,(self.dictUser.object(forKey: "backgroung_picture") as? String)!)
                
                let urlImage1 : NSURL = NSURL(string: urlStr1 as String)!
                
               
                cell?.imgBgProfile.sd_setImage(with: urlImage1 as URL!, placeholderImage: UIImage.init(named:"bgS.png"), options: .refreshCached, completed: nil)
                
                
                cell?.lblUserName.text = NSString(format: "%@ %@",self.dictUser.valueForNullableKey(key: "firstName"),self.dictUser.valueForNullableKey(key: "lastName")) as String
                
                let strLocation =  NSString(format: " %@, %@, %@",(self.dictUser.object(forKey: "city") as? String)!,(self.dictUser.object(forKey: "state") as? String)!,(dictUser.object(forKey: "country")  as! NSDictionary).object(forKey: "name") as! String ) as String
                
                cell?.btnAddress.setTitle(strLocation, for: UIControlState.normal)
                cell?.lblAddress.isHidden = true
                
                cell?.lblFollowers.text = "25"
                cell?.lblFollowing.text = "25"
                
                
                cell?.btnBgCamera.isHidden = true
                
                
                cell?.btnCamera.isHidden = true
                
                return cell!
                
            }
            else
            {
                
                let cellIdentifier:String = "OtherUserFollowDetailCell"
                var cell:OtherUserFollowDetailCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? OtherUserFollowDetailCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("OtherUserFollowDetailCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? OtherUserFollowDetailCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                
                return cell!

            }
            
        }
        
        return UITableViewCell()
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
  

    //MARK: - getUserProfileAPI
    
    func getOhterProfileAPI()
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
        
        parameters.setObject(strID, forKey: "id" as NSCopying)

        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
       // http://demo2server.in/sites/laravelapp/skeuomo/api/artisan/profile?id=72&userid= 173
        
        let  url  = String(format: "%@artisan/profile?id=%@&userid=%@", kSkeuomoMainURL,strID,strUserid)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            
                            self.dictUser = ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "userDetails") as! NSDictionary
                            
                            self.tblProflieDetails.reloadData()
                            
                        }
                            
                        else
                        {
                            print("failed")
                            
                            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                            
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
    
}
