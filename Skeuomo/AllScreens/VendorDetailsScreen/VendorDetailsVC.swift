//
//  VendorDetailsVC.swift
//  Skeuomo
//
//  Created by by Jannes on 22/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class VendorDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{

    @IBOutlet weak var tblVendorDetails: UITableView!
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var btnArtToCart: UIButton!
    
    var dicShopArtDetails = NSDictionary()
    
    var strShopArtID = ""

    var arrShippingDetail = NSMutableArray()
    
    @IBOutlet var viewSelectQuantity: UIView!
    
    @IBOutlet weak var viewTxtQuntityBG: UIView!
    
    @IBOutlet weak var txtQuantity: MDTextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetShopArtDetail), with: nil)
        
        
        viewTxtQuntityBG.layer.masksToBounds = true
        viewTxtQuntityBG.layer.cornerRadius = 2.0
        viewTxtQuntityBG.layer.borderWidth = 1.0
        viewTxtQuntityBG.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIButtons Method
    
    @IBAction func btnViewCommentClicked(sender:UIButton)
    {
        let reviewVC  = ReviewAndCommentListScreen(nibName : "ReviewAndCommentListScreen", bundle: nil)
        
        reviewVC.strModule = "shopart"
        reviewVC.strID = strShopArtID
        
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }
    
    @IBAction func btnSubmitClicked(sender:UIButton)
    {
        let reviewVC  = SubmitReviewRatingScreen(nibName : "SubmitReviewRatingScreen", bundle: nil)
        
        reviewVC.strModule = "shopart"
        reviewVC.strID = strShopArtID
        
        self.present(reviewVC, animated: true, completion: nil)
    }
    
    @IBAction func btnAddToCartClicked(_ sender: AnyObject)
    {
        self.view.addSubview(viewSelectQuantity)
        viewSelectQuantity.frame = self.view.frame
    }
    
    @IBAction func btnCloseQuantityPopup(_ sender: AnyObject)
    {
        viewSelectQuantity.removeFromSuperview()
    }
    
    @IBAction func btnDoneQuantity(_ sender: AnyObject)
    {
        if (txtQuantity.text?.characters.count)! > 0
        {
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(AddToCart), with: nil)
        }
        else
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle:
                "Please enter Quantity", controller: self)

        }
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
       _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSearching(_ sender: UIButton)
    {
        
    }
    @IBAction func btnNotifications(_ sender: UIButton)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    
    //MARK: - UITableViewDataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if dicShopArtDetails.allKeys.count > 0
        {
            return 9 + arrShippingDetail.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 250
        }
        else if indexPath.row == 1
        {
            return 120
        }
        else  if indexPath.row == 2
        {
            return 130
        }
        else if indexPath.row == 3
        {
            return 40
        }
        else if indexPath.row == arrShippingDetail.count + 4
        {
            return 77
        }
        else if indexPath.row == arrShippingDetail.count + 5
        {
            let strDes =  dicShopArtDetails.object(forKey: "description") as? String
            
            let font = UIFont.init(name: "Gibson-Regular", size: 12)
            
            
            let height = self.Method_HeightCalculation(text: strDes!, font: font!, width: tableView.frame.size.width - 28)
            
            
            if height > 20
            {
                return 40 + 8 + height + 10
            }
            
            return 45
        }
        else if indexPath.row == arrShippingDetail.count + 6
        {
            return 65

        }
        else if indexPath.row == arrShippingDetail.count + 7 || indexPath.row == arrShippingDetail.count + 8
        {
            return 60
        }
        else
        {
            
            print(indexPath.row)
            
            let strDes =  arrShippingDetail.object(at: indexPath.row - 4) as! String
            
            let font = UIFont.init(name: "Gibson-Regular", size: 12)
            
            
            let height = self.Method_HeightCalculation(text: strDes, font: font!, width: tableView.frame.size.width - 28)
            
            
            if height > 20
            {
                return 8 + 8 + height + 10
            }
            
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cellIdentifier:String = "ColorImgTblCell"
            var cell:ColorImgTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ColorImgTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ColorImgTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ColorImgTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicShopArtDetails.object(forKey: "shopartImage") as? String)!)
            
            let urlImage = URL.init(string: urlStr as String)
            
            cell?.imgCollCell.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))

            
            return cell!
            
        }
        else  if indexPath.row == 1
        {
            let cellIdentifier:String = "WallnutPaintsTblCell"
            var cell:WallnutPaintsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WallnutPaintsTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("WallnutPaintsTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? WallnutPaintsTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            
            cell?.imgTblCell.layer.masksToBounds = true
            cell?.imgTblCell.layer.cornerRadius = (cell?.imgTblCell.frame.size.width)! / 2
            
            cell?.lblPaintsType.text = dicShopArtDetails.object(forKey: "title") as? String
            
            let strUserImage = (dicShopArtDetails.object(forKey: "user") as! NSDictionary).object(forKey: "profile_picture") as! String
            
            let urlStrUser = NSString(format: "%@%@",kSkeuomoImageURL,strUserImage)
            
            let urlImageUser = URL.init(string: urlStrUser as String)
            
            cell?.imgTblCell.setImageWith(urlImageUser!, placeholderImage: UIImage.init(named:"user_place"))
            
            let strUsername = String(format: "%@ %@", (dicShopArtDetails.object(forKey: "user") as! NSDictionary).object(forKey: "firstName") as! String,(dicShopArtDetails.object(forKey: "user") as! NSDictionary).object(forKey: "lastName") as! String)
            
            cell?.lblUserName.text = String(format: "%@", strUsername)
            
            
            let arrAddress = NSMutableArray()
            
            if (dicShopArtDetails.object(forKey: "user") as! NSDictionary).object(forKey: "city") != nil {
                
                arrAddress.add(((dicShopArtDetails.object(forKey: "user") as! NSDictionary).object(forKey: "city") as? String)!)

            }
            
            if (dicShopArtDetails.object(forKey: "user") as! NSDictionary).object(forKey: "state") != nil {
                
                arrAddress.add(((dicShopArtDetails.object(forKey: "user") as! NSDictionary).object(forKey: "state") as? String)!)

            }
            
            
            if (dicShopArtDetails.object(forKey: "user") as! NSDictionary).object(forKey: "country") != nil  && ((dicShopArtDetails.object(forKey: "user") as! NSDictionary).object(forKey: "country") as! NSDictionary).object(forKey: "name") != nil
            {
                
                arrAddress.add((((dicShopArtDetails.object(forKey: "user") as! NSDictionary).object(forKey: "country") as! NSDictionary).object(forKey: "name")  as? String)!)
                
            }
            
            
            
            cell?.lblAddress.text = arrAddress.componentsJoined(by: ", ") 
            
           
            let TempPrice = dicShopArtDetails.object(forKey: "price") as! Double
            cell?.lblPrice.text = String(format: "$%.2f EA", TempPrice)
            
            return cell!

            
            
            
        }
        else  if indexPath.row == 2
        {
            let cellIdentifier:String = "VendorDetailOverviewCell"
            var cell:VendorDetailOverviewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? VendorDetailOverviewCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("VendorDetailOverviewCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? VendorDetailOverviewCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            
            cell?.lblMaterial.text = String(format: "Material: %@", dicShopArtDetails.object(forKey: "materials") as! String)
            
            
            return cell!
        }
           
            
        else  if indexPath.row == 3
        {
            let cellIdentifier:String = "VendorShippingDetailStaticCell"
            var cell:VendorShippingDetailStaticCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? VendorShippingDetailStaticCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("VendorShippingDetailStaticCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? VendorShippingDetailStaticCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            return cell!
        }
            
        else  if indexPath.row == arrShippingDetail.count + 4
        {
            let cellIdentifier:String = "VendorDetailRetuneAndSupportCell"
            var cell:VendorDetailRetuneAndSupportCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? VendorDetailRetuneAndSupportCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("VendorDetailRetuneAndSupportCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? VendorDetailRetuneAndSupportCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            return cell!
        }
        else if indexPath.row == arrShippingDetail.count + 5
        {
            let cellIdentifier:String = "DecriptionTblCell"
            var cell:DecriptionTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DecriptionTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("DecriptionTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? DecriptionTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            
            cell?.lblDescription.text = dicShopArtDetails.object(forKey: "description") as? String

            
            cell?.lblTitle.text = "PRODUCT DESCRIPTION"
            
            return cell!

        }
            
        else  if indexPath.row == arrShippingDetail.count + 6
        {
            let cellIdentifier:String = "VendorRatingCell"
            var cell:VendorRatingCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? VendorRatingCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("VendorRatingCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? VendorRatingCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            return cell!
        }
            
        else if indexPath.row == arrShippingDetail.count + 8
        {
            
            let cellIdentifier:String = "CreateCommentAndRatingCell"
            var cell:CreateCommentAndRatingCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CreateCommentAndRatingCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("CreateCommentAndRatingCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? CreateCommentAndRatingCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            
            cell?.btnSubmitReview.addTarget(self, action: #selector(btnSubmitClicked(sender:)), for: .touchUpInside)
            
            cell?.btnViewComments.addTarget(self, action: #selector(btnViewCommentClicked(sender:)), for: .touchUpInside)
            
            
            
            return cell!
            
        }
            
        else if indexPath.row == arrShippingDetail.count + 7
        {
            
            let cellIdentifier:String = "VendorShareCell"
            var cell:VendorShareCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? VendorShareCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("VendorShareCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? VendorShareCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            return cell!

          }
        else
        {
            
            let cellIdentifier:String = "VendorShippingDetailCell"
            var cell:VendorShippingDetailCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? VendorShippingDetailCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("VendorShippingDetailCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? VendorShippingDetailCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //For Incrase Separator Size
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
             let strDes =  arrShippingDetail.object(at: indexPath.row - 4) as! String
            
            cell?.lblShippingText.text = strDes
            
            return cell!
            
        }

    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " "
        {
            return false
        }
        else if string == "0" && textField.text!.characters.count == 0 {
            
            return false
        }
        
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        
        let components = string.components(separatedBy: inverseSet)
        
        let filtered = components.joined(separator: "")
        
        
        
        if string != filtered
        {
            return false
        }
        
        
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        
        return newLength > 10 ? false : true
        
    }
    
    

    
    //MARK: - Web Service Method
    
    func GetShopArtDetail()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setValue(strUserid, forKey: "userid")
        parameters.setValue(strShopArtID, forKey: "id")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted
            { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending
        }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        
        let token = appDelegate.MD5(strforMD5 as String)
        
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        //http://demo2server.in/sites/laravelapp/skeuomo/api/shopart/details?userid=72&id=3
        
        let  url  = String(format: "%@shopart/details?userid=%@&id=%@", kSkeuomoMainURL,strUserid,strShopArtID)
        
        print("URL :",url)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            self.dicShopArtDetails = DicResponseData.object(forKey: "shoparts") as! NSDictionary
                            
                            
                            
                            let strShippingDetail = self.dicShopArtDetails.object(forKey: "shipping") as! String
                            
                            var array:NSArray?
                            
                            if let data = strShippingDetail.data(using: String.Encoding.utf8) {
                                
                                do {
                                    array = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray
                                    
                                    if array != nil && (array?.count)! > 0
                                    {
                                        self.arrShippingDetail.addObjects(from: array as! [String])
                                    }
                                    
                                } catch let error as NSError {
                                    print(error)
                                    
                                }
                                
                            }
                            
                            
                            print("Arr Shipping Details:",self.arrShippingDetail)
                            
                            let userIdEvent = (self.dicShopArtDetails.object(forKey: "user") as! NSDictionary).valueForNullableKey(key: "id")
                            
                            let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
                            
                            if userIdEvent == strUserid as String
                            {
                                self.btnArtToCart.isHidden =  true
                                
                                self.tblVendorDetails.frame = CGRect(x: 18, y: 78, width: UIScreen.main.bounds.size.width - 36, height: UIScreen.main.bounds.size.height - 78 - 10)
                            }
                            
                            self.tblVendorDetails.reloadData()
                            
                            
                            
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
    
    
    func AddToCart()
    {
        
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        manager.requestSerializer.timeoutInterval = 500
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        parameters.setObject(strShopArtID, forKey: "id" as NSCopying)
        parameters.setObject(txtQuantity.text!, forKey: "qty" as NSCopying)
        
        print("sending data : \(parameters)")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        
        print(strforMD5)
        
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let url = String(format: "%@addtocart", kSkeuomoMainURL)
        
        print("URL:",url)
        
        manager.post(url as String, parameters: parameters, constructingBodyWith:{ (fromData)in/*fromData : AFMultipartFormData) in*/
            
            },progress:nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            print("Everything is ok now")

                            self.viewSelectQuantity.removeFromSuperview()
                            
                            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
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
                    
                    //  MBProgressHUD.hide(for: self.appDelegate.window!, animated: true)
            }
        }
    }
}
