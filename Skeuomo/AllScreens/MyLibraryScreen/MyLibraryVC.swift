//
//  MyLibraryVC.swift
//  Skeuomo
//
//  Created by by Jannes on 24/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class MyLibraryVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet weak var collMyLibrary: UICollectionView!
    
    @IBOutlet weak var imgThemeBG: UIImageView!
    
    var arrMyArtwork = NSMutableArray()
    
    var lastIndexSelected = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        let nib = UINib(nibName: "MyLibraryCollCell", bundle: nil)
        collMyLibrary.register(nib,forCellWithReuseIdentifier: "MyLibraryCollCell")
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(MyLibaray), with: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateArtworkList(notification:)), name: NSNotification.Name(rawValue: "UPDATEMYARTWORKLIST"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func updateArtworkList(notification : NSNotification)
    {
        self.performSelector(inBackground: #selector(MyLibaray), with: nil)
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
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    //MARK: - ButtonsMethods
    
    @IBAction func btnEditArtwork(_ sender: UIButton)
    {
        let dicArtwork = arrMyArtwork.object(at: sender.tag) as! NSDictionary
        let PostArtVC = PostYourArtworkVC(nibName: "PostYourArtworkVC", bundle: nil)
        PostArtVC.dicArtworkDetail = dicArtwork
        self.navigationController?.pushViewController(PostArtVC, animated: true)
    }
    
    @IBAction func btnDeleteArtwork(_ sender: UIButton)
    {
        lastIndexSelected = sender.tag
        
        let actionSheet = UIAlertController(title: nil, message: "Are you sure want to delete this artwork", preferredStyle: UIAlertControllerStyle.alert)
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            
            let dicArt = self.arrMyArtwork.object(at: self.lastIndexSelected) as! NSDictionary
            let strArtworkID = String(describing: dicArt.object(forKey: "id") as! NSNumber)
            
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(self.DeleteArtwork(strArtworkID:)), with: strArtworkID)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
       _ = self.navigationController?.popViewController(animated: true)
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
        return CGSize(width: (collectionView.frame.size.width/2), height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyLibraryCollCell", for: indexPath as IndexPath) as! MyLibraryCollCell
        let dicArtwork = arrMyArtwork.object(at: indexPath.row) as! NSDictionary
        let TempPrice = dicArtwork.object(forKey: "price") as! Double
        cell.lblPrice.text = String(format: "$%.2f", TempPrice)
        cell.lblArtworkTitle.text = dicArtwork.object(forKey: "title") as? String
        
        let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicArtwork.object(forKey: "artworkImage") as? String)!)
        
        let urlImage = URL.init(string: urlStr as String)
        
        cell.imgArtwork.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))
        
        var isPrivate = 0
        
        if dicArtwork.object(forKey: "is_private") is String
        {
            if dicArtwork.object(forKey: "is_private") as! String == "0"
            {
                isPrivate = 0
            }
            else
            {
               isPrivate = 1
            }
        }
        else
        {
            isPrivate = dicArtwork.object(forKey: "is_private") as! Int
        }
        
        if isPrivate == 0
        {
            cell.btnPrivate.isSelected = true
        }
        else
        {
            cell.btnPrivate.isSelected = false
        }
        
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteArtwork(_:)), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.row
        
        cell.btnEdit.addTarget(self, action: #selector(btnEditArtwork(_:)), for: .touchUpInside)
        cell.btnEdit.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
    //MARK: - Webservice Methods
    
    func MyLibaray()
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
        
        let  url  = String(format: "%@artwork/my?userid=%@", kSkeuomoMainURL,strUserid)

        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            
                            if DicResponseData.object(forKey: "artwork") is NSArray
                            {
                                HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: "Record not found", controller: self)
                            }
                            else
                            {
                                let DicArtWork = DicResponseData.object(forKey: "artwork") as! NSDictionary
                                
                                if DicArtWork.allKeys.count > 0
                                {
                                    self.arrMyArtwork = (DicArtWork.object(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                                    
                                    self.collMyLibrary.reloadData()
                                }
                                else
                                {
                                    HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)

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
    
    func DeleteArtwork(strArtworkID : String)
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        // http://demo2server.in/sites/laravelapp/skeuomo/api/artwork/delete?id=1
        
        parameters.setObject(strArtworkID, forKey: "id" as NSCopying)
        
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@artwork/delete?id=%@", kSkeuomoMainURL,strArtworkID)
        
        print("API URL : %@",url)

        
        manager.get(url, parameters: parameters, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            self.arrMyArtwork.removeObject(at: self.lastIndexSelected)
                            
                            self.collMyLibrary.reloadData()
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
