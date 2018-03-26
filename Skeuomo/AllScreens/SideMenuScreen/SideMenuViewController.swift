//
//  SideMenuViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 16/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import SDWebImage
import AFNetworking

class SideMenuViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate{

    @IBOutlet weak var lblTitleName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUserPro: UIImageView!
    @IBOutlet weak var tblSideMenu: UITableView!
    

    var arrSideMenus : NSArray!
    var arrImgSideMenus : NSArray!
    var arrImgActiveSideMenus : NSArray!
    
    var dictUserInfo = NSDictionary()
  
    var dictUser = NSDictionary()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        self.automaticallyAdjustsScrollViewInsets = false
        
        //dictUserInfo = (UserDefaults.standard.object(forKey: "UserDatail") as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        self.methodReloadProfile()
        
        arrSideMenus = ["Home", "Dashboard", "Artists", "Curators","Best Sellers", "Artisan Galleria","Auction Atrium", "Art Circle","Blogs","Art Geo-Map","Support","My Cart","Settings", "Logout"];
        
        arrImgSideMenus = ["home_inactive","dashboard","artist","curator","seller","galleria","auction","art_circle","blogs","artGeoMap","support","cart","settings","logout"];
        
        arrImgActiveSideMenus = ["home_active_sidemenu","dashboard_active_sidemenu","artist_active","curator_active","seller_active","galleria_active","auctionv","art_circle_active","blogs_active","artGeoMap_active","support_active","cart","settings_active","logout_active"];
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(methodReloadProfile),
            name: NSNotification.Name(rawValue: "UPDATE_USER_PROFILE"),
            object: nil)
        
    }
    
    func methodReloadProfile()
    {
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(getUserProfileAPI), with: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        print("dictUserInfo : ",dictUserInfo)
        
        
    }
    
    func methodLoadProfilePic()
    {
        lblUserName.text = String(format: "%@ %@", (dictUserInfo.object(forKey: "firstName") as? String)!,(dictUserInfo.object(forKey: "lastName") as? String)!)
        
        if(dictUserInfo.object(forKey: "profile_picture") != nil)
        {
            
            let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(self.dictUserInfo.object(forKey: "profile_picture") as? String)!)
            
            let urlImage : NSURL = NSURL(string: urlStr as String)!
            
            
            imgUserPro.sd_setImage(with: urlImage as URL!, placeholderImage: UIImage.init(named:"user_place"), options: .refreshCached, completed: nil)
            
            
            imgUserPro.layer.cornerRadius = imgUserPro.frame.size.width / 2
            imgUserPro.layer.masksToBounds =  true
            
            imgUserPro.layer.borderWidth = 1.0
            imgUserPro.layer.borderColor = UIColor.lightGray.cgColor
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - ButtonsMethods
    @IBAction func btnEditProflie(_ sender: Any)
    {
        
        let demoController = MyEditProfileVC(nibName: "MyEditProfileVC",bundle: nil)
        demoController.dictUserData = UserDefaults.standard.object(forKey: "UserDatail") as! NSDictionary
        demoController.fromSideMenu = "FromSideMenu"
        let navArt = UINavigationController(rootViewController: demoController)
        navArt.isNavigationBarHidden = true
        
        self.sideMenuController().changeContentViewController(navArt, closeMenu: true)

        sideMenuController().closeMenu()

    }

    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
//        if(dictUserInfo.allKeys.count > 0)
//        {
            return 1
//        }
//        else
//        {
//          return 0
//        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrSideMenus.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "SideMenuTblCell"
        var cell:SideMenuTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SideMenuTblCell
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("SideMenuTblCell", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? SideMenuTblCell
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
           cell?.backgroundColor = (UIColor.clear);
        }
        //ForIncraseSeparatorSize
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        if indexPath.row == 0
        {
            cell?.backgroundColor = UIColor.init(red: 16/255.0, green: 134/255.0, blue: 254/255.0, alpha: 1.0)
            cell?.lblSideOptions.textColor = UIColor.white
            cell?.btnDot.isSelected = true
            
            
        }
        
        cell?.lblSideOptions.text = arrSideMenus.object(at: indexPath.row) as? String
        
        
        cell?.btnDot.setImage(UIImage.init(named: arrImgActiveSideMenus.object(at: indexPath.row) as! String), for: UIControlState.selected)
        
        cell?.btnDot.setImage(UIImage.init(named: arrImgSideMenus.object(at: indexPath.row) as! String), for: UIControlState.normal)
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (indexPath as NSIndexPath).section==0
        {
            switch (indexPath as NSIndexPath).row
            {
            case 0:
                let demoController = HomeViewController(nibName: "HomeViewController",bundle: nil)
                let tempIndex = appDelegate.TabLogin.selectedIndex
                
                self.sideMenuController().changeContentViewController(appDelegate.TabLogin, closeMenu: true)
                appDelegate.TabLogin.selectedIndex = 0

               // appDelegate.replaceTabBarViewControllerAtIndex(index: tempIndex, newVC: demoController)
                sideMenuController().closeMenu()
                
                break;
                
            case 1:
                
                let demoController = DeshboardMenuScreen(nibName: "DeshboardMenuScreen", bundle:nil)

                
              //  let demoController = DeshboardViewController(nibName: "DeshboardViewController",bundle: nil)
                
                let tempIndex = appDelegate.TabLogin.selectedIndex
                self.sideMenuController().changeContentViewController(appDelegate.TabLogin, closeMenu: true)

                appDelegate.TabLogin.selectedIndex = 3
               
                
                
                sideMenuController().closeMenu()
                
                  break;
                
            case 2:

              let demoController = ArtistsViewController(nibName: "ArtistsViewController",bundle: nil)
              
             // let tempIndex = appDelegate.TabLogin.selectedIndex
              
              let navArt = UINavigationController(rootViewController: demoController)
              navArt.isNavigationBarHidden = true
              
              self.sideMenuController().changeContentViewController(navArt, closeMenu: true)
              
              sideMenuController().closeMenu()
              
              
                break;
            case 3:
                //curator
                let demoController = CuratorsScreen(nibName: "CuratorsScreen",bundle: nil)
                
                let navBest = UINavigationController(rootViewController: demoController)
                navBest.isNavigationBarHidden = true
                
                self.sideMenuController().changeContentViewController(navBest, closeMenu: true)
                //   appDelegate.replaceTabBarViewControllerAtIndex(index: tempIndex, newVC: demoController)
                
                sideMenuController().closeMenu()
                
                break;

            case 4:
                
                let demoController = BestSellerScreen(nibName: "BestSellerScreen",bundle: nil)
                
                let navBest = UINavigationController(rootViewController: demoController)
                navBest.isNavigationBarHidden = true
                
                self.sideMenuController().changeContentViewController(navBest, closeMenu: true)
                //   appDelegate.replaceTabBarViewControllerAtIndex(index: tempIndex, newVC: demoController)
                
                sideMenuController().closeMenu()
                
                break;
            case 5:
                let demoController = ArtistsGalleriaVC(nibName: "ArtistsGalleriaVC",bundle: nil)
                
                let navArt1 = UINavigationController(rootViewController: demoController)
                navArt1.isNavigationBarHidden = true
                
                self.sideMenuController().changeContentViewController(navArt1, closeMenu: true)
                //   appDelegate.replaceTabBarViewControllerAtIndex(index: tempIndex, newVC: demoController)
                
                sideMenuController().closeMenu()
                break;
            case 6:
                
                let demoController = AuctionViewController(nibName: "AuctionViewController",bundle: nil)
                
                let navArt2 = UINavigationController(rootViewController: demoController)
                navArt2.isNavigationBarHidden = true
                
                self.sideMenuController().changeContentViewController(navArt2, closeMenu: true)
                //   appDelegate.replaceTabBarViewControllerAtIndex(index: tempIndex, newVC: demoController)
                
                sideMenuController().closeMenu()
                
                break;
            case 7:
                let demoController = CommunitySharingVC(nibName: "CommunitySharingVC",bundle: nil)
                
                let navComm = UINavigationController(rootViewController: demoController)
                navComm.isNavigationBarHidden = true
                
                self.sideMenuController().changeContentViewController(navComm, closeMenu: true)
                //   appDelegate.replaceTabBarViewControllerAtIndex(index: tempIndex, newVC: demoController)
                
                sideMenuController().closeMenu()
                
                break;
            case 8:
                let demoController = BlogsViewController(nibName: "BlogsViewController",bundle: nil)
                
                let navBlog = UINavigationController(rootViewController: demoController)
                navBlog.isNavigationBarHidden = true
                
                self.sideMenuController().changeContentViewController(navBlog, closeMenu: true)
                //   appDelegate.replaceTabBarViewControllerAtIndex(index: tempIndex, newVC: demoController)
                
                sideMenuController().closeMenu()
                
                  break;
            case 9:
                let demoController = EventsShowVC(nibName: "EventsShowVC",bundle: nil)
                
                let tempIndex = appDelegate.TabLogin.selectedIndex
                
                self.sideMenuController().changeContentViewController(appDelegate.TabLogin, closeMenu: true)
                
                appDelegate.TabLogin.selectedIndex = 2
              
                sideMenuController().closeMenu()

                
                break;
            case 10:
                let demoController = SupportViewController(nibName: "SupportViewController",bundle: nil)
                
                let navSupp = UINavigationController(rootViewController: demoController)
                navSupp.isNavigationBarHidden = true
                
                self.sideMenuController().changeContentViewController(navSupp, closeMenu: true)
                //   appDelegate.replaceTabBarViewControllerAtIndex(index: tempIndex, newVC: demoController)
                
                sideMenuController().closeMenu()

                break;
                
            case 11:
                
                let demoController = CartViewController(nibName: "CartViewController",bundle: nil)
                
                let navSett1 = UINavigationController(rootViewController: demoController)
                navSett1.isNavigationBarHidden = true
                
                self.sideMenuController().changeContentViewController(navSett1, closeMenu: true)
                //   appDelegate.replaceTabBarViewControllerAtIndex(index: tempIndex, newVC: demoController)
                
                sideMenuController().closeMenu()
                break;
            case 12:
                
                let demoController = SettingsViewController(nibName: "SettingsViewController",bundle: nil)
                
                let navSett1 = UINavigationController(rootViewController: demoController)
                navSett1.isNavigationBarHidden = true
                
                self.sideMenuController().changeContentViewController(navSett1, closeMenu: true)
                //   appDelegate.replaceTabBarViewControllerAtIndex(index: tempIndex, newVC: demoController)
                
                sideMenuController().closeMenu()
                
                break
                
            case 13:
                
                let alert = UIAlertView(title: "Are you sure you want to Logout?", message: "", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
                alert.tag = 1000
                alert.show()

                break;
            default:
                break;
                
            }
        }
    }
    
    //MARK: - UIAlertview Delegate Method
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        if buttonIndex == 1
        {
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(methodLogout), with: nil)
            
        }
    }
    
    //MARK: getUserProfileAPI
    
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
                            
                            self.dictUserInfo = ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "user") as! NSDictionary
                            
                            self.tblSideMenu.reloadData()
                            self.methodLoadProfilePic()
                            
                            // let Plans  = AllPlansVC(nibName:"AllPlansVC", bundle:nil)
                            //self.navigationController?.pushViewController(Plans, animated: true)
                            
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
    
    func methodLogout()
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
        parameters.setObject("IOS" ,  forKey: "device_type" as NSCopying)
        parameters.setObject("Simulator" , forKey: "device_token" as NSCopying)
        
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        
        
        let  url  = String(format: "%@logout", kSkeuomoMainURL)
        manager.post(url as String, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            DispatchQueue.main.async
                {
                    HelpingMethods.sharedInstance.hideHUD()
                    print((responseObject as! NSDictionary))
                    
                    if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                    {
                        HelpingMethods.sharedInstance.removeUserdData()
                        self.appDelegate.showFirstPage()
                        
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
