//
//  VendorViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 22/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class VendorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource
{

    @IBOutlet weak var collectionVendorData: UICollectionView!
    
    @IBOutlet weak var lblShortType: UILabel!

    
    var currentPage = 1
    var totalPage = 0
    var totalPageRecord = 0
    
    var arrShopArt = NSMutableArray()
    var spinner : UIActivityIndicatorView!
    
    var lastIndexSelected = 0
    
    var selectedIndexPicker = 0

    @IBOutlet weak var pickerDataSet: UIPickerView!
    @IBOutlet var viewPickerview: UIView!
    
    var strShortingType = "Featured"
    
    var arrShort : NSArray = ["Featured","Recent","Popular"]

    
    var arrBrand =  NSArray()
    var arrType =   NSArray()
    var arrVendor = NSArray()

    var strBrand = ""
    var strType = ""
    var strVendorId = ""

    var MinPrice = 0
    var MaxPrice = 0
    
    var selectedMin = 0
    var selectedMax = 0

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        
        lblShortType.text = strShortingType

        
        let nib = UINib(nibName: "VendorCollectionCell", bundle: nil)
        collectionVendorData.register(nib,forCellWithReuseIdentifier: "VendorCollectionCell")
        
        let nib1 = UINib(nibName: "SpinnerCollectionCell", bundle: nil)
        collectionVendorData.register(nib1,forCellWithReuseIdentifier: "SpinnerCollectionCell")
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetMyShopArt), with: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ApplyFilter(notification:)), name: NSNotification.Name(rawValue: "ApplyFilter"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RemoveFilter(notification:)), name: NSNotification.Name(rawValue: "RemoveFilter"), object: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    func ApplyFilter(notification : NSNotification) {
        
        let obj = notification.object as! NSDictionary
        
        
        print(obj)
        
        currentPage = 1

        strType = obj.valueForNullableKey(key: "type")
        strBrand = obj.valueForNullableKey(key: "brand")
        strVendorId = obj.valueForNullableKey(key: "vandor")

        MinPrice = obj.object(forKey: "minprice") as! Int
        MaxPrice = obj.object(forKey: "maxprice") as! Int

        
        selectedMin = obj.object(forKey: "selectedminprice") as! Int
        selectedMax = obj.object(forKey: "selectedmaxprice") as! Int
        
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetMyShopArt), with: nil)
        
    }
    
    func RemoveFilter(notification : NSNotification)
    {
         currentPage = 1
        
         strBrand = ""
         strType = ""
         strVendorId = ""
        
        MinPrice = 0
        MaxPrice = 0
        
        selectedMin = 0
        selectedMax = 0
        
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetMyShopArt), with: nil)
        
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - ButtonsMethod 
    
    
    @IBAction func btnCancelPickerView(_ sender: AnyObject)
    {
        viewPickerview.removeFromSuperview()
    }
    
    @IBAction func btnDonePickerView(_ sender: AnyObject)
    {
        viewPickerview.removeFromSuperview()
        
        strShortingType =  arrShort.object(at: selectedIndexPicker) as! String
        
        lblShortType.text = strShortingType
        
        currentPage = 1
        
        strBrand = ""
        strType = ""
        strVendorId = ""
        
        MinPrice = 0
        MaxPrice = 0
        
        selectedMin = 0
        selectedMax = 0
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetMyShopArt), with: nil)
    }
    
    @IBAction func btnSideMenu(_ sender: Any)
    {
       _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnFilter(_ sender: Any)
    {
        let Filtr  = FilterViewController(nibName:"FilterViewController", bundle:nil)
        
        Filtr.arrVendor = arrVendor
        Filtr.arrType = arrType
        Filtr.arrBrand = arrBrand
        
        Filtr.strType = strType
        Filtr.strBrand = strBrand
        Filtr.strVendorId = strVendorId
        
        
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

    @IBAction func btnSortby(_ sender: Any)
    {
        reloadPicker()
        self.view.addSubview(viewPickerview)
        viewPickerview.frame = self.view.frame
    }
    @IBAction func btnSearching(_ sender: UIButton)
    {
    }
    @IBAction func btnNotifications(_ sender: UIButton)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    
    
    @IBAction func btnAddToCartClicked(_ sender: UIButton)
    {
        let dicArtwork = arrShopArt.object(at: sender.tag) as! NSDictionary
        let strId = String(describing: dicArtwork.object(forKey: "id") as! NSNumber)
        let Vend  = VendorDetailsVC(nibName:"VendorDetailsVC", bundle:nil)
        
        Vend.strShopArtID = strId
        
        _ = self.navigationController?.pushViewController(Vend, animated: true)
    }
    @IBAction func btnBuyClicked(_ sender: UIButton)
    {
        let dicArtwork = arrShopArt.object(at: sender.tag) as! NSDictionary
        let strId = String(describing: dicArtwork.object(forKey: "id") as! NSNumber)
        let Vend  = VendorDetailsVC(nibName:"VendorDetailsVC", bundle:nil)
        
        Vend.strShopArtID = strId
        
        _ = self.navigationController?.pushViewController(Vend, animated: true)
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
        
        return CGSize(width: (collectionView.frame.size.width/2), height: 245)
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
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VendorCollectionCell", for: indexPath as IndexPath) as! VendorCollectionCell
        
        let dicShopArt = arrShopArt.object(at: indexPath.row) as! NSDictionary
        
        cell.imgCollCell.layer.masksToBounds = true
        
        
        let TempPrice = dicShopArt.object(forKey: "price") as! Double
        cell.lblPrice.text = String(format: "$%.2f EA", TempPrice)
        
        cell.lblShopArtTitle.text = dicShopArt.object(forKey: "title") as? String
        
        
        let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicShopArt.object(forKey: "shopartImage") as? String)!)
        let urlImage = URL.init(string: urlStr as String)
        
        
        cell.imgCollCell.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))
        
        
        let strUsername = String(format: "%@ %@", (dicShopArt.object(forKey: "user") as! NSDictionary).object(forKey: "firstName") as! String,(dicShopArt.object(forKey: "user") as! NSDictionary).object(forKey: "lastName") as! String)
        
        cell.lblUsername.text = String(format: "%@", strUsername)
        
        
        cell.btnAddToCart.tag = indexPath.row
        
        cell.btnAddToCart.addTarget(self, action: #selector(btnAddToCartClicked(_:)), for: .touchUpInside)
        
        
        cell.btnBuy.tag = indexPath.row
        
        cell.btnBuy.addTarget(self, action: #selector(btnBuyClicked(_:)), for: .touchUpInside)
        
        return cell
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let dicArtwork = arrShopArt.object(at: indexPath.row) as! NSDictionary
        let strId = String(describing: dicArtwork.object(forKey: "id") as! NSNumber)
        let Vend  = VendorDetailsVC(nibName:"VendorDetailsVC", bundle:nil)
        
        Vend.strShopArtID = strId
        
       _ = self.navigationController?.pushViewController(Vend, animated: true)
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
        
        parameters.setValue(strShortingType.lowercased(), forKey: "id")
        parameters.setValue(strType, forKey: "type")
        parameters.setValue(strBrand, forKey: "brand")
        parameters.setValue(strVendorId, forKey: "vendor")
        
        var strMinPrice = ""
        var strMaxPrice = ""
        
        if selectedMin != 0 && selectedMax != 0 {
            
            strMinPrice = String(selectedMin)
            strMaxPrice = String(selectedMax)

        }

        
        
        
        parameters.setValue(strMinPrice, forKey: "minPrice")
        parameters.setValue(strMaxPrice, forKey: "maxPrice")
        
        

        
        // http://192.168.0.8/skeuomo/arts/popular?type=canvases&brand=Bianyo&vendor=42&minPrice=1&maxPrice=50000

        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        //http://demo2server.in/sites/laravelapp/skeuomo/api/shopart/artFrontList?id=featured&page=1&userid=97
        
        
        let  url  = String(format: "%@shopart/artFrontList?id=%@&page=%d&userid=%@&type=%@&brand=%@&vendor=%@&minPrice=%@&maxPrice=%@", kSkeuomoMainURL,strShortingType.lowercased(),currentPage,strUserid,strType,strBrand,strVendorId,strMinPrice,strMaxPrice).addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) as NSString!
        
        print("URL:",url)
        print("Prams:",parameters)

        
        manager.get(url! as String, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            self.arrBrand = DicResponseData.object(forKey: "brands") as! NSArray
                            self.arrType = DicResponseData.object(forKey: "types") as! NSArray
                            self.arrVendor = DicResponseData.object(forKey: "vendors") as! NSArray
                            
                            if DicResponseData.object(forKey: "shoparts") != nil
                            {
                                
                                if DicResponseData.object(forKey: "shoparts") is NSArray
                                {
                                    self.arrShopArt.removeAllObjects()
                                    self.collectionVendorData.reloadData()
                                    return
                                }
                                
                                if (DicResponseData.object(forKey: "shoparts") as! NSDictionary).object(forKey: "data") != nil
                                {
                                    let tempArr = (DicResponseData.object(forKey: "shoparts") as! NSDictionary).object(forKey: "data") as! NSArray
                                    
                                    let tempTotalPage = (DicResponseData.object(forKey: "shoparts") as! NSDictionary).object(forKey:"last_page") as! Int
                                    
                                    let tempTotalRecord = (DicResponseData.object(forKey: "shoparts") as! NSDictionary).object(forKey:"total") as! Int
                                    
                                    if self.arrShopArt.count > 0 && self.currentPage == 1
                                    {
                                        self.arrShopArt.removeAllObjects()
                                    }
                                    
                                    self.arrShopArt.addObjects(from: tempArr as! [NSDictionary])
                                    
                                    self.totalPage = tempTotalPage
                                    self.totalPageRecord = tempTotalRecord
                                    
                                    self.collectionVendorData.reloadData()
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
