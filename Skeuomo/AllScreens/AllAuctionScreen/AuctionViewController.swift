//
//  AuctionViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class AuctionViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionDataShow: UICollectionView!
    var fromSideMenu = ""
    @IBOutlet weak var btnBackSide: UIButton!
    
    var currentPage = 1
    var totalPage = 0
    var totalPageRecord = 0
    
    var arrArtwork = NSMutableArray()
    var spinner : UIActivityIndicatorView!
    
    let  formater = DateFormatter()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        let nib = UINib(nibName: "AutionCollectionCell", bundle: nil)
        collectionDataShow.register(nib,forCellWithReuseIdentifier: "AutionCollectionCell")
        
        let nib1 = UINib(nibName: "SpinnerCollectionCell", bundle: nil)
        collectionDataShow.register(nib1,forCellWithReuseIdentifier: "SpinnerCollectionCell")
        
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetAuctionArtwork), with: nil)
        
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"


    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
        
        if fromSideMenu == "FromSideMenu"
        {
            self.btnBackSide.setImage(UIImage.init(named: "back.png"), for: .normal)
        }
        else
        {
            self.btnBackSide.setImage(UIImage.init(named: "menu'.png"), for: .normal)
        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIButton Methods
    
    @IBAction func btnBack(_ sender: Any)
    {
        if fromSideMenu == "FromSideMenu"
        {
           _ = self.navigationController?.popViewController(animated: true)
        }
        else
        {
            self.appDelegate.sideMenuController.openMenu()
        }
    }
    @IBAction func btnNotification(_ sender: Any)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    @IBAction func btnSearching(_ sender: Any)
    {
        
    }
    @IBAction func btnSortBy(_ sender: Any)
    {
        
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
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        if indexPath.row == arrArtwork.count
        {
            return CGSize(width: (collectionView.frame.size.width), height: 44)
        }
        
        return CGSize(width: (collectionView.frame.size.width/2), height: 245)
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AutionCollectionCell", for: indexPath as IndexPath) as! AutionCollectionCell
        
        let dicArtwork = arrArtwork.object(at: indexPath.row) as! NSDictionary
        
        cell.lblArtworkTitle.text = dicArtwork.object(forKey: "title") as? String
        
        let TempPrice = dicArtwork.object(forKey: "price") as! Double
        
        cell.lblPrice.text = String(format: "$%.2f", TempPrice)
        
        let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicArtwork.object(forKey: "auctionImage") as? String)!)
        
        let urlImage = URL.init(string: urlStr as String)
        
        cell.imgArtwork.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))
        
        cell.lblArtworkTitle.tag = indexPath.row + 1000
        
        let strUsername = String(format: "%@ %@", (dicArtwork.object(forKey: "user") as! NSDictionary).object(forKey: "firstName") as! String, (dicArtwork.object(forKey: "user") as! NSDictionary).object(forKey: "lastName") as! String)
        
        cell.lblUserName.text = String(format: "By %@", strUsername)
        
        cell.lblUserAddress.text = (dicArtwork.object(forKey: "user") as! NSDictionary).object(forKey: "city") as? String
        
        cell.dateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handlePlaydAudioTimer(_:)), userInfo: NSNumber.init(value: indexPath.item), repeats: true)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == arrArtwork.count - 2
        {
            if currentPage != totalPage
            {
                currentPage = currentPage + 1
                
                self.performSelector(inBackground: #selector(GetAuctionArtwork), with:nil)
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.row != arrArtwork.count {
            
            let dicArtwork = arrArtwork.object(at: indexPath.row) as! NSDictionary
            let strId = String(describing: dicArtwork.object(forKey: "id") as! NSNumber)
            let strTitle = dicArtwork.object(forKey: "title") as! String
            
            let Art  = AuctionDetailsVC(nibName:"AuctionDetailsVC", bundle:nil)
            Art.strArtworkId = strId
            Art.strArtworkTitle = strTitle
            self.navigationController?.pushViewController(Art, animated: true)
        }
        
        
    }
    
    func handlePlaydAudioTimer(_ sender: Timer)
    {
        let x = sender.userInfo as! Int
        
        let indexPath = NSIndexPath.init(item: x, section: 0)
        
        var isVisble = false
        
        
        for cell in collectionDataShow.visibleCells {
            
            
            if cell is AutionCollectionCell
            {
                let cellAuction = cell as! AutionCollectionCell
                
                let indexPathNew = collectionDataShow.indexPath(for: cellAuction)
                
                
                if indexPath as IndexPath ==  indexPathNew! {
                    
                    isVisble = true
                }
            }
            
            
            
            
        }
        
        if isVisble == false {
            
            return
        }
        
        let cell = collectionDataShow.cellForItem(at: indexPath as IndexPath) as! AutionCollectionCell
        
        let dicArtwork = arrArtwork.object(at: indexPath.row) as! NSDictionary
        
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
            
            cell.lblTimeDate.text = String(format: "%@:%@:%@", strHour,strMin,strSec)
            
        }
    }
    
    //MARK: - Web Service Method
    
    func GetAuctionArtwork()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        parameters.setValue(currentPage, forKey: "page")
        
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@home/auction?page=%d", kSkeuomoMainURL,currentPage)
        
        
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
                                if (DicResponseData.object(forKey: "auction") as! NSDictionary).object(forKey: "data") != nil
                                {
                                    
                                    let tempArr = (DicResponseData.object(forKey: "auction") as! NSDictionary).object(forKey: "data") as! NSArray
                                    
                                    
                                    let tempTotalPage = (DicResponseData.object(forKey: "auction") as! NSDictionary).object(forKey:"last_page") as! Int
                                    
                                    let tempTotalRecord = (DicResponseData.object(forKey: "auction") as! NSDictionary).object(forKey:"total") as! Int
                                    
                                    if self.arrArtwork.count > 0 && self.currentPage == 1
                                    {
                                        self.arrArtwork.removeAllObjects()
                                    }
                                    
                                    self.arrArtwork.addObjects(from: tempArr as! [NSDictionary])
                                    
                                    self.totalPage = tempTotalPage
                                    self.totalPageRecord = tempTotalRecord
                                    
                                    self.collectionDataShow.reloadData()
                                    
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
