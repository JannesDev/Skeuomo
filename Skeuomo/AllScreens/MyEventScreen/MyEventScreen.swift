//
//  MyEventScreen.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 22/11/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class MyEventScreen: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {

    @IBOutlet weak var btnManageEvent: UIButton!
    @IBOutlet weak var btnArtFundraiser: UIButton!
    @IBOutlet weak var collMyEvents: UICollectionView!
    @IBOutlet weak var imgThemeBG: UIImageView!
    
    var strSelectedTab = "ManageEvent"
    
    var blueColor = UIColor.init(red: 16.0/255.0, green: 135.0/255.0, blue: 254/255.0, alpha: 1.0)
    
    
    var currentPageManage = 1
    var totalPageManage = 0
    var totalPageRecordManage = 0
    
    
    var currentPageArtFund = 1
    var totalPageArtFund = 0
    var totalPageRecordArtFund = 0
    
    
    var arrManageEvents = NSMutableArray()
    var arrArtFundRaiser = NSMutableArray()

    var spinner : UIActivityIndicatorView!
    
    var dateFormateServer             :DateFormatter!
    var dateFormate                   :DateFormatter!
    var timeFormate                   :DateFormatter!

    var lastIndexSelected = 0

    
    @IBOutlet var tool: UIToolbar!
    
    //Cancel Booking
    
    @IBOutlet var viewCancelPopup: UIView!
    
    @IBOutlet weak var txtReasonToCancel: SZTextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnManageEvent.setTitleColor(UIColor.white, for: .normal)
        btnManageEvent.backgroundColor = blueColor
        
        btnArtFundraiser.setTitleColor(UIColor.black, for: .normal)
        btnArtFundraiser.backgroundColor = UIColor.white

        self.automaticallyAdjustsScrollViewInsets = false
        
        
        let nib = UINib(nibName: "MyEventManageCell", bundle: nil)
        collMyEvents.register(nib,forCellWithReuseIdentifier: "MyEventManageCell")
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(ManageEventList), with: nil)
        
        dateFormateServer  = DateFormatter()
        dateFormateServer.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        dateFormate  = DateFormatter()
        dateFormate.dateFormat = "YYYY-MM-dd"
        
        timeFormate  = DateFormatter()
        timeFormate.dateFormat = "HH:mm:ss"
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateEventList(notification:)), name: NSNotification.Name(rawValue: "UPDATEMYEVENTLIST"), object: nil)
        
        
        txtReasonToCancel.inputAccessoryView = tool
        
        // Do any additional setup after loading the view.
    }
    
    
    func updateEventList(notification : NSNotification)  {
        
        if notification.object != nil && notification.object is NSDictionary {
            
            let obj = notification.object as! NSDictionary
            
            if strSelectedTab == "ManageEvent"
            {
                arrManageEvents.replaceObject(at: lastIndexSelected, with: obj)
            }
            else
            {
                arrArtFundRaiser.replaceObject(at: lastIndexSelected, with: obj)
            }
            
            collMyEvents.reloadData()
            
        }
        
        
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - UITextView Events

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if textView.text == "" && text == " "
        {
            return false
        }
        
        return true
    }
    
    
    // MARK: - UIButton Events
    
    @IBAction func btnDoneToolbar(_ sender: Any)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func btnCancelPopup(_ sender: Any)
    {
        self.view.endEditing(true)

        
        viewCancelPopup.removeFromSuperview()
    }
    
    @IBAction func btnSubmitpopup(_ sender: Any)
    {
        self.view.endEditing(true)


        if txtReasonToCancel.text == ""
        {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter reason to cancel event.", controller: self)

            return
        }
        
        viewCancelPopup.removeFromSuperview()

        let strReason = txtReasonToCancel.text!
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(self.cancelEvent), with: strReason)
        
    }
    
    @IBAction func btnBack(_ sender: AnyObject)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func btnTab(_ sender: UIButton)
    {
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.backgroundColor = blueColor
        
        if sender.tag == 111 {
            
            strSelectedTab = "ManageEvent"
            
            btnArtFundraiser.setTitleColor(UIColor.black, for: .normal)
            btnArtFundraiser.backgroundColor = UIColor.white
            
            self.collMyEvents.reloadData()

            
            if arrManageEvents.count == 0 {
                
                HelpingMethods.sharedInstance.ShowHUD()
                self.performSelector(inBackground: #selector(ManageEventList), with: nil)
            }
        }
        else
        {
            strSelectedTab = "ArtFundRaiser"
            
            btnManageEvent.setTitleColor(UIColor.black, for: .normal)
            btnManageEvent.backgroundColor = UIColor.white
            
            self.collMyEvents.reloadData()

            if arrArtFundRaiser.count == 0 {
                
                HelpingMethods.sharedInstance.ShowHUD()
                self.performSelector(inBackground: #selector(FundraiserList), with: nil)
            }
        }
    }
    
    @IBAction func btnEditArtwork(_ sender: UIButton)
    {
        var dicEvent : NSDictionary!
        
        lastIndexSelected = sender.tag
        
        if strSelectedTab == "ManageEvent"
        {
            dicEvent = arrManageEvents.object(at: sender.tag) as! NSDictionary
        }
        else
        {
            dicEvent = arrArtFundRaiser.object(at: sender.tag) as! NSDictionary
        }
        
        let PostArtVC = CreateEventsVC(nibName: "CreateEventsVC", bundle: nil)
        PostArtVC.dicEventDetail = dicEvent
        self.navigationController?.pushViewController(PostArtVC, animated: true)
    }
    
    @IBAction func btnCancelEvent(_ sender: UIButton)
    {
        lastIndexSelected = sender.tag
        
        
        txtReasonToCancel.text = ""
        
        self.view.addSubview(viewCancelPopup)
        viewCancelPopup.frame = self.view.frame
        
    }
    
    
    
    @IBAction func btnBookedArtwork(_ sender: UIButton)
    {
        var dicEvent : NSDictionary!
        
        if strSelectedTab == "ManageEvent"
        {
            dicEvent = arrManageEvents.object(at: sender.tag) as! NSDictionary
        }
        else
        {
            dicEvent = arrArtFundRaiser.object(at: sender.tag) as! NSDictionary
        }
        
        let BookedEvent = BookedTicketOnEventScreen(nibName: "BookedTicketOnEventScreen", bundle: nil)
        BookedEvent.strEventId = String(describing: dicEvent.object(forKey: "id") as! NSNumber)
        self.navigationController?.pushViewController(BookedEvent, animated: true)
    }
    
    
    @IBAction func btnDeleteArtwork(_ sender: UIButton)
    {
        lastIndexSelected = sender.tag
        
        let actionSheet = UIAlertController(title: nil, message: "Are you sure want to delete this event", preferredStyle: UIAlertControllerStyle.alert)
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            
            
            var dicEvent : NSDictionary!
            
            if self.strSelectedTab == "ManageEvent"
            {
                dicEvent = self.arrManageEvents.object(at: self.lastIndexSelected) as! NSDictionary
            }
            else
            {
                dicEvent = self.arrArtFundRaiser.object(at: self.lastIndexSelected) as! NSDictionary
            }
            
            let strEventID = String(describing: dicEvent.object(forKey: "id") as! NSNumber)
            
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(self.DeleteEvent(strEventId:)), with: strEventID)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    // MARK: - UICollection View Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        if strSelectedTab == "ManageEvent"
        {
            if(currentPageManage < totalPageManage)
            {
                return arrManageEvents.count + 1
            }
            else
            {
                return arrManageEvents.count
            }
        }
        else
        {
            if(currentPageArtFund < totalPageArtFund)
            {
                return arrArtFundRaiser.count + 1
            }
            else
            {
                return arrArtFundRaiser.count
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        
        if strSelectedTab == "ManageEvent"
        {
            if indexPath.row == arrManageEvents.count
            {
                return CGSize(width: (collectionView.frame.size.width), height: 44)
            }
        }
        else
        {
            if indexPath.row == arrArtFundRaiser.count
            {
                return CGSize(width: (collectionView.frame.size.width), height: 44)
            }
        }
        
        
        
        return CGSize(width: (collectionView.frame.size.width/2), height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if strSelectedTab == "ManageEvent"
        {
            if indexPath.row == arrManageEvents.count
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpinnerCollectionCell", for: indexPath) as! SpinnerCollectionCell
                
                cell.backgroundColor = UIColor.white
                
                spinner = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
                spinner.frame = CGRect(x: (collectionView.frame.size.width-20)/2, y: 12, width: 20, height: 20)
                cell.addSubview(spinner)
                spinner.startAnimating()
                return cell
                
            }
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyEventManageCell", for: indexPath as IndexPath) as! MyEventManageCell
            
            
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(btnEditArtwork(_:)), for: .touchUpInside)
            
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(btnDeleteArtwork(_:)), for: .touchUpInside)
            
            
            cell.btnBooking.tag = indexPath.row
            cell.btnBooking.addTarget(self, action: #selector(btnBookedArtwork(_:)), for: .touchUpInside)
            
            cell.btnCancelBooking.tag = indexPath.row
            cell.btnCancelBooking.addTarget(self, action: #selector(btnCancelEvent(_:)), for: .touchUpInside)
            
            let dicEvent = arrManageEvents.object(at: indexPath.row) as! NSDictionary
            
            cell.btnEdit.isHidden =  false
            cell.btnDelete.isHidden =  false
            
            if dicEvent.valueForNullableKey(key: "status") == "2"
            {
                
                cell.btnEdit.frame = CGRect(x: 8, y: 4, width: 30, height: 25)
                
                cell.btnDelete.frame = CGRect(x: cell.frame.size.width - 20 - 60, y: 4, width: 60, height: 25)
                
                cell.btnBooking.isHidden = true
                cell.btnCancelBooking.isHidden = true
            }
            else if dicEvent.valueForNullableKey(key: "status") == "3"
            {
                cell.btnBooking.frame = CGRect(x: 8, y: 4, width: 70, height: 25)

                
                cell.btnBooking.isHidden = false
                cell.btnCancelBooking.isHidden = true
                cell.btnEdit.isHidden =  true
                cell.btnDelete.isHidden =  true
            }
            else
            {
                
                cell.btnBooking.frame = CGRect(x: 8, y: 4, width: 70, height: 25)
                cell.btnCancelBooking.frame = CGRect(x: cell.frame.size.width - 20 - 60, y: 4, width: 60, height: 25)

                
                cell.btnEdit.frame = CGRect(x: cell.frame.size.width/2 - 15, y: 4, width: 30, height: 25)

                
                
                cell.btnBooking.isHidden = false
                cell.btnCancelBooking.isHidden = false
                cell.btnDelete.isHidden =  true
                
            }
            
            
            
            cell.imgEvent.layer.masksToBounds = true
            
            if dicEvent.object(forKey: "event_type") as! String == "Free"
            {
                cell.lblPrice.text = "Free"
            }
            else
            {
                let TempPrice = dicEvent.object(forKey: "price") as! Double
                cell.lblPrice.text = String(format: "$%.2f", TempPrice)
            }
            
            cell.lblEventTitle.text = dicEvent.object(forKey: "name") as? String
            cell.lblDescription.text = dicEvent.object(forKey: "description") as? String
            
            let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicEvent.object(forKey: "picture") as? String)!)
            let urlImage = URL.init(string: urlStr as String)
            
            
            cell.imgEvent.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))
            
            cell.lblAddress.text = dicEvent.object(forKey: "address") as? String
            
            let strStartDate = dicEvent.object(forKey: "event_start_date") as? String
            
            let DateStart = dateFormateServer.date(from: strStartDate!)
            
            if DateStart != nil
            {
                let strDate = dateFormate.string(from: DateStart!)
                let strTime = timeFormate.string(from: DateStart!)
                
                cell.lblDate.text = strDate
                cell.lblTime.text = strTime
                
            }
            
            
            return cell
        }
        else
        {
            
            if indexPath.row == arrArtFundRaiser.count
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpinnerCollectionCell", for: indexPath) as! SpinnerCollectionCell
                
                cell.backgroundColor = UIColor.white
                
                spinner = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
                spinner.frame = CGRect(x: (collectionView.frame.size.width-20)/2, y: 12, width: 20, height: 20)
                cell.addSubview(spinner)
                spinner.startAnimating()
                return cell
                
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyEventManageCell", for: indexPath as IndexPath) as! MyEventManageCell
            
            
            
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(btnEditArtwork(_:)), for: .touchUpInside)
            
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(btnDeleteArtwork(_:)), for: .touchUpInside)
            
            
            cell.btnBooking.tag = indexPath.row
            cell.btnBooking.addTarget(self, action: #selector(btnBookedArtwork(_:)), for: .touchUpInside)
            
            
            cell.btnCancelBooking.tag = indexPath.row
            cell.btnCancelBooking.addTarget(self, action: #selector(btnCancelEvent(_:)), for: .touchUpInside)
            
            let dicEvent = arrArtFundRaiser.object(at: indexPath.row) as! NSDictionary
            
            cell.imgEvent.layer.masksToBounds = true
            
            cell.btnEdit.isHidden =  false
            cell.btnDelete.isHidden =  false
            
            if dicEvent.valueForNullableKey(key: "status") == "2"
            {
                
                cell.btnEdit.frame = CGRect(x: 8, y: 4, width: 30, height: 25)
                
                cell.btnDelete.frame = CGRect(x: cell.frame.size.width - 20 - 60, y: 4, width: 60, height: 25)
                
                cell.btnBooking.isHidden = true
                cell.btnCancelBooking.isHidden = true
            }
            else if dicEvent.valueForNullableKey(key: "status") == "3"
            {
                cell.btnBooking.frame = CGRect(x: 8, y: 4, width: 70, height: 25)
                
                
                cell.btnBooking.isHidden = false
                cell.btnCancelBooking.isHidden = true
                cell.btnEdit.isHidden =  true
                cell.btnDelete.isHidden =  true
            }
            else
            {
                
                cell.btnBooking.frame = CGRect(x: 8, y: 4, width: 70, height: 25)
                cell.btnCancelBooking.frame = CGRect(x: cell.frame.size.width - 20 - 60, y: 4, width: 60, height: 25)
                
                
                cell.btnEdit.frame = CGRect(x: cell.frame.size.width/2 - 15, y: 4, width: 30, height: 25)
                
                
                
                cell.btnBooking.isHidden = false
                cell.btnCancelBooking.isHidden = false
                cell.btnDelete.isHidden =  true
                
            }
            
            
            if dicEvent.object(forKey: "event_type") as! String == "Free"
            {
                cell.lblPrice.text = "Free"
            }
            else
            {
                let TempPrice = dicEvent.object(forKey: "price") as! Double
                cell.lblPrice.text = String(format: "$%.2f", TempPrice)
            }
            
            cell.lblEventTitle.text = dicEvent.object(forKey: "name") as? String
            cell.lblDescription.text = dicEvent.object(forKey: "description") as? String
            
            let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicEvent.object(forKey: "picture") as? String)!)
            let urlImage = URL.init(string: urlStr as String)
            
            
            cell.imgEvent.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))
            
            cell.lblAddress.text = dicEvent.object(forKey: "address") as? String
            
            let strStartDate = dicEvent.object(forKey: "event_start_date") as? String
            
            let DateStart = dateFormateServer.date(from: strStartDate!)
            
            if DateStart != nil
            {
                let strDate = dateFormate.string(from: DateStart!)
                let strTime = timeFormate.string(from: DateStart!)
                
                cell.lblDate.text = strDate
                cell.lblTime.text = strTime
                
            }
            
            
            return cell
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
//        let dicArtwork = arrManageEvents.object(at: indexPath.row) as! NSDictionary
//        let strId = String(describing: dicArtwork.object(forKey: "id") as! NSNumber)
//        let strTitle = dicArtwork.object(forKey: "title") as! String
//        
//        let Art  = ArtistsGalleryDetailsVC(nibName:"ArtistsGalleryDetailsVC", bundle:nil)
//        
//        Art.strArtworkId = strId
//        Art.strArtworkTitle = strTitle
//        self.navigationController?.pushViewController(Art, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        
        if strSelectedTab == "ManageEvent"
        {
            if indexPath.row == arrManageEvents.count - 2
            {
                if currentPageManage != totalPageManage
                {
                    currentPageManage = currentPageManage + 1
                    
                    self.performSelector(inBackground: #selector(ManageEventList), with:nil)
                }
            }
        }
        else
        {
            if indexPath.row == arrArtFundRaiser.count - 2
            {
                if currentPageArtFund != totalPageArtFund
                {
                    currentPageArtFund = currentPageArtFund + 1
                    
                    self.performSelector(inBackground: #selector(FundraiserList), with:nil)
                }
            }
        }
        
        
    }

    
    //MARK: - Webservice Methods
    
    func ManageEventList()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        parameters.setValue(currentPageManage, forKey: "page")
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@event/my?page=%d&userid=%@", kSkeuomoMainURL,currentPageManage,strUserid)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            if DicResponseData.object(forKey: "event") != nil
                            {
                                if (DicResponseData.object(forKey: "event") as! NSDictionary).object(forKey: "data") != nil
                                {
                                    let tempArr = (DicResponseData.object(forKey: "event") as! NSDictionary).object(forKey: "data") as! NSArray
                                    
                                    let tempTotalPage = (DicResponseData.object(forKey: "event") as! NSDictionary).object(forKey:"last_page") as! Int
                                    
                                    let tempTotalRecord = (DicResponseData.object(forKey: "event") as! NSDictionary).object(forKey:"total") as! Int
                                    
                                    if self.arrManageEvents.count > 0 && self.currentPageManage == 1
                                    {
                                        self.arrManageEvents.removeAllObjects()
                                    }
                                    
                                    self.arrManageEvents.addObjects(from: tempArr as! [NSDictionary])
                                    
                                    self.totalPageManage = tempTotalPage
                                    self.totalPageRecordManage = tempTotalRecord
                                    
                                    self.collMyEvents.reloadData()
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
    
    
    func FundraiserList()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        parameters.setValue(currentPageArtFund, forKey: "page")
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@event/fundraiser?page=%d&userid=%@", kSkeuomoMainURL,currentPageArtFund,strUserid)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            
                            if DicResponseData.object(forKey: "event") != nil
                            {
                                if (DicResponseData.object(forKey: "event") as! NSDictionary).object(forKey: "data") != nil
                                {
                                    
                                    let tempArr = (DicResponseData.object(forKey: "event") as! NSDictionary).object(forKey: "data") as! NSArray
                                    
                                    
                                    let tempTotalPage = (DicResponseData.object(forKey: "event") as! NSDictionary).object(forKey:"last_page") as! Int
                                    
                                    let tempTotalRecord = (DicResponseData.object(forKey: "event") as! NSDictionary).object(forKey:"total") as! Int
                                    
                                    if self.arrArtFundRaiser.count > 0 && self.currentPageArtFund == 1
                                    {
                                        self.arrArtFundRaiser.removeAllObjects()
                                    }
                                    
                                    self.arrArtFundRaiser.addObjects(from: tempArr as! [NSDictionary])
                                    
                                    self.totalPageArtFund = tempTotalPage
                                    self.totalPageRecordArtFund = tempTotalRecord
                                    
                                    self.collMyEvents.reloadData()
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
    
    
    func DeleteEvent(strEventId : String)
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        // http://demo2server.in/sites/laravelapp/skeuomo/api/event/delete?userid=72&id=73
        
        parameters.setObject(strEventId, forKey: "id" as NSCopying)
        
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@event/delete?userid=%@&id=%@", kSkeuomoMainURL,strUserid,strEventId)
        
        print("API URL : %@",url)
        
        
        manager.get(url, parameters: parameters, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                           
                            if self.strSelectedTab == "ManageEvent"
                            {
                                self.arrManageEvents.removeObject(at: self.lastIndexSelected)

                            }
                            else
                            {
                                self.arrArtFundRaiser.removeObject(at: self.lastIndexSelected)

                            }
                            
                            self.collMyEvents.reloadData()
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

    func cancelEvent(strReason : String)
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        
        var dicEvent : NSDictionary!
        
        if self.strSelectedTab == "ManageEvent"
        {
            dicEvent = self.arrManageEvents.object(at: self.lastIndexSelected) as! NSDictionary
        }
        else
        {
            dicEvent = self.arrArtFundRaiser.object(at: self.lastIndexSelected) as! NSDictionary
        }
        
        let strEventID = String(describing: dicEvent.object(forKey: "id") as! NSNumber)
        
        parameters.setObject(strEventID, forKey: "id" as NSCopying)
        
        parameters.setObject(strReason, forKey: "name" as NSCopying)
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@event/cancel", kSkeuomoMainURL)
        manager.post(url as String, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            DispatchQueue.main.async
                {
                    HelpingMethods.sharedInstance.hideHUD()
                    
                    print((responseObject as! NSDictionary))
                    
                    if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                    {
                        var dicEvent : NSMutableDictionary!
                        
                        if self.strSelectedTab == "ManageEvent"
                        {
                            dicEvent = (self.arrManageEvents.object(at: self.lastIndexSelected) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        }
                        else
                        {
                            dicEvent = (self.arrArtFundRaiser.object(at: self.lastIndexSelected) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        }
                        
                        dicEvent.setValue(NSNumber.init(value: 3), forKey: "status")
                        
                        if self.strSelectedTab == "ManageEvent"
                        {
                            self.arrManageEvents.replaceObject(at: self.lastIndexSelected, with: dicEvent.mutableCopy() as! NSDictionary)
                        }
                        else
                        {
                            self.arrArtFundRaiser.replaceObject(at: self.lastIndexSelected, with: dicEvent.mutableCopy() as! NSDictionary)
                        }
                        
                        self.collMyEvents.reloadData()
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
