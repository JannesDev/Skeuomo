//
//  MyAuctionDetailsVC.swift
//  Skeuomo
//
//  Created by by Jannes on 21/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class MyAuctionDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblMyAuction: UITableView!
    @IBOutlet weak var imgThemeBG: UIImageView!
    
    var strAuctionID = ""
    
    var dicAuction = NSDictionary()
    
    var currentPage = 1
    var totalPage = 0
    var totalPageRecord = 0
    
    var arrBids = NSMutableArray()
    var spinner : UIActivityIndicatorView!
    
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.tblMyAuction.tableFooterView = UIView()
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(getAllBidsDetails), with: nil)
        
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
     // MARK: - ButtonsMethods
    
    @IBAction func btnBack(_ sender: Any)
    {
      _ =  self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearching(_ sender: UIButton)
    {
    }
    @IBAction func btnNotifications(_ sender: UIButton)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    
    //MARK: - UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrBids.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 62
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "MyAucDetailTblCell"
        var cell:MyAucDetailTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MyAucDetailTblCell
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("MyAucDetailTblCell", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? MyAucDetailTblCell
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = (UIColor.clear);
        }
        
        //ForIncraseSeparatorSize
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        
        
        cell?.imgUser.layer.masksToBounds = true
        cell?.imgUser.layer.cornerRadius = (cell?.imgUser.frame.size.width)! / 2
        
        cell?.btnWinner.layer.cornerRadius = 10.0
        cell?.btnWinner.layer.masksToBounds = true
        cell?.btnWinner.isHidden = true
        
        let dicBid = arrBids.object(at: indexPath.row) as! NSDictionary
        let dicBidUser = dicBid.object(forKey: "bid_user") as! NSDictionary
        
        cell?.lblLocation.text = dicBidUser.object(forKey: "city") as? String
        
        
        
        cell?.lblUsername.text = String(format: "%@ %@", (dicBidUser.object(forKey: "firstName") as? String)!,(dicBidUser.object(forKey: "lastName") as? String)!)

        let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicBidUser.object(forKey: "profile_picture") as? String)!)
        
        let urlImage = URL.init(string: urlStr as String)
        
        cell?.imgUser.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"user_place"))
        
        cell?.btnBidPrice.text = String(format: "$%d", dicBid.object(forKey: "price") as! Int)
        
        if dicBid.object(forKey: "bidStatus") != nil
        {
            let strStatus = dicBid.object(forKey: "bidStatus") as! String
            
            if strStatus.characters.count > 0
            {
                cell?.btnWinner.isHidden = false
                cell?.btnWinner.setTitle(strStatus, for: .normal)
                
                if strStatus == "highest"
                {
                    cell?.btnWinner.backgroundColor = UIColor.init(red: 16.0/255.0, green: 134.0/255.0, blue: 254.0/255.0, alpha: 1.0)
                }
                else
                {
                    cell?.btnWinner.backgroundColor = UIColor.init(red: 21.0/255.0, green: 177.0/255.0, blue: 75.0/255.0, alpha: 1.0)
                }
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }


    //MARK: - Web Service Method
    
    func getAllBidsDetails()
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
        
        parameters.setObject(strAuctionID, forKey: "id" as NSCopying)

        // http://demo2server.in/sites/laravelapp/skeuomo/api/bid/detail?userid=86&id=1
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let url = String(format: "%@bid/detail?userid=%@&id=%@", kSkeuomoMainURL,strUserid,strAuctionID)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            if DicResponseData.object(forKey: "auction") != nil
                            {
                                self.dicAuction = DicResponseData.object(forKey: "auction") as! NSDictionary
                            }
                            if DicResponseData.object(forKey: "bid") != nil
                            {
                                if (DicResponseData.object(forKey: "bid") as! NSDictionary).object(forKey: "data") != nil
                                {
                                    
                                    let tempArr = (DicResponseData.object(forKey: "bid") as! NSDictionary).object(forKey: "data") as! NSArray
                                    
                                    let tempTotalPage = (DicResponseData.object(forKey: "bid") as! NSDictionary).object(forKey:"last_page") as! Int
                                    
                                    let tempTotalRecord = (DicResponseData.object(forKey: "bid") as! NSDictionary).object(forKey:"total") as! Int
                                    
                                    if self.arrBids.count > 0 && self.currentPage == 1
                                    {
                                        self.arrBids.removeAllObjects()
                                    }
                                    
                                    self.arrBids.addObjects(from: tempArr as! [NSDictionary])
                                    
                                    self.totalPage = tempTotalPage
                                    self.totalPageRecord = tempTotalRecord
                                    
                                    self.tblMyAuction.reloadData()
                                    
                                }
                            }
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
