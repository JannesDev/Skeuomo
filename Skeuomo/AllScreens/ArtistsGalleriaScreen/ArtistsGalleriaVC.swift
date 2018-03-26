//
//  ArtistsGalleriaVC.swift
//  Skeuomo
//
//  Created by by Jannes on 25/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class ArtistsGalleriaVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource
{

    @IBOutlet weak var collArtistGalleria: UICollectionView!
    @IBOutlet weak var btnBackSide: UIButton!
    
    var fromSideMenu = ""
    var currentPage = 1
    var totalPage = 0
    var totalPageRecord = 0
    
    var arrArtwork = NSMutableArray()
    var spinner : UIActivityIndicatorView!
    
    var strShortingType = "A-Z"
    var arrShort : NSArray = ["A-Z","Z-A","Low to High","High to Low"]
    
    var selectedIndexPicker = 0
    
    var arrGenres =  NSArray()
    var arrSubject =   NSArray()
    var arrMedium = NSArray()
    var arrMood = NSArray()
    
    
    var strGenres = ""
    var strSubject = ""
    var strMedium = ""
    var strMood = ""

    var MinPrice = 0
    var MaxPrice = 0
    
    var selectedMin = 0
    var selectedMax = 0
    
    
    
    @IBOutlet weak var lblShortType: UILabel!

    
    @IBOutlet weak var pickerDataSet: UIPickerView!
    @IBOutlet var viewPickerview: UIView!
    
    
    var lastSelectedIndex = 0
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lblShortType.text = strShortingType
        
        self.automaticallyAdjustsScrollViewInsets = false
        let nib = UINib(nibName: "ArtistsGalleriaTblCell", bundle: nil)
        collArtistGalleria.register(nib,forCellWithReuseIdentifier: "ArtistsGalleriaTblCell")
        
        let nib1 = UINib(nibName: "SpinnerCollectionCell", bundle: nil)
        collArtistGalleria.register(nib1,forCellWithReuseIdentifier: "SpinnerCollectionCell")
        // Do any additional setup after loading the view.
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetArtworkList), with: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ApplyFilter(notification:)), name: NSNotification.Name(rawValue: "ApplyFilterArtwork"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RemoveFilter(notification:)), name: NSNotification.Name(rawValue: "RemoveFilterArtwork"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateFavorite(notification:)), name: NSNotification.Name(rawValue: "ReloadFavoriteArtwork"), object: nil)

        
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
    
    
    func ApplyFilter(notification : NSNotification) {
        
        let obj = notification.object as! NSDictionary
        
        print(obj)
        
        currentPage = 1
        
        strGenres = obj.valueForNullableKey(key: "genre")
        strSubject = obj.valueForNullableKey(key: "subject")
        strMedium = obj.valueForNullableKey(key: "medium")
        strMood = obj.valueForNullableKey(key: "mood")

        
        MinPrice = obj.object(forKey: "minprice") as! Int
        MaxPrice = obj.object(forKey: "maxprice") as! Int
        
        
        selectedMin = obj.object(forKey: "selectedminprice") as! Int
        selectedMax = obj.object(forKey: "selectedmaxprice") as! Int
        
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetArtworkList), with: nil)
        
    }
    
    func RemoveFilter(notification : NSNotification)
    {
        currentPage = 1
        
        strGenres = ""
        strSubject = ""
        strMedium = ""
        strMood = ""
        
        MinPrice = 0
        MaxPrice = 0
        
        selectedMin = 0
        selectedMax = 0
        
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetArtworkList), with: nil)
        
    }
    
    
    func UpdateFavorite(notification : NSNotification)
    {
        if notification.object is Int
        {
            let dicArtwork = (arrArtwork.object(at: lastSelectedIndex) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            dicArtwork.setValue(NSNumber.init(value: notification.object as! Int), forKey: "is_favourite")
            
            arrArtwork.replaceObject(at: lastSelectedIndex, with: dicArtwork.mutableCopy() as! NSDictionary)
            
            collArtistGalleria.reloadData()
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Buttons
    
    @IBAction func btnSortby(_ sender: Any)
    {
        reloadPicker()
        self.view.addSubview(viewPickerview)
        viewPickerview.frame = self.view.frame
    }
    
    @IBAction func btnCancelPickerView(_ sender: AnyObject)
    {
        viewPickerview.removeFromSuperview()
    }
    
    @IBAction func btnLikeClicked(_ sender: UIButton)
    {
        let dicArtwork = (arrArtwork.object(at: sender.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        let dicSend = NSMutableDictionary()
        
        dicSend.setValue(dicArtwork.valueForNullableKey(key: "id"), forKey: "id")
        dicSend.setValue("artwork", forKey: "module_name")

        
        if dicArtwork.valueForNullableKey(key: "is_favourite") == "1"
        {
            dicArtwork.setValue(NSNumber.init(value: 0), forKey: "is_favourite")
        }
        else
        {
            dicArtwork.setValue(NSNumber.init(value: 1), forKey: "is_favourite")
        }
        
        arrArtwork.replaceObject(at: sender.tag, with: dicArtwork.mutableCopy() as! NSDictionary)
        
        
        self.performSelector(inBackground: #selector(AddFavorite(dataSend:)), with: dicSend)

        
        collArtistGalleria.reloadData()
        
        
    }
    
    @IBAction func btnDonePickerView(_ sender: AnyObject)
    {
        viewPickerview.removeFromSuperview()
        
        strShortingType =  arrShort.object(at: selectedIndexPicker) as! String
        
        lblShortType.text = strShortingType
        
        currentPage = 1
        
        strGenres = ""
        strMedium = ""
        strSubject = ""
        strMood = ""

        MinPrice = 0
        MaxPrice = 0
        
        selectedMin = 0
        selectedMax = 0
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetArtworkList), with: nil)
    }
    
    @IBAction func btnFilter(_ sender: Any)
    {
        let Filtr  = ArtistsGalleriaFliterScreen(nibName:"ArtistsGalleriaFliterScreen", bundle:nil)
        
        Filtr.arrGenres = arrGenres
        Filtr.arrSubject = arrSubject
        Filtr.arrMedium = arrMedium
        Filtr.arrMood = arrMood

        
        Filtr.strGenres = strGenres
        Filtr.strSubject = strSubject
        Filtr.strMedium = strMedium
        Filtr.strMood = strMood

        
        print("Max",MaxPrice)
        print("Min",MinPrice)
        
        print("Selected Max",selectedMax)
        print("Selected Min",selectedMin)
        
        if MinPrice == 0 && MaxPrice == 0
        {
            
            Filtr.MaxPrice = 50000
            Filtr.MinPrice = 1
            
            Filtr.selectedMaxPrice = 50000
            Filtr.selectedMinPrice = 1
            
        }
        else
        {
            Filtr.MaxPrice = MaxPrice
            Filtr.MinPrice = MinPrice
            
            Filtr.selectedMaxPrice = selectedMax
            Filtr.selectedMinPrice = selectedMin
        }
        
        
        self.navigationController?.pushViewController(Filtr, animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }

    @IBAction func btnSideMenu(_ sender: Any)
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
        
        return CGSize(width: (collectionView.frame.size.width/2), height: 255)
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistsGalleriaTblCell", for: indexPath as IndexPath) as! ArtistsGalleriaTblCell
        
        let dicArtwork = arrArtwork.object(at: indexPath.row) as! NSDictionary
        
        cell.imgUser.layer.masksToBounds = true
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.height / 2
        
        let TempPrice = dicArtwork.object(forKey: "price") as! Double
        cell.lblPrice.text = String(format: "$%.2f", TempPrice)
        
        cell.lblArtworkTitle.text = dicArtwork.object(forKey: "title") as? String
        
        let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicArtwork.object(forKey: "thumbnail") as? String)!)
        
        let urlImage = URL.init(string: urlStr as String)
        
        
        cell.imgArtwork.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))
        
        let strUserImage = (dicArtwork.object(forKey: "user") as! NSDictionary).object(forKey: "profile_picture") as! String
        
        let urlStrUser = NSString(format: "%@%@",kSkeuomoImageURL,strUserImage)
        
        let urlImageUser = URL.init(string: urlStrUser as String)
        
        cell.imgUser.setImageWith(urlImageUser!, placeholderImage: UIImage.init(named:"user_place"))
        
        let strUsername = String(format: "%@ %@", (dicArtwork.object(forKey: "user") as! NSDictionary).object(forKey: "firstName") as! String, (dicArtwork.object(forKey: "user") as! NSDictionary).object(forKey: "lastName") as! String)
        
        cell.lblUsername.text = String(format: "By %@", strUsername)
        
        cell.lblLocation.text = (dicArtwork.object(forKey: "user") as! NSDictionary).object(forKey: "city") as? String
        
        
        if dicArtwork.valueForNullableKey(key: "is_favourite") == "1"
        {
            cell.btnLike.isSelected = true
        }
        else
        {
            cell.btnLike.isSelected = false
        }
        
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(btnLikeClicked(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        lastSelectedIndex = indexPath.row
        
        let dicArtwork = arrArtwork.object(at: indexPath.row) as! NSDictionary
        let strId = String(describing: dicArtwork.object(forKey: "id") as! NSNumber)
        let strTitle = dicArtwork.object(forKey: "title") as! String
        
        let Art  = ArtistsGalleryDetailsVC(nibName:"ArtistsGalleryDetailsVC", bundle:nil)
        
        Art.strArtworkId = strId
        Art.strArtworkTitle = strTitle
        self.navigationController?.pushViewController(Art, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == arrArtwork.count - 2
        {
            if currentPage != totalPage
            {
                currentPage = currentPage + 1
                
                self.performSelector(inBackground: #selector(GetArtworkList), with:nil)
            }
        }
        
    }
    
    
    //MARK: - PikcerView DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return arrShort.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return arrShort.object(at: row) as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedIndexPicker = row
    }
    
    func reloadPicker()
    {
        selectedIndexPicker = 0
        pickerDataSet.reloadAllComponents()
        pickerDataSet.selectRow(selectedIndexPicker, inComponent: 0, animated: true)
    }
    
    
    //MARK: - Web Service Method
    
    func GetArtworkList()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        parameters.setValue(currentPage, forKey: "page")

        var strOrderFilter = ""

        
        if strShortingType == "A-Z"
        {
            strOrderFilter = "asc"
        }
        else if strShortingType == "Z-A"
        {
            strOrderFilter = "desc"

        }
        else if strShortingType == "Low to High"
        {
            strOrderFilter = "low"

        }
        else if strShortingType == "High to Low"
        {
            strOrderFilter = "high"

        }
        
        parameters.setValue(strOrderFilter, forKey: "orderFilter")

        
        parameters.setValue(strGenres, forKey: "genre")
        parameters.setValue(strSubject, forKey: "subject")
        parameters.setValue(strMedium, forKey: "medium")
        parameters.setValue(strMood, forKey: "mood")

        var strMinPrice = ""
        var strMaxPrice = ""
        
        if selectedMin != 0 && selectedMax != 0 {
            
            strMinPrice = String(selectedMin)
            strMaxPrice = String(selectedMax)
            
        }
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)

        parameters.setValue(strMinPrice, forKey: "minPrice")
        parameters.setValue(strMaxPrice, forKey: "maxPrice")
        
        print("Parms Artwor",parameters)
        
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        
         let  url  = String(format: "%@home/artwork?orderFilter=%@&page=%d&userid=%@&genre=%@&subject=%@&medium=%@&mood=%@&minPrice=%@&maxPrice=%@", kSkeuomoMainURL,strOrderFilter,currentPage,strUserid,strGenres,strSubject,strMedium,strMood,strMinPrice,strMaxPrice).addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) as NSString!
        
  
        
        manager.get(url as! String, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            
                           let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            self.arrGenres = DicResponseData.object(forKey: "genres") as! NSArray
                            self.arrSubject = DicResponseData.object(forKey: "subjects") as! NSArray
                            self.arrMedium = DicResponseData.object(forKey: "mediums") as! NSArray
                            self.arrMood = DicResponseData.object(forKey: "moods") as! NSArray

                            
                            if DicResponseData.object(forKey: "artwork") != nil &&  DicResponseData.object(forKey: "artwork") is NSDictionary  && (DicResponseData.object(forKey: "artwork") as! NSDictionary).allKeys.count > 0
                            {
                                if (DicResponseData.object(forKey: "artwork") as! NSDictionary).object(forKey: "data") != nil
                                {
                                
                                    let tempArr = (DicResponseData.object(forKey: "artwork") as! NSDictionary).object(forKey: "data") as! NSArray
                                    
                                    
                                    let tempTotalPage = (DicResponseData.object(forKey: "artwork") as! NSDictionary).object(forKey:"last_page") as! Int
                                    
                                    let tempTotalRecord = (DicResponseData.object(forKey: "artwork") as! NSDictionary).object(forKey:"total") as! Int
                                    
                                    if self.arrArtwork.count > 0 && self.currentPage == 1
                                    {
                                        self.arrArtwork.removeAllObjects()
                                    }
                                    
                                    self.arrArtwork.addObjects(from: tempArr as! [NSDictionary])
                                    
                                    self.totalPage = tempTotalPage
                                    self.totalPageRecord = tempTotalRecord
                                    
                                    self.collArtistGalleria.reloadData()

                                }
                            }
                            else
                            {
                                
                                self.arrArtwork.removeAllObjects()
                                self.collArtistGalleria.reloadData()

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
    
    func AddFavorite(dataSend : NSMutableDictionary)
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
        
        parameters.setObject(dataSend.valueForNullableKey(key: "module_name"), forKey: "module_name" as NSCopying)
        
        parameters.setObject(dataSend.valueForNullableKey(key: "id"), forKey: "id" as NSCopying)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@makeFavourite", kSkeuomoMainURL)
        manager.post(url as String, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            DispatchQueue.main.async
                {
                    HelpingMethods.sharedInstance.hideHUD()
                    
                    print((responseObject as! NSDictionary))
                    
                    if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                    {
                      //  HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
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
