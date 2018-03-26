//
//  ChooseThemeScreen.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 24/10/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking
import SDWebImage

class ChooseThemeScreen: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource {

    @IBOutlet weak var collThemes: UICollectionView!
    @IBOutlet weak var imgThemeBG: UIImageView!

    var arrThemes = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let nib = UINib(nibName: "ChooseThemeCollCell", bundle: nil)
        collThemes.register(nib,forCellWithReuseIdentifier: "ChooseThemeCollCell")
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetThemes), with: nil)
        
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
                
                 self.imgThemeBG.setImageWith(urlImage!, placeholderImage: UIImage.init(named:""))
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
    
    @IBAction func btnBack(_ sender: UIButton)
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
        return arrThemes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (collectionView.frame.size.width/2), height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseThemeCollCell", for: indexPath as IndexPath) as! ChooseThemeCollCell
        
        let dicTheme = arrThemes.object(at: indexPath.row) as! NSDictionary
        
        let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicTheme.object(forKey: "themePic") as? String)!)
        
        let urlImage = URL.init(string: urlStr as String)
        
        cell.imgTheme.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))

        cell.lblTheme.text = dicTheme.object(forKey: "themeName") as? String
        
        cell.viewBG.layer.masksToBounds = true
        cell.viewBG.layer.borderWidth = 1.0
        cell.viewBG.layer.borderColor = UIColor(colorLiteralRed: 16.0/255.0, green: 134.0/255.0, blue: 254.0/255.0, alpha: 1.0).cgColor
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let dicTheme = arrThemes.object(at: indexPath.row) as! NSDictionary

        let strId = String(describing: dicTheme.object(forKey: "id") as! NSNumber)
        
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(SetTheme(strId:)), with: strId)
        
    }
    
    //MARK: - Webservice Methods
    
    func GetThemes()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@getThemes?", kSkeuomoMainURL)
        
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            
                            
                                 self.arrThemes = DicResponseData.object(forKey: "all_themes") as! NSArray
                            
                                self.collThemes.reloadData()
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

    
    func SetTheme(strId : String)
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
        
        parameters.setObject(strId, forKey: "theme_id" as NSCopying)

        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@setTheme?userid=%@&theme_id=%@", kSkeuomoMainURL,strUserid,strId)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            
                            
                            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                            
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            
                            
                            
                            
                            
                            if DicResponseData.object(forKey: "selectedTheme") != nil &&  (DicResponseData.object(forKey: "selectedTheme") as! NSDictionary).allKeys.count > 0
                            {
                                
                                if UserDefaults.standard.object(forKey: "Theme") != nil
                                {
                                    let dicTheme = UserDefaults.standard.object(forKey: "Theme") as! NSDictionary
                                    
                                    let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicTheme.object(forKey: "themePic") as? String)!)
                                    
                                    SDImageCache.shared().removeImage(forKey: urlStr as String, fromDisk: true, withCompletion: {
                                        
                                        print("removed")
                                        
                                    })

                                }
                                
                                
                                
                                
                                UserDefaults.standard.set( DicResponseData.object(forKey: "selectedTheme") as! NSDictionary, forKey: "Theme")
                            }
                            
                            print(UserDefaults.standard.object(forKey: "Theme"))
                            
                            
                            if UserDefaults.standard.object(forKey: "Theme") != nil
                            {
                                
                                let dicTheme = UserDefaults.standard.object(forKey: "Theme") as! NSDictionary
                                
                                if dicTheme.allKeys.count > 0
                                {
                                    let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicTheme.object(forKey: "themePic") as? String)!)
                                    
                                    let urlImage = URL.init(string: urlStr as String)
                                    
                                    self.imgThemeBG.setImageWith(urlImage!, placeholderImage: UIImage.init(named:""))
                                    
                                    
                                    
                                    
                                }
                                else
                                {
                                    self.imgThemeBG.image = UIImage.init(named: "")
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
