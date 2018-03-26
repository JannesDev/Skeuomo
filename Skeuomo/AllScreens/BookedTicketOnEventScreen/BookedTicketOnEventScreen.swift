//
//  BookedTicketOnEventScreen.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 30/11/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class BookedTicketOnEventScreen: UIViewController ,UITableViewDelegate , UITableViewDataSource {

    
    @IBOutlet weak var tblBooking: UITableView!
    @IBOutlet weak var imgThemeBG: UIImageView!

    
    var currentPage = 1
    var totalPage = 0
    var totalPageRecord = 0
    
    var arrBookedTickets = NSMutableArray()

    var spinner : UIActivityIndicatorView!

    
    var strEventId = ""
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tblBooking.tableFooterView = UIView()
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetBookedTickets), with: nil)
        
        // Do any additional setup after loading the view.
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
    

    // MARK: - UIButton Events
    

    @IBAction func btnBack(_ sender: AnyObject)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
 
    //MARK: - UITableView Data Source & Delagate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(currentPage < totalPage)
        {
            return arrBookedTickets.count + 1
        }
        else
        {
            return arrBookedTickets.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == arrBookedTickets.count
        {
            return 44
        }
        
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == arrBookedTickets.count
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            
            if (cell == nil)
            {
                cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
                
                spinner = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
                spinner.frame = CGRect(x: (tableView.frame.size.width-20)/2, y: 12, width: 20, height: 20)
                
                cell?.addSubview(spinner)
                
            }
            
            spinner.startAnimating()
            
            return cell!
        }
        
        
        
            let cellIdentifier:String = "BookedTicketOnEventCell"
            
            var cell:BookedTicketOnEventCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? BookedTicketOnEventCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("BookedTicketOnEventCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? BookedTicketOnEventCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
        
        
        cell?.imgUser.layer.masksToBounds = true
        cell?.imgUser.layer.cornerRadius = (cell?.imgUser.frame.size.width)! / 2
        
        let DicBookedUser = (arrBookedTickets.object(at: indexPath.row) as! NSDictionary).object(forKey: "booked_user") as! NSDictionary
        
        cell?.lblAddress.text = DicBookedUser.object(forKey: "address") as? String
        
        
        
        
        cell?.lblUsername.text = String(format: "%@ %@", (DicBookedUser.object(forKey: "firstName") as? String)!,(DicBookedUser.object(forKey: "lastName") as? String)!)

        
        let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(DicBookedUser.object(forKey: "profile_picture") as? String)!)
        
        let urlImage = URL.init(string: urlStr as String)
        
        
        cell?.imgUser.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))
        
        cell?.lblNoOfTicket.text = (arrBookedTickets.object(at: indexPath.row) as! NSDictionary).valueForNullableKey(key: "tickets")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row == arrBookedTickets.count - 2
        {
            if currentPage != totalPage
            {
                currentPage = currentPage + 1
                
                self.performSelector(inBackground: #selector(GetBookedTickets), with:nil)
            }
        }
    }

    
    //MARK: - Webservice Methods
    
    func GetBookedTickets()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        parameters.setValue(currentPage, forKey: "page")
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        parameters.setObject(strEventId, forKey: "id" as NSCopying)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        
        //http://demo2server.in/sites/laravelapp/skeuomo/api/event/booked?event_id=10&userid=74
        
        let  url  = String(format: "%@event/booking?page=%d&id=%@&userid=%@", kSkeuomoMainURL,currentPage,strEventId,strUserid)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            if DicResponseData.object(forKey: "booking") != nil
                            {
                                if (DicResponseData.object(forKey: "booking") as! NSDictionary).object(forKey: "data") != nil
                                {
                                    let tempArr = (DicResponseData.object(forKey: "booking") as! NSDictionary).object(forKey: "data") as! NSArray
                                    
                                    let tempTotalPage = (DicResponseData.object(forKey: "booking") as! NSDictionary).object(forKey:"last_page") as! Int
                                    
                                    let tempTotalRecord = (DicResponseData.object(forKey: "booking") as! NSDictionary).object(forKey:"total") as! Int
                                    
                                    if self.arrBookedTickets.count > 0 && self.currentPage == 1
                                    {
                                        self.arrBookedTickets.removeAllObjects()
                                    }
                                    
                                    self.arrBookedTickets.addObjects(from: tempArr as! [NSDictionary])
                                    
                                    self.totalPage = tempTotalPage
                                    self.totalPageRecord = tempTotalRecord
                                    
                                    self.tblBooking.reloadData()
                                }
                            }
                        }
                        else
                        {
                            print("failed")
                            
                            
                            
                            //  HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
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
