//
//  MyAuctionViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 22/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class MyAuctionViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var CollectionShowData: UICollectionView!
    @IBOutlet weak var imgThemeBG: UIImageView!
    var arrMyArtwork = NSMutableArray()
    let  formater = DateFormatter()
    
    var lastIndexSelected = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        let nib = UINib(nibName: "MyAuctionColleCell", bundle: nil)
        CollectionShowData.register(nib,forCellWithReuseIdentifier: "MyAuctionColleCell")
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(MyAuctions), with: nil)
        
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAuctionList(notification:)), name: NSNotification.Name(rawValue: "UPDATEMYAUCTIONLIST"), object: nil)

        

    }
    
    func updateAuctionList(notification : NSNotification)
    {
        self.performSelector(inBackground: #selector(MyAuctions), with: nil)
        
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
    
       // MARK: - ButtonsMethod
    
    @IBAction func btnEditAuction(_ sender: UIButton)
    {
        let dicAuction = arrMyArtwork.object(at: sender.tag) as! NSDictionary
        let auctionVC = AucationArtWorkScreen(nibName: "AucationArtWorkScreen", bundle: nil)
        auctionVC.dicAuctionDetail = dicAuction
        self.navigationController?.pushViewController(auctionVC, animated: true)
    }
    
    @IBAction func btnDeleteAuction(_ sender: UIButton)
    {
        lastIndexSelected = sender.tag
        
        let actionSheet = UIAlertController(title: nil, message: "Are you sure want to delete this auction", preferredStyle: UIAlertControllerStyle.alert)
        
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            
            let dicArt = self.arrMyArtwork.object(at: self.lastIndexSelected) as! NSDictionary
            let strArtworkID = String(describing: dicArt.object(forKey: "id") as! NSNumber)
            
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(self.DeleteAuction(strAuctionID:)), with: strArtworkID)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSeeTotalBid(_ sender: UIButton)
    {
        let dicArtwork = arrMyArtwork.object(at: sender.tag) as! NSDictionary
        let strTempAuctionID = String(describing: dicArtwork.object(forKey: "id") as! NSNumber)
        
        let MyAuct = MyAuctionDetailsVC(nibName:"MyAuctionDetailsVC",bundle:nil)
        MyAuct.strAuctionID = strTempAuctionID
        self.navigationController?.pushViewController(MyAuct, animated: true)
    }
    
    // MARK: - UICollection View Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrMyArtwork.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (collectionView.frame.size.width/2), height: 258)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyAuctionColleCell", for: indexPath as IndexPath) as! MyAuctionColleCell
        
        let dicArtwork = arrMyArtwork.object(at: indexPath.row) as! NSDictionary
        
        cell.lblArtworkTitle.text = dicArtwork.object(forKey: "title") as? String
        
        let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicArtwork.object(forKey: "auctionImage") as? String)!)
    
        let urlImage = URL.init(string: urlStr as String)
    
        cell.imgArtwork.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))

        cell.lblArtworkTitle.tag = indexPath.row + 1000
        
        cell.dateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handlePlaydAudioTimer(_:)), userInfo: NSNumber.init(value: indexPath.row), repeats: true)
        
        let TempPrice = dicArtwork.object(forKey: "price") as! Int
        
        cell.lblStartingPrice.text = String(format: "$%d", TempPrice)
        
        if dicArtwork.object(forKey: "highest") != nil
        {
            let TempHighestBid = dicArtwork.object(forKey: "highest") as! NSNumber
            cell.lblHighestPrice.text = String(format: "$%.1f", TempHighestBid)
        }
        
        if dicArtwork.object(forKey: "totalBid") != nil
        {
            cell.btnTotalBid.setTitle(String(dicArtwork.object(forKey: "totalBid") as! Int), for: .normal)
        }
        
        cell.btnTotalBid.addTarget(self, action: #selector(btnSeeTotalBid(_:)), for: .touchUpInside)
        cell.btnTotalBid.tag = indexPath.item
        
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteAuction(_:)), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.row
        
        cell.btnEdit.addTarget(self, action: #selector(btnEditAuction(_:)), for: .touchUpInside)
        cell.btnEdit.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }

    
    func handlePlaydAudioTimer(_ sender: Timer)
    {
        let x = sender.userInfo as! Int
        let indexPath = NSIndexPath.init(item: x, section: 0)
        var isVisble = false
        
        for cell in CollectionShowData.visibleCells
        {
            let cellAuction = cell as! MyAuctionColleCell
            let indexPathNew = CollectionShowData.indexPath(for: cellAuction)
            if indexPath as IndexPath ==  indexPathNew!
            {
                isVisble = true
            }
        }
        
        if isVisble == false
        {
            return
        }
        
        let cell = CollectionShowData.cellForItem(at: indexPath as IndexPath) as! MyAuctionColleCell
        
        let dicArtwork = arrMyArtwork.object(at: indexPath.row) as! NSDictionary
        
        let endBid = dicArtwork.object(forKey: "endBid") as! String
        
        let dateEndBid = formater.date(from: endBid)
        
        if dateEndBid! > Date()
        {
            let currentDate = NSDate()
            let diff = NSCalendar.current.dateComponents([.day, .hour, .minute, .second], from: currentDate as Date, to: dateEndBid!)
            
            let strDay = String(describing: diff.day!)
            let strHour = String(describing: diff.hour!)
            let strMin = String(describing: diff.minute!)
            let strSec = String(describing: diff.second!)
            
            cell.lblDays.text = strDay
            cell.lblHour.text = strHour
            cell.lblMin.text = strMin
            cell.lblSec.text = strSec
        }
    }
    

    //MARK: - Webservice Methods
    
    func MyAuctions()
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
        
        let url = String(format: "%@auction/my?userid=%@", kSkeuomoMainURL,strUserid)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            if DicResponseData.object(forKey: "auction") is NSArray
                            {
                                HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: "Record not found", controller: self)
                            }
                            else
                            {
                                let DicArtWork = DicResponseData.object(forKey: "auction") as! NSDictionary
                                
                                if DicArtWork.allKeys.count > 0
                                {
                                    self.arrMyArtwork = (DicArtWork.object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                                    self.CollectionShowData.reloadData()
                                }
                                else
                                {
                                    HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                                }
                            }

//                            let DicArtWork = DicResponseData.object(forKey: "auction") as! NSDictionary
//                            
//                            if DicArtWork.allKeys.count > 0
//                            {
//                                self.arrMyArtwork = (DicArtWork.object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
//                                
//                                self.CollectionShowData.reloadData()
//                            }
//                            else
//                            {
//                                HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
//                            }
 
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
    
    func DeleteAuction(strAuctionID : String)
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        // http://demo2server.in/sites/laravelapp/skeuomo/api/auction/delete?id=1
        
        parameters.setObject(strAuctionID, forKey: "id" as NSCopying)
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url = String(format: "%@auction/delete?id=%@", kSkeuomoMainURL,strAuctionID)
        
        print("API URL : %@", url)
        
        manager.get(url, parameters: parameters, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            self.arrMyArtwork.removeObject(at: self.lastIndexSelected)
                            
                            self.CollectionShowData.reloadData()
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
