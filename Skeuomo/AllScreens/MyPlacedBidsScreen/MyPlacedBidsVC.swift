//
//  MyPlacedBidsVC.swift
//  Skeuomo
//
//  Created by by Jannes on 24/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class MyPlacedBidsVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource
{

    @IBOutlet weak var collMyPlaced: UICollectionView!
    
    @IBOutlet weak var imgThemeBG: UIImageView!
    
    var currentPage = 1
    var totalPage = 0
    var totalPageRecord = 0
    
    var arrArtwork = NSMutableArray()
    var spinner : UIActivityIndicatorView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        let nib = UINib(nibName: "MyPlacedBidCell", bundle: nil)
        collMyPlaced.register(nib,forCellWithReuseIdentifier: "MyPlacedBidCell")
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(getMyPlacedBid), with: nil)
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
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
    // MARK: - ButtonsMethods
    @IBAction func btnSideMenu(_ sender: UIButton)
    {
       _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSearching(_ sender: UIButton)
    {
    }
    @IBAction func btnNotification(_ sender: UIButton)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    // MARK: - UICollection View Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(currentPage < totalPage)
        {
            return arrArtwork.count + 1
        }
        else
        {
            return arrArtwork.count
        }    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        if indexPath.row == arrArtwork.count
        {
            return CGSize(width: (collectionView.frame.size.width), height: 44)
        }

        
        return CGSize(width: (collectionView.frame.size.width/2), height: 215)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if indexPath.row == arrArtwork.count
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpinnerCollectionCell", for: indexPath) as! SpinnerCollectionCell
            
            cell.backgroundColor = UIColor.white
            
            spinner = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
            spinner.frame = CGRect(x: (collectionView.frame.size.width-20)/2, y: 12, width: 20, height: 20)
            
            cell.addSubview(spinner)
            
            
            spinner.startAnimating()
            
            return cell
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPlacedBidCell", for: indexPath as IndexPath) as! MyPlacedBidCell
        
        cell.lblHighestBidder.isHidden = true
        
        let DicAuction = arrArtwork.object(at: indexPath.item) as! NSDictionary
        
        cell.lblArtworkTitle.text = (DicAuction.object(forKey: "bid_auction") as? NSDictionary)?.object(forKey: "title") as? String
        
        cell.lblBidPrice.text = String.init(format: "$%@", DicAuction.valueForNullableKey(key: "price"))
        
        let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,((DicAuction.object(forKey: "bid_auction") as? NSDictionary)?.object(forKey: "auctionImage") as? String)!)
        
        let urlImage = URL.init(string: urlStr as String)
        
        cell.imgArtwork.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))
        
        cell.lblEndDate.text = String(format: "Bid End : %@", ((DicAuction.object(forKey: "bid_auction") as? NSDictionary)?.object(forKey: "endBid") as? String)!)
        
        
        if DicAuction.object(forKey: "bidStatus") != nil
        {
            let strStatus = DicAuction.object(forKey: "bidStatus") as! String
            
            if strStatus.characters.count > 0
            {
                cell.lblHighestBidder.isHidden = false
                cell.lblHighestBidder.text = strStatus
                
                if strStatus == "highest"
                {
                    cell.lblHighestBidder.backgroundColor = UIColor.init(red: 16.0/255.0, green: 134.0/255.0, blue: 254.0/255.0, alpha: 1.0)
                }
                else  if strStatus == "winner"
                {
                    cell.lblHighestBidder.backgroundColor = UIColor.init(red: 21.0/255.0, green: 177.0/255.0, blue: 75.0/255.0, alpha: 1.0)
                }
                else
                {
                    cell.lblHighestBidder.backgroundColor = UIColor.init(red: 206.0/255.0, green: 51.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                }
                
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    }
    
    
    //MARK: - Web Service Method
    
    func getMyPlacedBid()
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
        
        let  url  = String(format: "%@bid/my?userid=%@?page=%d", kSkeuomoMainURL,strUserid,currentPage)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            
                            if DicResponseData.object(forKey: "bid") != nil
                            {
                                if (DicResponseData.object(forKey: "bid") as! NSDictionary).object(forKey: "data") != nil
                                {
                                    
                                    let tempArr = (DicResponseData.object(forKey: "bid") as! NSDictionary).object(forKey: "data") as! NSArray
                                    
                                    
                                    let tempTotalPage = (DicResponseData.object(forKey: "bid") as! NSDictionary).object(forKey:"last_page") as! Int
                                    
                                    let tempTotalRecord = (DicResponseData.object(forKey: "bid") as! NSDictionary).object(forKey:"total") as! Int
                                    
                                    if self.arrArtwork.count > 0 && self.currentPage == 1
                                    {
                                        self.arrArtwork.removeAllObjects()
                                    }
                                    
                                    self.arrArtwork.addObjects(from: tempArr as! [NSDictionary])
                                    
                                    self.totalPage = tempTotalPage
                                    self.totalPageRecord = tempTotalRecord
                                    
                                    self.collMyPlaced.reloadData()
                                    
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

