//
//  CartViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 21/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class CartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate
{

    
    @IBOutlet var tool: UIToolbar!
    @IBOutlet weak var tblCartData: UITableView!
    
    @IBOutlet weak var imgThemeBG: UIImageView!

    var arrMyCart = NSMutableArray()

    var selectedIndexToDelete = 0
    
    
    var strCouponCode = ""
    
    var dicCoupon = NSDictionary()
    
    var arrUpdatedQty = NSMutableArray()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetMyCart), with: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
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

    // MARK: - Buttons Methods
    
    @IBAction func btnApplyCouponClicked(_ sender: AnyObject)
    {
        self.view.endEditing(true)
        
        
        if dicCoupon.allKeys.count > 0 {
            
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(RemoveCoupon), with: nil)
        }
        else
        {
            if strCouponCode.characters.count > 0
            {
                HelpingMethods.sharedInstance.ShowHUD()
                self.performSelector(inBackground: #selector(ApplyCoupon), with: nil)
            }
            else
            {
                HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: "Please enter coupon code" , controller: self)
            }
        }
        
    }
    
    @IBAction func btnContinueShoppingClicked(_ sender: AnyObject)
    {
        
    }
    
    @IBAction func btnUpdateClicked(_ sender: AnyObject)
    {
        
        self.view.endEditing(true)
        
        if arrUpdatedQty.count > 0
        {
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(UpdateCart), with: nil)
        }
    }
    
    
    @IBAction func btnRemoveFromCartClick(_ sender: UIButton)
    {
        selectedIndexToDelete = sender.tag
        
        let actionSheet = UIAlertController(title: nil, message: "Are you sure want to remove this item form cart", preferredStyle: UIAlertControllerStyle.alert)
        
        actionSheet.addAction(UIAlertAction(title: "Remove", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            
            let dicCart = self.arrMyCart.object(at: sender.tag) as! NSDictionary
            let strId = dicCart.valueForNullableKey(key: "id")
            
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(self.RemoveFormCart(ItemCartId:)), with: strId)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func btnDoneKeyboardClick(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
    }
    
    
    @IBAction func btnBack(_ sender: Any)
    {
       appDelegate.sideMenuController.openMenu()
    }
    @IBAction func btnCheckOut(_ sender: Any) {
    }
    @IBAction func btnNotif(_ sender: Any)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    @IBAction func btnSearch(_ sender: Any) {
    }

    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        if section == 0
        {
            return arrMyCart.count
        }
        else
        {
            if arrMyCart.count > 0
            {
                return 1
            }
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 130
        }
        else
        {
            return 237
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cellIdentifier:String = "CartSelectTblCell"
            var cell:CartSelectTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CartSelectTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("CartSelectTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? CartSelectTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            cell?.btnRemoveFromCart.tag = indexPath.row
            cell?.btnRemoveFromCart.addTarget(self, action: #selector(btnRemoveFromCartClick(_:)), for: .touchUpInside)
            
            let dicCartObj = arrMyCart.object(at: indexPath.row) as! NSDictionary
            
            cell?.lblShopArtName.text = dicCartObj.object(forKey: "art_name") as? String
            
            
            let dicUser = dicCartObj.object(forKey: "user") as! NSDictionary
            
            
            cell?.lblUsername.text = String(format: "%@ %@", dicUser.valueForNullableKey(key: "firstName"),dicUser.valueForNullableKey(key: "lastName"))

            cell?.lblUnitPrice.text = String(format: "$%@", dicCartObj.valueForNullableKey(key: "unit_price"))
            
            cell?.txtQty.layer.masksToBounds =  true
            cell?.txtQty.layer.cornerRadius =  2.0
            cell?.txtQty.layer.borderColor = UIColor.lightGray.cgColor
            cell?.txtQty.layer.borderWidth = 1.0
            
            cell?.txtQty.delegate = self
            cell?.txtQty.tag = indexPath.row
            cell?.txtQty.inputAccessoryView = tool
            
            
            let strArtShopId = dicCartObj.valueForNullableKey(key: "shopart_id")
            
            var isExistInAnswer = false
            
            let aryCartGroup: NSArray = arrUpdatedQty.mutableCopy() as! NSArray
            
            aryCartGroup.enumerateObjects({(object, idx, stop) -> Void in
                
                let cart: NSMutableDictionary = object as! NSMutableDictionary
                
                if cart["artshop_id"] as! String == strArtShopId
                {
                    cell?.txtQty.text = cart.valueForNullableKey(key: "qty")
                    isExistInAnswer = true
                }
            })
            
            if isExistInAnswer == false
            {
                cell?.txtQty.text = dicCartObj.valueForNullableKey(key: "quantity")
            }
            
            
            cell?.lblTotalPrice.text = String(format: "$%@", dicCartObj.valueForNullableKey(key: "grand_total"))
            
            let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,((dicCartObj.object(forKey: "shopart") as? NSDictionary)?.valueForNullableKey(key: "thumbnail"))!)
            
            let urlImage = URL.init(string: urlStr as String)
            
            
            cell?.imgShopArt.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))
            
            return cell!
        }
        else
        {
            let cellIdentifier:String = "CartShowAmountsTblCell"
            var cell:CartShowAmountsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CartShowAmountsTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("CartShowAmountsTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? CartShowAmountsTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            let strSubtotal = self.getSubTotalAmount()
            
            cell?.lblSubTotalAmount.text = String(format: "$%@", strSubtotal)
            
            
            let dicAmount = self.getGrandTotal() 
            
            
            cell?.lblDiscountAmount.text = String(format: "$%@", dicAmount.valueForNullableKey(key: "discountamount"))
            
            cell?.lblGrandTotal.text = String(format: "$%@", dicAmount.valueForNullableKey(key: "grandamount"))

            cell?.txtCouponCode.tag = 1111
            cell?.txtCouponCode.inputAccessoryView = tool
            cell?.txtCouponCode.delegate = self
            
            cell?.btnUpdateCart.addTarget(self, action: #selector(btnUpdateClicked(_:)), for: .touchUpInside)
            
            cell?.btnApply.addTarget(self, action: #selector(btnApplyCouponClicked(_:)), for: .touchUpInside)
            
            cell?.txtCouponCode.text = strCouponCode
            
            if dicCoupon.allKeys.count > 0
            {
               cell?.txtCouponCode.isHidden =  true
               cell?.lblCouponDes.isHidden = false
               cell?.btnApply.setTitle("Remove", for: .normal)
               cell?.lblCouponDes.text = String(format: "Coupon Applied: %@", dicCoupon.valueForNullableKey(key: "name"))
            }
            else
            {
               cell?.txtCouponCode.isHidden =  false
               cell?.lblCouponDes.isHidden = true
               cell?.btnApply.setTitle("Apply", for: .normal)
            }
            
            
            return cell!
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    //MARK: - UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " "
        {
            return false
        }
        
        if textField.tag != 1111 {
            
            if string == "0" && textField.text!.characters.count == 0 {
                
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
        
        return true
        
    }

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField.tag == 1111 {
            
            strCouponCode = textField.text!
        }
        else
        {
            let ObjCart = arrMyCart.object(at: textField.tag) as! NSDictionary
            
            let strArtShopId = ObjCart.valueForNullableKey(key: "shopart_id")
            
            var isExistInAnswer = false
            
            let aryCartGroup: NSArray = arrUpdatedQty.mutableCopy() as! NSArray
            
            aryCartGroup.enumerateObjects({(object, idx, stop) -> Void in
                
                let cart: NSMutableDictionary = object as! NSMutableDictionary
                
                if cart["artshop_id"] as! String == strArtShopId
                {
                    
                    cart.setValue(textField.text!, forKey: "qty")
                    
                    isExistInAnswer = true
                }
                
            })
            
            if isExistInAnswer == false
            {
                
                let cart = NSMutableDictionary()
                
                cart.setValue(strArtShopId, forKey: "artshop_id")
                cart.setValue(textField.text!, forKey: "qty")
                
                arrUpdatedQty.add(cart)

                
            }
            
            print(arrUpdatedQty)
            
          //  tblCartData.reloadData()
            
        }
    }

    //MARK: - Webservice Methods
    
    
    func ApplyCoupon()
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
        
        parameters.setObject(strCouponCode, forKey: "code" as NSCopying)
        
        print("sending data : \(parameters)")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        
        print(strforMD5)
        
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let url = String(format: "%@applycoupon", kSkeuomoMainURL)
        
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
                            
                            
                            
                            
                            
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            if (DicResponseData.object(forKey: "appliedCoupon") as! NSDictionary).object(forKey: "coupon") != nil && (DicResponseData.object(forKey: "appliedCoupon") as! NSDictionary).object(forKey: "coupon") is NSDictionary && ((DicResponseData.object(forKey: "appliedCoupon") as! NSDictionary).object(forKey: "coupon") as! NSDictionary).allKeys.count > 0
                            {
                                self.dicCoupon = (DicResponseData.object(forKey: "appliedCoupon") as! NSDictionary).object(forKey: "coupon") as! NSDictionary
                            }
                            
                            
                            if DicResponseData.object(forKey: "ShopartTempOrder") != nil
                            {
                                
                                if DicResponseData.object(forKey: "ShopartTempOrder") != nil
                                {
                                    let tempArr = DicResponseData.object(forKey: "ShopartTempOrder") as! NSArray
                                    
                                    self.arrUpdatedQty.removeAllObjects()
                                    
                                    self.arrMyCart.removeAllObjects()
                                    
                                    self.arrMyCart.addObjects(from: tempArr as! [NSDictionary])
                                    
                                    self.tblCartData.reloadData()
                                }
                            }
                            
                            
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
    
    func RemoveCoupon()
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
        
        //http://demo2server.in/sites/laravelapp/skeuomo/api/removecoupon?userid=97
        
        let  url  = String(format: "%@removecoupon?userid=%@", kSkeuomoMainURL,strUserid)
        
        print("URL:",url)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                         //   let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            self.dicCoupon = NSDictionary()
                            self.tblCartData.reloadData()
                            
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
    
    func UpdateCart()
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
        
        let strCartJson = self.jsonString(arr: arrUpdatedQty) 
        
        parameters.setObject(strCartJson!, forKey: "data" as NSCopying)
        
        print("sending data : \(parameters)")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        
        print(strforMD5)
        
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let url = String(format: "%@updateCart", kSkeuomoMainURL)
        
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
                            
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            if DicResponseData.object(forKey: "ShopartTempOrder") != nil
                            {
                                
                                if DicResponseData.object(forKey: "ShopartTempOrder") != nil
                                {
                                    let tempArr = DicResponseData.object(forKey: "ShopartTempOrder") as! NSArray
                                    
                                    self.arrUpdatedQty.removeAllObjects()
                                    
                                    self.arrMyCart.removeAllObjects()
                                    
                                    self.arrMyCart.addObjects(from: tempArr as! [NSDictionary])
                                    
                                    self.tblCartData.reloadData()
                                }
                            }
                            
                            
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
    
    func RemoveFormCart(ItemCartId : String)
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
        
        parameters.setValue(ItemCartId, forKey: "id")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        //http://demo2server.in/sites/laravelapp/skeuomo/api/removeItem?id=49&userid=72
        
        let  url  = String(format: "%@removeItem?id=%@&userid=%@", kSkeuomoMainURL,ItemCartId,strUserid)
        
        print("Get Post URL :",url)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
//                            self.arrMyCart.removeObject(at: self.selectedIndexToDelete)
//                            self.tblCartData.reloadData()
                            
                            HelpingMethods.sharedInstance.ShowHUD()
                            self.performSelector(inBackground: #selector(self.GetMyCart), with: nil)
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
    
    func GetMyCart()
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
        
        //http://demo2server.in/sites/laravelapp/skeuomo/api/cart?userid=72
        
        let  url  = String(format: "%@cart?userid=%@", kSkeuomoMainURL,strUserid)
        
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
                            
                            if (DicResponseData.object(forKey: "appliedCoupon") as! NSDictionary).object(forKey: "coupon") != nil && (DicResponseData.object(forKey: "appliedCoupon") as! NSDictionary).object(forKey: "coupon") is NSDictionary && ((DicResponseData.object(forKey: "appliedCoupon") as! NSDictionary).object(forKey: "coupon") as! NSDictionary).allKeys.count > 0
                            {
                                self.dicCoupon = (DicResponseData.object(forKey: "appliedCoupon") as! NSDictionary).object(forKey: "coupon") as! NSDictionary
                            }
                            
                            if DicResponseData.object(forKey: "ShopartTempOrder") != nil
                            {
                                
                                if DicResponseData.object(forKey: "ShopartTempOrder") != nil
                                {
                                    let tempArr = DicResponseData.object(forKey: "ShopartTempOrder") as! NSArray
                                    
                                    self.arrUpdatedQty.removeAllObjects()
                                    
                                    self.arrMyCart.removeAllObjects()
                                    
                                    self.arrMyCart.addObjects(from: tempArr as! [NSDictionary])
                                    
                                    self.tblCartData.reloadData()
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

    
    //MARK: - Get SubTotal
    
    func getSubTotalAmount() -> String {
        
        var strTotalAmount = ""
        
        var totalAmount : Float = 0.0
        
        for obj in arrMyCart
        {
            let DicObj = obj as! NSDictionary
            
            let GrandTotal = DicObj.object(forKey: "grand_total") as! Float
            
            totalAmount = totalAmount + GrandTotal
            
        }
        
        strTotalAmount = String(format: "%.2f", totalAmount)
        
        return strTotalAmount
        
        
    }
    
    func getGrandTotal() -> NSMutableDictionary
    {
        
        let dicData = NSMutableDictionary()
        
        
        var strTotalAmount = ""
        
        let strSubTotal = self.getSubTotalAmount()
        
        var totalAmount : Float = Float(strSubTotal)!
        
        if dicCoupon.allKeys.count > 0
        {
            if dicCoupon.valueForNullableKey(key: "discount_type") == "percentage"
            {
                let discount = dicCoupon.object(forKey: "discount") as! NSNumber
                
                let DiscountAmount = totalAmount * Float(discount) / 100
                
                let  strDiscountAmount = String(format: "%.2f", DiscountAmount)

                
                dicData.setValue(strDiscountAmount, forKey: "discountamount")
                
                
                totalAmount = totalAmount - DiscountAmount
                
                
                strTotalAmount = String(format: "%.2f", totalAmount)

                dicData.setValue(strTotalAmount, forKey: "grandamount")
            
            }
            else
            {
                let discount = dicCoupon.object(forKey: "discount") as! NSNumber
                
                let  strDiscountAmount = String(format: "%.2f", Float(discount))

                dicData.setValue(strDiscountAmount, forKey: "discountamount")
                
                totalAmount = totalAmount - Float(discount)

                strTotalAmount = String(format: "%.2f", totalAmount)
                
                dicData.setValue(strTotalAmount, forKey: "grandamount")

            }
        }
        else
        {
            dicData.setValue("0.0", forKey: "discountamount")
            
            strTotalAmount = String(format: "%.2f", totalAmount)
            
            dicData.setValue(strTotalAmount, forKey: "grandamount")
        }
        
        
        return dicData
        
    }
    
    
}


