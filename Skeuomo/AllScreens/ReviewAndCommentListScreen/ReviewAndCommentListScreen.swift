//
//  ReviewAndCommentListScreen.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 07/02/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class ReviewAndCommentListScreen: UIViewController, UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet var tblComment: UITableView!

    var currentPage = 1
    var totalPage = 0
    var totalPageRecord = 0
    
    var arrComment = NSMutableArray()
    var boolCmtGetData = false
    
    var refreshControl : UIRefreshControl!
    
    let fontDescription = UIFont.init(name: "Gibson-Light", size: 12)
    
    var dateFormateServer             :DateFormatter!
    var dateFormate                   :DateFormatter!
    
    var strModule = ""
    var strID = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        dateFormateServer  = DateFormatter()
        dateFormateServer.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        dateFormate  = DateFormatter()
        dateFormate.dateFormat = "MMMM dd, YYYY HH:mm:ss a"
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetComment), with: nil)
        
        
        refreshControl = UIRefreshControl()
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *)
        {
            tblComment.refreshControl = refreshControl
        }
        else
        {
            tblComment.addSubview(refreshControl)
        }
        
    }

    func refreshWeatherData(_ sender: Any)
    {
        if currentPage != totalPage
        {
            if !boolCmtGetData
            {
                boolCmtGetData = true
                currentPage += 1
                performSelector(inBackground: #selector(self.GetComment), with: nil)
            }
        }
        
        let when = DispatchTime.now() + 3
        
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            // Your code with delay
            self.refreshControl.endRefreshing()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - UIButton Methods
    
    @IBAction func btnBack(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    //MARK:- UITableView Delegate and Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrComment.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let dicComment = arrComment.object(at: indexPath.row ) as! NSDictionary
        
        let strComment =  dicComment.object(forKey: "review") as? String
        
        let height = self.Method_HeightCalculation(text: strComment!, font: fontDescription!, width: UIScreen.main.bounds.size.width - 60)
        
        
        let TotalHeight : CGFloat = 80
        let ExtraHeight : CGFloat = 10.0
        
        if height > 30
        {
            return TotalHeight + height + ExtraHeight
        }
        else
        {
            return TotalHeight + 35.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "ReviewAndCommentListCell"
        var cell:ReviewAndCommentListCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ReviewAndCommentListCell
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("ReviewAndCommentListCell", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? ReviewAndCommentListCell
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = (UIColor.clear);
        }
        
        cell?.imgUser.layer.cornerRadius = (cell?.imgUser.frame.size.width)!/2
        cell?.imgUser.layer.masksToBounds = true
        
        let dicComment = arrComment.object(at: indexPath.row ) as! NSDictionary
        
        let CreateDate = dateFormateServer.date(from: dicComment.valueForNullableKey(key: "created_at"))
        
        let dicUser = dicComment.object(forKey: "user") as! NSDictionary
        
        let strUserImage = dicUser.object(forKey: "profile_picture") as! String
        let urlStrUser = NSString(format: "%@%@",kSkeuomoImageURL,strUserImage)
        let urlImageUser = URL.init(string: urlStrUser as String)
        
        var strCreatedDate = ""
        
        if CreateDate != nil
        {
            strCreatedDate = dateFormate.string(from: CreateDate!)
        }
        
        cell?.lblName.text = String(format: "%@ %@", (dicUser.object(forKey: "firstName") as? String)!, (dicUser.object(forKey: "lastName") as? String)!)
        
        cell?.lblDayTime.text = strCreatedDate
        cell?.imgUser.setImageWith(urlImageUser!, placeholderImage: UIImage.init(named:"user_place"))
        
        let strComment =  dicComment.object(forKey: "review") as? String
        cell?.lblDescription.text = strComment
        
        let strSubject =  dicComment.object(forKey: "subject") as? String
        cell?.lblSubject.text = strSubject

        
        cell?.rating.isUserInteractionEnabled = false
        
        let rate = dicComment.object(forKey: "rating") as? NSNumber
        
        
        cell?.rating.setStars(Int32(Int(rate!)), callbackBlock: nil)
        
        return cell!
    }

    func GetComment()
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
        
        parameters.setValue(currentPage, forKey: "page")
        
        parameters.setValue(strID, forKey: "id")
        
        parameters.setValue(strModule, forKey: "module_name")

        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        //http://demo2server.in/sites/laravelapp/skeuomo/api/comment/get?module_name=artwork&page=1&id=39&userid=131
        
        let  url  = String(format: "%@comment/get?module_name=%@&page=%d&id=%@&userid=%@", kSkeuomoMainURL,strModule,currentPage,strID,strUserid)
        
        print("Get Post URL :",url)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            
                            if DicResponseData.object(forKey: "comments") != nil
                            {
                                
                                if DicResponseData.object(forKey: "comments") is NSArray && (DicResponseData.object(forKey: "comments") as! NSArray).count == 0
                                {
                                    
                                    print("No record found")
                                    
                                    //                                    if self.arrComment.count == 0
                                    //                                    {
                                    //                                        HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle:  "Record Not Found" , controller: self)
                                    //                                    }
                                    
                                    
                                }
                                else
                                {
                                    if (DicResponseData.object(forKey: "comments") as! NSDictionary).object(forKey: "data") != nil
                                    {
                                        let tempArr = (DicResponseData.object(forKey: "comments") as! NSDictionary).object(forKey: "data") as! NSArray
                                        
                                        let tempTotalPage = (DicResponseData.object(forKey: "comments") as! NSDictionary).object(forKey:"last_page") as! Int
                                        
                                        let tempTotalRecord = (DicResponseData.object(forKey: "comments") as! NSDictionary).object(forKey:"total") as! Int
                                        
                                        if self.arrComment.count > 0 && self.currentPage == 1
                                        {
                                            self.arrComment.removeAllObjects()
                                            
                                            self.arrComment.addObjects(from: tempArr.reverseObjectEnumerator().allObjects)
                                        }
                                        else
                                        {
                                            for obj in tempArr
                                            {
                                                self.arrComment.insert(obj, at: 0)
                                            }
                                        }
                                        
                                        self.totalPage = tempTotalPage
                                        self.totalPageRecord = tempTotalRecord
                                        
                                        self.boolCmtGetData = false
                                        
                                        self.tblComment.reloadData()
                                        
                                    }
                                    else
                                    {
                                        
                                        print("No record found")
                                        
                                        
                                        //                                        if self.arrComment.count == 0
                                        //                                        {
                                        //                                            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle:  "Record Not Found" , controller: self)
                                        //                                        }
                                    }
                                }
                                
                                
                                
                                
                            }
                        }
                            
                        else
                        {
                            print("failed")
                            
                            // HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                            
                            
                            
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
