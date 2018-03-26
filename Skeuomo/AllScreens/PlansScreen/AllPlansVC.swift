//
//  AllPlansVC.swift
//  Skeuomo
//
//  Created by by Jannes on 16/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class AllPlansVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblAllPlans: UITableView!
    
    @IBOutlet weak var imgThemeBG: UIImageView!
    
    var isClick: Int!
    var arrPlans = NSArray()
//    var arrPlansType : NSArray!
//    var arrAmountType : NSArray!
//    var arrBoundationType : NSArray!
     var arrBGImages : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblAllPlans.isHidden = true
        
//        arrPlansType = ["SOCIAL ACCOUNT", "ARTISAN", "CURATOR", "VENDOR"]
//        arrAmountType = ["FREE", "$149.99", "$199.99", "$249.99"]
//        arrBoundationType = ["Limited Talent/Curator Profile", "Extended Talented Profile", "Extended Curator Profile", "Artists with customised newsletter"]
      arrBGImages = ["b.png", "g.png", "o.png", "r.png"]
        
        isClick = -1
        tblAllPlans.tableFooterView = UIView()
        
        if HelpingMethods.sharedInstance.isInternetAvailable() == false
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"No Internet Connection" , strSubtitle: "Make sure your device is connected to the internet.", controller: self)
        }
        else
        {
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(AllPlansVC.getPlansAll), with: nil)
        }

        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     // MARK: - ButtonsMethod
    @IBAction func btnSideMenu(_ sender: UIButton)
    {
    }
    @IBAction func btnSearching(_ sender: UIButton)
    {
    }
    @IBAction func btnNotifications(_ sender: UIButton)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }

    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return  self.arrPlans.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        if isClick == section
        {
            return 5
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 154
        }
        else
        {
            return 38
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cellIdentifier:String = "AllPlansTblCell"
            var cell:AllPlansTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? AllPlansTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("AllPlansTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? AllPlansTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            cell?.btnDropDown.tag = indexPath.section
            cell?.btnDropDown.addTarget(self,action: #selector(btnSelectDropDown),for: UIControlEvents.touchUpInside)
            
            if isClick == indexPath.section
            {
               cell?.btnDropDown.isSelected = false
            }
            else
            {
                 cell?.btnDropDown.isSelected = true
            }
            cell?.lblCadPlans.isHidden = false
            
            if  (arrPlans.object(at: indexPath.section) as? NSDictionary)?.object(forKey: "title") as! String ==  ""
            {
               cell?.lblCadPlans.isHidden = true
            }
            
            cell?.lblAccountType.text = (arrPlans.object(at: indexPath.section) as? NSDictionary)?.object(forKey: "title") as! String?
            
            
             cell?.lblAmounts.text = (arrPlans.object(at: indexPath.section) as? NSDictionary)?.object(forKey: "price") as! String?
        //    cell?.lblLimitedTalent.text = arrBoundationType.object(at: indexPath.section)as? String
            
           // cell?.lblAccountType.text = arrPlansType.object(at: indexPath.section)as? String
            
            cell?.imgPlansBG.image =  UIImage.init(named: arrBGImages.object(at: indexPath.section) as! String)
            cell?.btnBuyNow.layer.cornerRadius = 14.0
            cell?.btnBuyNow.layer.masksToBounds = true
            
             cell?.btnBuyNow.tag = indexPath.section
            cell?.btnBuyNow.addTarget(self, action: #selector(btnOpenHomeScreen), for: .touchUpInside)
            return cell!
        }

        else
        {
            let cellIdentifier:String = "PlansTblDetailsCell"
            var cell:PlansTblDetailsCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PlansTblDetailsCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("PlansTblDetailsCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? PlansTblDetailsCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            return cell!
        }

    }
    func btnOpenHomeScreen(sender:UIButton)
    {
          self.appDelegate.showtabbar()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         //  self.appDelegate.showtabbar()
    }
    
    func btnSelectDropDown(sender:UIButton)
    {
        if isClick == sender.tag
        {
            isClick = -1
        }
        else
        {
            isClick = sender.tag
        }
        
        tblAllPlans.reloadData()
    }

    func getPlansAll()  {
        
        var urlstring:String!
        urlstring = String(format: "%@packageList?", kSkeuomoMainURL)
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed);        print(urlstring)
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        let utcTimestamp = Date().timeIntervalSince1970
        let token = appDelegate.MD5(NSString.init(format: "%f", utcTimestamp) as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        manager.get(urlstring, parameters: nil, progress: nil, success: { (operation, responseObject) in
            print(responseObject)
            DispatchQueue.main.async
                {
                    HelpingMethods.sharedInstance.hideHUD()

            if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
            {
                if ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "plans") != nil
                {
                    self.arrPlans = ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "plans") as! NSArray
                    if self.arrPlans.count > 0
                    {
                        self.tblAllPlans.isHidden = false
                        self.tblAllPlans.reloadData()
                    }
                    
                }
                    }
            else
            {
                 HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
            }
            }
        }) { (operation, error) in
            HelpingMethods.sharedInstance.hideHUD()
            
            HelpingMethods.sharedInstance.Showerrormessage(error: error, controller: self)

        }
        
    }

}
