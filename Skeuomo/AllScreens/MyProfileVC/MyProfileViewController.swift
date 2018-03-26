//
//  MyProfileViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 23/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking
import SDWebImage

class MyProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    var arrPersonal = NSMutableArray()
    var arrContact  = NSMutableArray()
    var arrGenral   = NSMutableArray()
    var arrAddtional   = NSMutableArray()
    
    @IBOutlet var viewPersonal  : UIView!
    @IBOutlet var viewContact   : UIView!
    @IBOutlet var viewGenral    : UIView!
    @IBOutlet var viewAddtional : UIView!
    
    
    var dictUser = NSDictionary()
    
    @IBOutlet var tblProfileData: UITableView!
    
    @IBOutlet weak var imgThemeBG: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        HelpingMethods.sharedInstance.ShowHUD()
        
        self.performSelector(inBackground: #selector(getUserProfileAPI), with: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(methodReloadProfile),
            name: NSNotification.Name(rawValue: "UPDATE_USER_PROFILE"),
            object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
        
        if UserDefaults.standard.object(forKey: "Theme") != nil {
            
            let dicTheme = UserDefaults.standard.object(forKey: "Theme") as! NSDictionary
            
            if dicTheme.allKeys.count > 0
            {
                let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicTheme.object(forKey: "themePic") as? String)!)
                
                let urlImage = URL.init(string: urlStr as String)
                
                imgThemeBG.setImageWith(urlImage!, placeholderImage: UIImage.init(named:""))
            }
            else
            {
                imgThemeBG.image = UIImage.init(named: "")
            }
        }
    }
    
    func methodReloadProfile()
    {
        self.performSelector(inBackground: #selector(getUserProfileAPI), with: nil)
        
    }

    
    //MARK: - ButtonsMethod
    @IBAction func btnBack(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnEditProflie(_ sender: Any)
    {
        let ObjMyEdit  = MyEditProfileVC(nibName:"MyEditProfileVC", bundle:nil)
        ObjMyEdit.dictUserData = self.dictUser
        self.navigationController?.pushViewController(ObjMyEdit, animated: true)
    }
    
    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if(dictUser.allKeys.count > 0)
        {
            return 5
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
        }
        if section == 1
        {
            return 4
        }
        if section == 2
        {
            return 2
        }
        if section == 3
        {
            return 3
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
        if section == 0
        {
            return nil
        }
        if section == 1
        {
            return viewPersonal
        }
        if section == 2
        {
            return viewContact
        }
        if section == 3
        {
            return viewGenral
        }
        else
        {
            return viewAddtional
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 266
        }
        else if indexPath.section == 1
        {
            
            if(indexPath.row == 0)
            {
                if(((self.dictUser.object(forKey: "firstName") as? String)?.characters.count)! > 0)
                {
                    return 70
                }
                else
                {
                    return 0
                }
            }
            else if(indexPath.row == 1)
            {
                if(((self.dictUser.object(forKey: "username") as? String)?.characters.count)! > 0)
                {
                    return 70
                }
                else
                {
                    return 0
                }
            }
                
            else if(indexPath.row == 2)
            {
                if(((self.dictUser.object(forKey: "gender") as? String)?.characters.count)! > 0)
                {
                    return 70
                }
                else
                {
                    return 0
                }
            }
            else
            {
                if(((self.dictUser.object(forKey: "dob") as? String)?.characters.count)! > 0)
                {
                    return 70
                }
                else
                {
                    return 0
                }
            }
        }
        else if indexPath.section == 2
        {
            if indexPath.row == 0
            {
                if (self.dictUser.object(forKey: "mobile_number") as! String).characters.count > 0
                {
                    return 70
                }
                else
                {
                    return 0
                }
            }
            else
            {
                if (self.dictUser.object(forKey: "email") as! String).characters.count > 0
                {
                    return 70
                }
                else
                {
                    return 0
                }
            }
        }
        else if indexPath.section == 3
        {
            //GENERAL INFORMATION
        
            if(indexPath.row == 0)
            {
                if ((self.dictUser.object(forKey: "companyName") as? String)?.characters.count)! > 0
                {
                    return 70
                }
                else
                {
                    return 0
                }
            }
            if(indexPath.row == 1)
            {
                if(((self.dictUser.object(forKey: "website") as? String)?.characters.count)! > 0)
                {
                    return 70
                }
                else
                {
                    return 0
                }
            }
            else
            {
                if self.dictUser.object(forKey: "status") as? Int == 1
                {
                    return 70
                }
                else
                {
                    return 0
                }
            }
        }
        else
        {
            if (self.dictUser.object(forKey: "city") as! String).characters.count > 0
            {
                return 70
            }
            else
            {
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
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
            
            
            cell?.imgProfile.setImageWith(urlImage as URL, placeholderImage: UIImage.init(named:"user_place"))

            
            cell?.imgProfile.layer.cornerRadius = (cell?.imgProfile.frame.size.width)! / 2
            cell?.imgProfile.layer.masksToBounds =  true
            
            cell?.imgProfile.layer.borderWidth = 1.0
            cell?.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
            
            //background image
            let urlStr1 = NSString(format: "%@%@",kSkeuomoImageURL,(self.dictUser.object(forKey: "backgroung_picture") as? String)!)
            
            let urlImage1 : NSURL = NSURL(string: urlStr1 as String)!
            
            
            cell?.imgBgProfile.setImageWith(urlImage1 as URL, placeholderImage: UIImage.init(named:"bgS.png"))


            cell?.btnCamera.isHidden = true
            cell?.btnBgCamera.isHidden = true
            
            
            cell?.lblUserName.text = NSString(format: "%@ %@",(self.dictUser.object(forKey: "firstName") as? String)!,(self.dictUser.object(forKey: "lastName") as? String)!) as String
            
            let strLocation =  NSString(format: " %@, %@, %@",(self.dictUser.object(forKey: "city") as? String)!,(self.dictUser.object(forKey: "state") as? String)!,(dictUser.object(forKey: "country")  as! NSDictionary).object(forKey: "name") as! String ) as String
            
            
            cell?.btnAddress.setTitle(strLocation, for: UIControlState.normal)
            cell?.lblAddress.isHidden = true
            
            cell?.lblFollowers.text = "25"
            cell?.lblFollowing.text = "25"
            
            return cell!
        }
        if indexPath.section == 1
        {
            
            let cellIdentifier:String = "UserDetailsTblCell"
            var cell:UserDetailsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UserDetailsTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("UserDetailsTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? UserDetailsTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            
            cell?.layer.masksToBounds = true
            
            cell?.txtNames.isUserInteractionEnabled = false
            
            
            if indexPath.row == 0
            {//full_name
                
                cell?.lblTitleName.text = "Full Name"
                
                cell?.txtNames.text = String.init(format: "%@ %@", (dictUser.object(forKey: "firstName") as! String?)!,(dictUser.object(forKey: "lastName") as! String?)!)
                
                return cell!
            }
            else if indexPath.row == 1
            {//User Name
                
                cell?.lblTitleName.text = "User Name"
                cell?.txtNames.text = dictUser.object(forKey: "username") as! String?
                
                return cell!
            }
            else if indexPath.row == 2
            {// gender
                
                cell?.lblTitleName.text = "Gender"
                cell?.txtNames.text = dictUser.object(forKey: "gender") as! String?
                
                return cell!
            }
            else
            {//DOB
                
                cell?.lblTitleName.text = "Date of Birth"
                cell?.txtNames.text = dictUser.object(forKey: "dob") as! String?
                
                return cell!
            }

        }
        else if indexPath.section == 2
        {
            let cellIdentifier:String = "UserDetailsTblCell"
            var cell:UserDetailsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UserDetailsTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("UserDetailsTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? UserDetailsTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            cell?.layer.masksToBounds = true

            
            cell?.txtNames.isUserInteractionEnabled = false
            
            
            if indexPath.row == 0
            {
                
                cell?.lblTitleName.text = "Phone"
                cell?.txtNames.text = dictUser.object(forKey: "mobile_number") as! String?
                
                return cell!
            }
            else
            {
                
                cell?.lblTitleName.text = "Email"
                cell?.txtNames.text = dictUser.object(forKey: "email") as! String?
                
                return cell!
            }
        }
        else if indexPath.section == 3
        {
            //GENERAL INFORMATION
            let cellIdentifier:String = "UserDetailsTblCell"
            var cell:UserDetailsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UserDetailsTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("UserDetailsTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? UserDetailsTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            cell?.layer.masksToBounds = true

            
            cell?.txtNames.isUserInteractionEnabled = false
            
            
            if indexPath.row == 0
            {//companyName
                
                cell?.lblTitleName.text = "Company Name"
                cell?.txtNames.text = dictUser.object(forKey: "companyName") as! String?
                
                return cell!
            }
            else if indexPath.row == 1
            {//Website
                
                cell?.lblTitleName.text = "Website"
                cell?.txtNames.text = dictUser.object(forKey: "website") as! String?
                
                return cell!
            }
            else
            {//Status
                
                cell?.lblTitleName.text = "Status"
                if(dictUser.object(forKey: "status") as! Int == 1 )
                {
                    cell?.txtNames.text = "Active"
                }
                else
                {
                    cell?.txtNames.text = "Inactive"
                }
                
                return cell!
            }

        }
            
        else
        {
            //ADDITIONAL INFORMATION
            
            let cellIdentifier:String = "UserDetailsTblCell"
            var cell:UserDetailsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UserDetailsTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("UserDetailsTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? UserDetailsTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            cell?.layer.masksToBounds = true

            
            cell?.txtNames.isUserInteractionEnabled = false
            cell?.lblTitleName.text = "Address"
            
            
            let strLocation =  NSString(format: " %@, %@, %@",(self.dictUser.object(forKey: "city") as? String)!,(self.dictUser.object(forKey: "state") as? String)!,(dictUser.object(forKey: "country")  as! NSDictionary).object(forKey: "name") as! String ) as String
            
            if self.dictUser.object(forKey: "zipCode") != nil && (self.dictUser.object(forKey: "zipCode") as! String).characters.count > 0
            {
                cell?.txtNames.text = String.init(format: "%@, %@", strLocation, self.dictUser.object(forKey: "zipCode") as! String)
            }
            else
            {
                cell?.txtNames.text = strLocation

            }
            
            
            return cell!


        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }

    //MARK: - getUserProfileAPI
    
    func getUserProfileAPI()
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
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        
        
        let  url  = String(format: "%@getUser?userid=%@", kSkeuomoMainURL,strUserid)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            UserDefaults.standard.set( ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "user") as! NSDictionary, forKey: "UserDatail")
                            
                            
                            UserDefaults.standard.synchronize()
                            
                            self.dictUser = ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "user") as! NSDictionary
                            
                            self.tblProfileData.reloadData()
                            
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
