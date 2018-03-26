//
//  MyShopArtScreen.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 26/12/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class MyShopArtScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    @IBOutlet weak var collMyShopArt: UICollectionView!
    @IBOutlet weak var imgThemeBG: UIImageView!
    
    var currentPage = 1
    var totalPage = 0
    var totalPageRecord = 0
    
    var arrShopArt = NSMutableArray()
    var spinner : UIActivityIndicatorView!
    
    var lastIndexSelected = 0
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        let nib = UINib(nibName: "MyShopArtCollCell", bundle: nil)
        collMyShopArt.register(nib,forCellWithReuseIdentifier: "MyShopArtCollCell")
        
        
        let nib1 = UINib(nibName: "SpinnerCollectionCell", bundle: nil)
        collMyShopArt.register(nib1,forCellWithReuseIdentifier: "SpinnerCollectionCell")
        
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetMyShopArt), with: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMyShopList(noti:)), name: NSNotification.Name(rawValue: "UpdateMyShopArtList"), object: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func updateMyShopList(noti : NSNotification)
    {
        if noti.object != nil && (noti.object as! NSDictionary).allKeys.count > 0 {
            
            arrShopArt.replaceObject(at: lastIndexSelected, with: noti.object as! NSDictionary)
            
            collMyShopArt.reloadData()
            
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
    
    // MARK: - UIButton Events
    
    @IBAction func btnBack(_ sender: AnyObject)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnEditArtwork(_ sender: UIButton)
    {
       lastIndexSelected = sender.tag
        
       let dicShopArt = arrShopArt.object(at: sender.tag) as! NSDictionary
       
       let PostShopArtVC = UploadShopArtScreen(nibName: "UploadShopArtScreen", bundle: nil)

       PostShopArtVC.dicShopArtDetail = dicShopArt
        
       self.navigationController?.pushViewController(PostShopArtVC, animated: true)
    }
    
    @IBAction func btnDeleteArtwork(_ sender: UIButton)
    {
        lastIndexSelected = sender.tag
        
        let actionSheet = UIAlertController(title: nil, message: "Are you sure want to delete this Shop Art", preferredStyle: UIAlertControllerStyle.alert)
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
           
            let dicEvent = self.arrShopArt.object(at: self.lastIndexSelected) as! NSDictionary
            
            let strShopArtID = String(describing: dicEvent.object(forKey: "id") as! NSNumber)
            
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(self.DeleteShopArt(strShopArtId:)), with: strShopArtID)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    //MARK: - UICollection View Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
            if(currentPage < totalPage)
            {
                return arrShopArt.count + 1
            }
            else
            {
                return arrShopArt.count
            }
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        
        
            if indexPath.row == arrShopArt.count
            {
                return CGSize(width: (collectionView.frame.size.width), height: 44)
            }
        
        return CGSize(width: (collectionView.frame.size.width/2), height: 195)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
            if indexPath.row == arrShopArt.count
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpinnerCollectionCell", for: indexPath) as! SpinnerCollectionCell
                
                cell.backgroundColor = UIColor.white
                
                spinner = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
                spinner.frame = CGRect(x: (collectionView.frame.size.width-20)/2, y: 12, width: 20, height: 20)
                cell.addSubview(spinner)
                spinner.startAnimating()
                return cell
                
            }
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyShopArtCollCell", for: indexPath as IndexPath) as! MyShopArtCollCell
            
            
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(btnEditArtwork(_:)), for: .touchUpInside)
            
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(btnDeleteArtwork(_:)), for: .touchUpInside)
            
            let dicEvent = arrShopArt.object(at: indexPath.row) as! NSDictionary
            
            cell.imgEvent.layer.masksToBounds = true
            
        
        let TempPrice = dicEvent.object(forKey: "price") as! Double
        cell.lblPrice.text = String(format: "$%.2f EA", TempPrice)
        
            cell.lblShopArtTitle.text = dicEvent.object(forKey: "title") as? String
        
            
            let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicEvent.object(forKey: "shopartImage") as? String)!)
        
            let urlImage = URL.init(string: urlStr as String)
            
            
            cell.imgEvent.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))
            
        
        
            
            return cell
        
        
        
        
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
        
        
            if indexPath.row == arrShopArt.count - 2
            {
                if currentPage != totalPage
                {
                    currentPage = currentPage + 1
                    
                    self.performSelector(inBackground: #selector(GetMyShopArt), with:nil)
                }
            }
    }
    
    
    //MARK: - Webservice Methods
    
    func GetMyShopArt()
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
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        //http://demo2server.in/sites/laravelapp/skeuomo/api/shopart/my?page=1&userid=72
        
        
        let  url  = String(format: "%@shopart/my?page=%d&userid=%@", kSkeuomoMainURL,currentPage,strUserid)
        
        print("URL:",url)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            if DicResponseData.object(forKey: "shopart") != nil
                            {
                                
                                if DicResponseData.object(forKey: "shopart") is NSArray
                                {
                                    return
                                }
                                
                                if (DicResponseData.object(forKey: "shopart") as! NSDictionary).object(forKey: "data") != nil
                                {
                                    let tempArr = (DicResponseData.object(forKey: "shopart") as! NSDictionary).object(forKey: "data") as! NSArray
                                    
                                    let tempTotalPage = (DicResponseData.object(forKey: "shopart") as! NSDictionary).object(forKey:"last_page") as! Int
                                    
                                    let tempTotalRecord = (DicResponseData.object(forKey: "shopart") as! NSDictionary).object(forKey:"total") as! Int
                                    
                                    if self.arrShopArt.count > 0 && self.currentPage == 1
                                    {
                                        self.arrShopArt.removeAllObjects()
                                    }
                                    
                                    self.arrShopArt.addObjects(from: tempArr as! [NSDictionary])
                                    
                                    self.totalPage = tempTotalPage
                                    self.totalPageRecord = tempTotalRecord
                                    
                                    self.collMyShopArt.reloadData()
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
    
    func DeleteShopArt(strShopArtId : String)
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        // http://demo2server.in/sites/laravelapp/skeuomo/api/shopart/delete?id=1&userid=72
        
        parameters.setObject(strShopArtId, forKey: "id" as NSCopying)
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@shopart/delete?id=%@&userid=%@", kSkeuomoMainURL,strShopArtId,strUserid)
        
        print("API URL : %@",url)
        
        
        manager.get(url, parameters: parameters, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            
                            
                                self.arrShopArt.removeObject(at: self.lastIndexSelected)
                                
                            
                            
                            self.collMyShopArt.reloadData()
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
