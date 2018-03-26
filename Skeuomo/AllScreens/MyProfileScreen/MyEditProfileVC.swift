//
//  MyEditProfileVC.swift
//  Skeuomo
//
//  Created by by Jannes on 23/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking
import AVFoundation
import AVKit


class MyEditProfileVC: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate{
    
    
    
    var strProfileVideo = ""
    var strProfileVideoThumb = ""

    var player : AVPlayer!

    var VideoMediaUrl : URL!
    var imgVideoThumb : UIImage!
    
    @IBOutlet   var     viewDatePicker      : UIView!
    @IBOutlet   var     DatePicker          : UIDatePicker!
    @IBOutlet   var     viePickerShow       : UIView!
    @IBOutlet   var     pickerDataSet       : UIPickerView!
    @IBOutlet   var     tblProflieDetails   : UITableView!
    @IBOutlet   var     btnBackSide         : UIButton!
    
    @IBOutlet   var     ToolBar             : UIToolbar!
    
    var arrname         = NSArray()
    var arrPassword     = NSArray()
    
    var txtDob          = UITextField()
    var txtCity         = UITextField()
    var txtState        = UITextField()
    var txtCountry      = UITextField()
    
    var dOBDate         = NSDate()
    var strDOB          = String()
    
    var arrCountryName  = NSMutableArray()
    var arrStateName    = NSMutableArray()
    var arrCityName     = NSMutableArray()
    
    var Pickervalue     : Int!
    let picker          = UIImagePickerController()
    var imgviewPro      = UIImageView()
    
    var btnMale         = UIButton()
    var btnFemale       = UIButton()
    var fromSideMenu    = ""
   
    
    //ashish
    var refImage        = UIImage()
    
    var imgBgviewPro    = UIImageView()
    var refBgImage      = UIImage()
    
    var txtFirstName    = UITextField()
    var txtLastName     = UITextField()
    var txtMobleNumber  = UITextField()
    var txtPostalCode   = UITextField()
    
    var txtInspiration  = UITextField()
    var txtEducation    = UITextField()
    var txtViewBiography = UITextView()
    
    var txtViewAdress   = UITextView()
    
    var txtCompanyName  = UITextField()
    var txtWebsite      = UITextField()
    
    var txtInstagram    = UITextField()
    var txtFacebook     = UITextField()
    var txtTwitter      = UITextField()
    var txtGooglePlus   = UITextField()
    var txtPinterest    = UITextField()
    var txtTumblr       = UITextField()
    var txtYoutube      = UITextField()
    
    
    var selectedIndex   : Int = -1
    
    var dictUserData    = NSDictionary()
    var arrCountryList  = NSArray()
    
    var ImgData         = NSData()
    var ImgBgData       = NSData()
    
    var strFirstName    = String()
    var strLastName     = String()
    var strMobileNumber = String()
    var strGender       = String()
    
    var strCity         = String()
    var strState        = String()
    var strCountry      = String()
    var strAdress       = String()
    var strPostalCode   = String()
    
    var strInspiration  = String()
    var strEducation    = String()
    var strBiography    = String()
    
    var strCompanyName  = String()
    var strWebsite      = String()
    
    var strInstagram    = String()
    var strFacebook     = String()
    var strTwitter      = String()
    var strGooglePlus   = String()
    var strPinterest    = String()
    var strTumblr       = String()
    var strYoutube      = String()
    
    
    var selectedMediaType = ""
    
    
    
    var isAdressSelected = Bool()
    var isProfileVisibilty = Bool()
    
    
    @IBOutlet var viewPersonal  : UIView!
    @IBOutlet var viewAddress   : UIView!
    @IBOutlet var viewGeneral   : UIView!
    @IBOutlet var viewProessional : UIView!
    @IBOutlet var viewSocial    : UIView!
    @IBOutlet var viewProfile   : UIView!
    @IBOutlet var viewVideo   : UIView!

    @IBOutlet weak var imgThemeBG: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        arrCountryName = ["India", "USA", "Japan", "China", "Pak"]
        
        arrStateName = ["Rajasthan", "Gujrat", "Andhra Pradesh", "Arunachal Pradesh", "Assam"]
        
        arrCityName = ["Jaipur", "Mumbai", "Delhi", "Bangalore", "Hyderabad"]
        
        arrname = ["First Name*","Last Name*","User Name*","Moblie Number*","Email* Address*","Date of Birth*"]
        
        arrPassword = ["Password","Confirm Password"]
        
        print("user data : ",dictUserData)
        
        strFirstName    = dictUserData.object(forKey: "firstName") as! String
        strLastName     = dictUserData.object(forKey: "lastName") as! String
        strMobileNumber = dictUserData.object(forKey: "mobile_number") as! String
        strGender       = dictUserData.object(forKey: "gender") as! String
        strCity         = dictUserData.object(forKey: "city") as! String
        strState        = dictUserData.object(forKey: "state") as! String
        strCountry      = (dictUserData.object(forKey: "country")  as! NSDictionary).object(forKey: "name") as! String
        strAdress       = dictUserData.object(forKey: "address") as! String
        strPostalCode   = dictUserData.object(forKey: "zipCode") as! String
        
        strInspiration  = dictUserData.object(forKey: "inspiration") as! String
        strEducation    = dictUserData.object(forKey: "education") as! String
        strBiography    = dictUserData.object(forKey: "biography") as! String
        
        strCompanyName  = dictUserData.object(forKey: "companyName") as! String
        strWebsite      = dictUserData.object(forKey: "website") as! String
        
        strInstagram    = dictUserData.object(forKey: "instagram") as! String
        strFacebook     = dictUserData.object(forKey: "facebook")  as! String
        strTwitter      = dictUserData.object(forKey: "twitter")  as! String
        strGooglePlus   = dictUserData.object(forKey: "googlePlus")  as! String
        strPinterest    = dictUserData.object(forKey: "pinterest")  as! String
        strTumblr       = dictUserData.object(forKey: "tumblr")  as! String
        strYoutube      = dictUserData.object(forKey: "youTube")  as! String
        
        
        strProfileVideo = dictUserData.object(forKey: "video")  as! String
        strProfileVideoThumb =  dictUserData.object(forKey: "video_thumbnail")  as! String
        
        //profile visibilty
        
        if(self.dictUserData.object(forKey: "profileVisibility")  as! String == "Yes")
        {
            isProfileVisibilty = true
        }
        else
        {
            isProfileVisibilty = false
        }
        
        //shipping adress
        
        if(dictUserData.object(forKey: "is_shipping_address_same")  as! String == "1")
        {
            isAdressSelected = true
        }
        else
        {
            isAdressSelected = false
        }
        
        if(dictUserData.object(forKey: "dob") != nil)
        {
            strDOB = (dictUserData.object(forKey: "dob") as! NSString) as String
        }
        else
        {
            strDOB = ""
        }
        
        if UserDefaults.standard.object(forKey: "CountryList") != nil
        {
            arrCountryList = UserDefaults.standard.object(forKey: "CountryList") as! NSArray
        }
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: NSNotification.Name.UITextViewTextDidChange,
                                               object: nil)
        
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
        
        if fromSideMenu == "FromSideMenu"
        {
            self.btnBackSide.setImage(UIImage.init(named: "menu'.png"), for: .normal)
        }
        else
        {
            self.btnBackSide.setImage(UIImage.init(named: "back.png"), for: .normal)
        }
        
        
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
    
    //MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 8// 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
        }
        if section == 1
        {
            return 7 
        }
        else if section == 2
        {
            return 4
        }
        else if section == 3
        {
            return 3
        }
        else if section == 4
        {
            return 2
        }
        else if section == 5
        {
            return 7
        }
        else if section == 7
        {
            return 1
        }
        else
        {
            return 1
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return 0
        }
        else
        {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        if section == 1
        {
            return viewPersonal
        }
        if section == 2
        {
            return viewAddress
        }
        else if section == 3
        {
            return viewGeneral
        }
        else if(section == 4)
        {
            return viewProessional
        }
        else if(section == 5)
        {
            return viewSocial
        }
        else if section == 6
        {
            return viewVideo
        }
        else if section == 7
        {
            return viewProfile
        }
        else
        {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 266
        }
        else if indexPath.section == 1
        {//personal info
            if(indexPath.row == 6)
            {
                return 80
            }
            else
            {
                return 70
            }

        }
        else if indexPath.section == 2
        {
            if(indexPath.row == 0)
            {
                return 100
            }
            else if(indexPath.row == 1)
            {
                return 130
            }
            else if(indexPath.row == 2)
            {
                return 70
            }
            else
            {
                return 44
            }
        }
        else if indexPath.section == 3
        {
            if indexPath.row == 0 || indexPath.row == 1
            {
                return 70
            }
            else
            {
                return 100
            }
        }
        else if indexPath.section == 4
        {
            return 70
        }
        else if indexPath.section == 5
        {
            return 70
        }
        else if indexPath.section == 6
        {
            return 214
        }
        else
        {
            return 74
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cellIdentifier:String = "MyProfileIMGTblCell"
            var cell:MyProfileIMGTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MyProfileIMGTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("MyProfileIMGTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? MyProfileIMGTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //image code
            let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(self.dictUserData.object(forKey: "profile_picture") as? String)!)
            
            

            
            let urlImage : NSURL = NSURL(string: urlStr as String)!
            
            if(self.ImgData.length > 0)
            {
                
                cell?.imgProfile.image = refImage
                
                
            }
            else
            {
                
                
                cell?.imgProfile.setImageWith(urlImage as URL, placeholderImage: UIImage.init(named:"user_place"))

                
              //  cell?.imgProfile.sd_setImage(with: urlImage as URL!, placeholderImage: UIImage.init(named:"user_place"), options: .refreshCached, completed: nil)
            }
            
            
            
            cell?.imgProfile.layer.cornerRadius = (cell?.imgProfile.frame.size.width)! / 2
            cell?.imgProfile.layer.masksToBounds =  true
            
            cell?.imgProfile.layer.borderWidth = 1.0
            cell?.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
            
            imgviewPro = (cell?.imgProfile)!
            
            //background image
            let urlStr1 = NSString(format: "%@%@",kSkeuomoImageURL,(self.dictUserData.object(forKey: "backgroung_picture") as? String)!)
            
            

            
            
            let urlImage1 : NSURL = NSURL(string: urlStr1 as String)!
            
            if(self.ImgBgData.length > 0)
            {
                cell?.imgBgProfile.image = refBgImage
            }
            else
            {
                
                cell?.imgBgProfile.setImageWith(urlImage1 as URL, placeholderImage: UIImage.init(named:"bgS.png"))

                
               // cell?.imgBgProfile.sd_setImage(with: urlImage1 as URL!, placeholderImage: UIImage.init(named:"bgS.png"), options: .refreshCached, completed: nil)
            }
            
            imgBgviewPro = (cell?.imgBgProfile)!
            
            cell?.lblUserName.text = NSString(format: "%@ %@",strFirstName,strLastName) as String
            
            let strLocation =  NSString(format: " %@, %@, %@",(self.dictUserData.object(forKey: "city") as? String)!,(self.dictUserData.object(forKey: "state") as? String)!,(dictUserData.object(forKey: "country")  as! NSDictionary).object(forKey: "name") as! String ) as String
            
            cell?.btnAddress.setTitle(strLocation, for: UIControlState.normal)
            cell?.lblAddress.isHidden = true
            
            cell?.lblFollowers.text = "25"
            cell?.lblFollowing.text = "25"
            
            
            cell?.btnBgCamera.addTarget(self, action: #selector(btnHandlerCamera), for: .touchUpInside)
            cell?.btnBgCamera.tag = 100
            
            cell?.btnCamera.addTarget(self, action: #selector(btnHandlerCamera), for: .touchUpInside)
            
            cell?.btnCamera.tag = 200
            
            return cell!
        }
        else if indexPath.section == 1
        {
            let cellIdentifier:String = "UserDetailsTblCell"
            var cell:UserDetailsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UserDetailsTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("UserDetailsTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? UserDetailsTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //cell?.lblTitleName.text = arrname.object(at: indexPath.row) as? String
            
            cell?.txtNames.delegate = self
            
            if indexPath.row == 0
            {//first name
                cell?.lblTitleName.text = "First Name"
                txtFirstName = (cell?.txtNames)!
                cell?.txtNames.text = strFirstName as String
                cell?.txtNames.tag = indexPath.row
            }
            else if indexPath.row == 1
            {//last name
                cell?.lblTitleName.text = "Last Name"
                txtLastName = (cell?.txtNames)!
                cell?.txtNames.text = strLastName as String
                cell?.txtNames.tag = indexPath.row
            }
            else if indexPath.row == 2
            {//user name
                cell?.lblTitleName.text = "User Name"
                cell?.txtNames.text = (dictUserData.object(forKey: "username") as! NSString) as String
                cell?.txtNames.isEnabled = false
                cell?.txtNames.tag = indexPath.row
            }
            else if indexPath.row == 3
            {//mobile number
                cell?.lblTitleName.text = "Mobile Number"
                cell?.txtNames.text = strMobileNumber as String
                txtMobleNumber = (cell?.txtNames)!
                txtMobleNumber.delegate = self
                cell?.txtNames.keyboardType = UIKeyboardType.numberPad
                cell?.txtNames.inputAccessoryView = ToolBar
                cell?.txtNames.tag = indexPath.row
            }

            else if indexPath.row == 4
            {
                cell?.lblTitleName.text = "Email"
                cell?.txtNames.text = (dictUserData.object(forKey: "email") as! NSString) as String
                cell?.txtNames.isEnabled = false
                cell?.txtNames.tag = indexPath.row
            }
            else if indexPath.row == 5
            {
                cell?.lblTitleName.text = "Date Of Birth"
                cell?.txtNames.delegate = self
                txtDob.tag = indexPath.row
                txtDob = (cell?.txtNames)!
                
                
                cell?.txtNames.text = strDOB as String?
                
            }
            else
            {
                
                let cellIdentifier:String = "CellGender"
                
                var cell:CellGender? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CellGender
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("CellGender", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? CellGender
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);

                }
                
                btnMale = (cell?.btnMale)!
                btnFemale = (cell?.btnFemale)!
                
                if(strGender == "Male")
                {
                    cell?.btnMale.isSelected = true
                    cell?.btnFemale.isSelected =  false
                    
                    
                    cell?.btnMale.backgroundColor = UIColor.init(red: 15.0/255.0, green: 125.0/255.0, blue: 254.0/255.0, alpha: 1)
                    
                    cell?.btnFemale.backgroundColor = UIColor.lightGray
                    
                }
                else if(strGender == "Female")
                {
                    cell?.btnMale.isSelected = false
                    cell?.btnFemale.isSelected = true
                    
                    cell?.btnFemale.backgroundColor = UIColor.init(red: 15.0/255.0, green: 125.0/255.0, blue: 254.0/255.0, alpha: 1)
                    
                    cell?.btnMale.backgroundColor = UIColor.lightGray
                    
                }
                else
                {
                    cell?.btnMale.isSelected = false
                    cell?.btnFemale.isSelected = false
                    
                    cell?.btnMale.backgroundColor = UIColor.lightGray
                    cell?.btnFemale.backgroundColor = UIColor.lightGray
                }
                
                cell?.btnMale.tag = 100
                cell?.btnFemale.tag = 200
                
                cell?.btnMale.layer.borderWidth = 1.0
                cell?.btnMale.layer.borderColor = UIColor.init(red: 226.0/255.0, green: 227.0/255.0, blue: 228.0/255.0, alpha: 1.0).cgColor
                
                cell?.btnFemale.layer.borderWidth = 1.0
                cell?.btnFemale.layer.borderColor = UIColor.init(red: 226.0/255.0, green: 227.0/255.0, blue: 228.0/255.0, alpha: 1.0).cgColor
                
                cell?.btnMale.addTarget(self, action: #selector(methodSelectGender), for: UIControlEvents.touchUpInside)
                
                cell?.btnFemale.addTarget(self, action: #selector(methodSelectGender), for: UIControlEvents.touchUpInside)
                
                return cell!

            }
            
            return cell!
            
        }
        else if indexPath.section == 2
        {
            if(indexPath.row == 0)
            {
                let cellIdentifier:String = "CellAddress"
                var cell:CellAddress? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CellAddress
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("CellAddress", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? CellAddress
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                
                cell?.lblTxtViewHeader.text = "Address"
                
                cell?.txtviewAddress.text = strAdress as String
                cell?.txtviewAddress.delegate = self
                cell?.txtviewAddress.inputAccessoryView = ToolBar
                txtViewAdress = (cell?.txtviewAddress)!
                
                return cell!
            }
            else if indexPath.row == 1
            {
                let cellIdentifier:String = "GenderLocationTblcell"
                var cell:GenderLocationTblcell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? GenderLocationTblcell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("GenderLocationTblcell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? GenderLocationTblcell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                
                cell?.txtCity.delegate = self
                cell?.txtState.delegate = self
                cell?.txtCountry.delegate = self
                
                // txtCity.tag = indexPath.row
                txtCity = (cell?.txtCity)!
                txtState = (cell?.txtState)!
                txtCountry = (cell?.txtCountry)!
                
                txtCity.text = strCity as String
                txtState.text = strState as String
                txtCountry.text = strCountry as String
                
                /*
                 btnMale = (cell?.btnMale)!
                 btnFemale = (cell?.btnFemale)!
                 
                 
                 if(strGender == "Male")
                 {
                 cell?.btnMale.isSelected = true
                 cell?.btnFemale.isSelected =  false
                 
                 
                 cell?.btnMale.backgroundColor = UIColor.init(red: 15.0/255.0, green: 125.0/255.0, blue: 254.0/255.0, alpha: 1)
                 
                 cell?.btnFemale.backgroundColor = UIColor.lightGray
                 
                 }
                 else if(strGender == "Female")
                 {
                 cell?.btnMale.isSelected = false
                 cell?.btnFemale.isSelected = true
                 
                 cell?.btnFemale.backgroundColor = UIColor.init(red: 15.0/255.0, green: 125.0/255.0, blue: 254.0/255.0, alpha: 1)
                 
                 cell?.btnMale.backgroundColor = UIColor.lightGray
                 
                 }
                 else
                 {
                 cell?.btnMale.isSelected = false
                 cell?.btnFemale.isSelected = false
                 
                 cell?.btnMale.backgroundColor = UIColor.lightGray
                 cell?.btnFemale.backgroundColor = UIColor.lightGray
                 }
                 
                 cell?.btnMale.tag = 100
                 cell?.btnFemale.tag = 200
                 
                 cell?.btnMale.layer.borderWidth = 1.0
                 cell?.btnMale.layer.borderColor = UIColor.init(red: 226.0/255.0, green: 227.0/255.0, blue: 228.0/255.0, alpha: 1.0).cgColor
                 
                 cell?.btnFemale.layer.borderWidth = 1.0
                 cell?.btnFemale.layer.borderColor = UIColor.init(red: 226.0/255.0, green: 227.0/255.0, blue: 228.0/255.0, alpha: 1.0).cgColor
                 
                 cell?.btnMale.addTarget(self, action: #selector(methodSelectGender), for: UIControlEvents.touchUpInside)
                 
                 cell?.btnFemale.addTarget(self, action: #selector(methodSelectGender), for: UIControlEvents.touchUpInside)*/
                
                return cell!
 
            }
            else if indexPath.row == 2
            {
                let cellIdentifier:String = "UserDetailsTblCell"
                var cell:UserDetailsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UserDetailsTblCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("UserDetailsTblCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? UserDetailsTblCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                
                cell?.lblTitleName.text = "Postal Code*"
                
                cell?.txtNames.delegate = self
                txtPostalCode = (cell?.txtNames)!
                txtPostalCode.delegate = self
                cell?.txtNames.text = strPostalCode as String
                cell?.txtNames.keyboardType = UIKeyboardType.numberPad
                cell?.txtNames.inputAccessoryView = ToolBar
                cell?.txtNames.tag = indexPath.row
                return cell!
            }
            else
            {
                let cellIdentifier:String = "CellIsShippingAdress"
                var cell:CellIsShippingAdress? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CellIsShippingAdress
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("CellIsShippingAdress", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? CellIsShippingAdress
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                if (isAdressSelected)
                {
                    cell?.btnIsAdressSelect.isSelected = true
                }
                else
                {
                    cell?.btnIsAdressSelect.isSelected = false
                }
                
                cell?.btnIsAdressSelect.addTarget(self, action: #selector(methodIsAdressSelected), for: UIControlEvents.touchUpInside)
                
                return cell!
            }
            
        }
        else if indexPath.section == 3
        {
            if indexPath.row == 0 || indexPath.row == 1
            {
                let cellIdentifier:String = "UserDetailsTblCell"
                var cell:UserDetailsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UserDetailsTblCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("UserDetailsTblCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? UserDetailsTblCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                
                cell?.txtNames.delegate = self
                
                if indexPath.row == 0
                {
                    //INSPIRATION
                    cell?.lblTitleName.text = "Inspiration"
                    txtInspiration = (cell?.txtNames)!
                    cell?.txtNames.text = strInspiration as String
                    cell?.txtNames.tag = indexPath.row
                }
                else
                {
                    //EDUCATION
                    cell?.lblTitleName.text = "Education"
                    txtEducation = (cell?.txtNames)!
                    cell?.txtNames.text = strEducation as String
                    cell?.txtNames.tag = indexPath.row
                }
                
                return cell!
            }
            else
            {
                //BIOGRAPHY
                let cellIdentifier:String = "CellAddress"
                var cell:CellAddress? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CellAddress
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("CellAddress", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? CellAddress
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                cell?.lblTxtViewHeader.text = "Biography"
                cell?.txtviewAddress.text = strBiography as String
                cell?.txtviewAddress.delegate = self
                cell?.txtviewAddress.inputAccessoryView = ToolBar
                txtViewBiography = (cell?.txtviewAddress)!
                
                return cell!
                
            }
        }
        else if indexPath.section == 4
        { //PROFESSIONAL INFORMATION
            
            let cellIdentifier:String = "UserDetailsTblCell"
            var cell:UserDetailsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UserDetailsTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("UserDetailsTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? UserDetailsTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            cell?.txtNames.delegate = self
            
            if indexPath.row == 0
            {
                //COMPANY NAME
                cell?.lblTitleName.text = "Company Name"
                txtCompanyName = (cell?.txtNames)!
                cell?.txtNames.text = strCompanyName as String
                cell?.txtNames.tag = indexPath.row
            }
            else
            {
                //WEBSITE
                cell?.lblTitleName.text = "Website"
                txtWebsite = (cell?.txtNames)!
                cell?.txtNames.text = strWebsite as String
                cell?.txtNames.tag = indexPath.row
            }
            
            return cell!
        }
        else if indexPath.section == 5
        {//social info
            
            let cellIdentifier:String = "UserDetailsTblCell"
            var cell:UserDetailsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UserDetailsTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("UserDetailsTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? UserDetailsTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            cell?.txtNames.delegate = self
            
            if indexPath.row == 0
            {
                //Instagram
                cell?.lblTitleName.text = "Instagram"
                txtInstagram = (cell?.txtNames)!
                cell?.txtNames.text = strInstagram as String
                cell?.txtNames.tag = indexPath.row
            }
            else if indexPath.row == 1
            {
                //Facebook
                cell?.lblTitleName.text = "Facebook"
                txtFacebook = (cell?.txtNames)!
                cell?.txtNames.text = strFacebook as String
                cell?.txtNames.tag = indexPath.row
            }
            else if indexPath.row == 2
            {
                //Twitter
                cell?.lblTitleName.text = "Twitter"
                txtTwitter = (cell?.txtNames)!
                cell?.txtNames.text = strTwitter as String
                cell?.txtNames.tag = indexPath.row
            }
            else if indexPath.row == 3
            {
                //Google Plus
                cell?.lblTitleName.text = "Google Plus"
                txtGooglePlus = (cell?.txtNames)!
                cell?.txtNames.text = strGooglePlus as String
                cell?.txtNames.tag = indexPath.row
            }
            else if indexPath.row == 4
            {
                //Pinterest
                cell?.lblTitleName.text = "Pinterest"
                txtPinterest = (cell?.txtNames)!
                cell?.txtNames.text = strPinterest as String
                cell?.txtNames.tag = indexPath.row
            }
            else if indexPath.row == 5
            {
                //Tumblr
                cell?.lblTitleName.text = "Tumblr"
                txtTumblr = (cell?.txtNames)!
                cell?.txtNames.text = strTumblr as String
                cell?.txtNames.tag = indexPath.row
            }
            else
            {
                //Youtube
                cell?.lblTitleName.text = "Youtube"
                txtYoutube = (cell?.txtNames)!
                cell?.txtNames.text = strYoutube as String
                cell?.txtNames.tag = indexPath.row
            }
            
            return cell!
            
        }
        else if indexPath.section == 7
        {
            let cellIdentifier:String = "CellProfileSetting"
            var cell:CellProfileSetting? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CellProfileSetting
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("CellProfileSetting", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? CellProfileSetting
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            if isProfileVisibilty == true
            {
                cell?.btnYes.isSelected = true
                cell?.btnNo.isSelected = false
                
                cell?.btnYes.backgroundColor = UIColor.gray
                cell?.btnNo.backgroundColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
                
            }
            else
            {
                cell?.btnYes.isSelected = false
                cell?.btnNo.isSelected = true
                
                cell?.btnYes.backgroundColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
                cell?.btnNo.backgroundColor = UIColor.gray
                
            }
            
            
            cell?.btnYes.tag = 100
            cell?.btnNo.tag = 200
            
            cell?.btnYes.addTarget(self, action: #selector(methodProfileVisibiltyOn), for: UIControlEvents.touchUpInside)
            
            cell?.btnNo.addTarget(self, action: #selector(methodProfileVisibiltyOn), for: UIControlEvents.touchUpInside)
            
            return cell!
        }
        else
        {
            let cellIdentifier:String = "UploadProfileVideoCell"
            
            var cell:UploadProfileVideoCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UploadProfileVideoCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("UploadProfileVideoCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? UploadProfileVideoCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            cell?.btnUploadVideo.addTarget(self, action: #selector(btnHandlerCamera(sender:)), for: .touchUpInside)
            
            cell?.btnUploadVideo.tag = 222
            
            cell?.btnPlay.addTarget(self, action: #selector(btnPlayVideo(sender:)), for: .touchUpInside)
            
            if VideoMediaUrl != nil
            {
                cell?.imgThumb.image = imgVideoThumb
            }
            else
            {
                let urlStr1 = NSString(format: "%@%@",kSkeuomoImageURL,strProfileVideoThumb)
                
                let urlImage = URL.init(string: urlStr1 as String)

                cell?.imgThumb.sd_setImage(with: urlImage as URL!, placeholderImage: UIImage.init(named:""), options: .refreshCached, completed: nil)
                

            }
            
            return cell!
            
        }
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    
    
    //MARK: ButtonsMethods
    
    func btnPlayVideo(sender:UIButton!)
    {
        
     
        
        if VideoMediaUrl != nil
        {
            
            let player = AVPlayer(url: VideoMediaUrl!)
            
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        else if strProfileVideo.characters.count > 0
        {
            
            let strVideo = String.init(format: "%@%@", kSkeuomoImageURL,strProfileVideo)
            
            
            let url = URL.init(string: strVideo)
            
            let player = AVPlayer(url: url!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    
    func methodProfileVisibiltyOn(_ sender : UIButton)
    {
        if(sender.tag == 100)
        {
            if !sender.isSelected
            {
                isProfileVisibilty = true
            }
        }
        else
        {
            if !sender.isSelected
            {
                isProfileVisibilty = false
            }
        }
        
        tblProflieDetails.reloadData()
    }
    
    func methodIsAdressSelected(_ sender : UIButton)
    {
        if(sender.isSelected)
        {
            sender.isSelected = false
            isAdressSelected = false
        }
        else
        {
            sender.isSelected = true
            isAdressSelected = true
        }
    }
        
    @IBAction func btnDone(_ sender: Any)
    {
        self.view.endEditing(true)
        
        if (strFirstName.characters.count == 0)
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: kFirstnameRequiredText, strSubtitle: "", controller: self)
        }
        else if(strLastName.characters.count == 0)
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: kLastnameRequiredText, strSubtitle: "", controller: self)
        }
        else if(strMobileNumber.characters.count == 0)
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: kMoblieRequiredText, strSubtitle: "", controller: self)
        }
        else if(strMobileNumber.characters.count != 10)
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: kMoblieLimitText, strSubtitle: "", controller: self)
        }
        else if(strDOB.characters.count == 0)
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: kDOBRequiredText, strSubtitle: "", controller: self)
        }
        else if(strGender.characters.count == 0)
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: kGenderRequiredText, strSubtitle: "", controller: self)
        }
        else if(strCity.characters.count == 0)
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: kCityRequiredText, strSubtitle: "", controller: self)
        }
        else if(strState.characters.count == 0)
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: kStateRequiredText, strSubtitle: "", controller: self)
        }
        else if(strPostalCode.characters.count == 0)
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: kPostelCodeRequiredText, strSubtitle: "", controller: self)

        }
        else if(strAdress.characters.count == 0)
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: kAdressRequiredText, strSubtitle: "", controller: self)
            
        }
        else
        {
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(UpdateProfileAPI), with: nil)
        }
        
            
        
    }
    @IBAction func btnDoneTextView(_ sender: Any)
    {
        self.view.endEditing(true)

    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        if fromSideMenu == "FromSideMenu"
        {
           self.appDelegate.sideMenuController.openMenu()
        }
        else
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
 
    @IBAction func btnDoneDOB(_ sender: Any)
    {
        self.viewDatePicker.removeFromSuperview()
        
        self.view.endEditing(true)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        strDOB = (dateFormatter.string(from: DatePicker.date) as NSString!) as String
        
        
        tblProflieDetails.reloadData()
    }
    
    @IBAction func btnDonePicker(_ sender: Any)
    {
        self.view.endEditing(true)
        
        if Pickervalue == 100 && txtCity.text == ""
        {
            txtCity.text = (arrCityName.object(at: 0) as AnyObject) as? String
        }
        else if Pickervalue == 101 && txtState.text == ""
        {
            txtState.text = (arrStateName.object(at: 0) as AnyObject) as? String
        }
        else if Pickervalue == 102 && txtCountry.text == ""
        {
            txtCountry.text = (arrCountryList.object(at: 0) as AnyObject) as? String
        }
        viePickerShow.removeFromSuperview()
    }
 
    
    //MARK: - date picker
    func datePickerValueChanged(sender:UIDatePicker)
    {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        strDOB = (dateFormatter.string(from: sender.date) as NSString!) as String
        
    }
    
    //MARK: textfieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == txtFirstName
        {
            txtFirstName.text = txtFirstName.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            
            strFirstName = txtFirstName.text!
        }
        else if textField == txtLastName
        {
            txtLastName.text = txtLastName.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            strLastName = txtLastName.text!
        }
        else if textField == txtCity
        {
            txtCity.text = txtCity.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            strCity = txtCity.text!
        }
        else if textField == txtState
        {
            txtState.text = txtState.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            strState = txtState.text!
        }
        else if textField == txtMobleNumber
        {
            txtMobleNumber.text = txtMobleNumber.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            strMobileNumber = txtMobleNumber.text!
        }
        else if textField == txtPostalCode
        {
            txtPostalCode.text = txtPostalCode.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

            strPostalCode = txtPostalCode.text!
        }
        else if textField == txtInspiration
        {
            strInspiration = txtInspiration.text!
        }
        else if textField == txtEducation
        {
            strEducation = txtEducation.text!
        }
        else if textField == txtCompanyName
        {
            strCompanyName = txtCompanyName.text!
        }
        else if textField == txtWebsite
        {
            strWebsite = txtWebsite.text!
        }
        
        else if textField == txtInstagram
        {
            strInstagram = txtInstagram.text!
        }
        else if textField == txtFacebook
        {
            strFacebook = txtFacebook.text!
        }
        else if textField == txtTwitter
        {
            strTwitter = txtTwitter.text!
        }
        else if textField == txtGooglePlus
        {
            strGooglePlus = txtGooglePlus.text!
        }
        else if textField == txtPinterest
        {
            strPinterest = txtPinterest.text!
        }
        else if textField == txtTumblr
        {
            strTumblr = txtTumblr.text!
        }
        else if textField == txtYoutube
        {
            strYoutube = txtYoutube.text!
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if textField.text == "" && string == " "
        {
            return false
        }
        
        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        
        if (textField == txtFirstName || textField == txtLastName || textField == txtCity || textField == txtState)
        {
            return newLength > 16 ? false : true;
        }
        else if(textField == txtMobleNumber)
        {
            return newLength > 10 ? false : true;
        }
        else if(textField == txtPostalCode)
        {
            return newLength > 6 ? false : true;
        }
        else
        {
            return true
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        
        if textField == txtDob
        {
            self.viewDatePicker.frame = self.view.frame
            self.view.addSubview(viewDatePicker)
            DatePicker.datePickerMode = UIDatePickerMode.date
          //  DatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
            DatePicker.backgroundColor = UIColor.white
            DatePicker.maximumDate = Date()
            DatePicker.date = Date()
            
            return false
        }
        else  if textField == txtCity
        {
            return true
        }
        else if textField == txtState
        {
            
            return true
        }
        else if textField == txtCountry
        {
            Pickervalue = 102
            self.viePickerShow.frame = self.view.frame
            self.view.addSubview(viePickerShow)
            pickerDataSet.reloadAllComponents()
            return false
        }
        
        return true
    }
    
    //MARK: textView Delegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        
        if(txtViewAdress.text.characters.count > 251 || txtViewBiography.text.characters.count > 251)
        {
            return false;
        }
        
        return true
    }
    
    func textDidChange()
    {
        let text = txtViewAdress.text
        
        if((text?.characters.count)! > 0)
        {
            if(txtViewAdress.text.characters.count < 251)
            {
                
            }
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if(textView == txtViewAdress)
        {
            strAdress = txtViewAdress.text!
        }
        else if(textView == txtViewBiography)
        {
            strBiography = txtViewBiography.text!
        }
    }
    
    
    @IBAction func methodSelectGender(_ sender : UIButton)
    {
        if(sender.tag == 100)
        {//male
            if(sender.isSelected)
            {
                sender.isSelected = false
                btnFemale.isSelected = true
                
                sender.backgroundColor = UIColor.lightGray
                btnFemale.backgroundColor = UIColor.init(red: 15.0/255.0, green: 125.0/255.0, blue: 254.0/255.0, alpha: 1)
                strGender = "Female"
            }
            else
            {
                sender.isSelected = true
                btnFemale.isSelected = false
                
                sender.backgroundColor = UIColor.init(red: 15.0/255.0, green: 125.0/255.0, blue: 254.0/255.0, alpha: 1)
                btnFemale.backgroundColor = UIColor.lightGray
                
                strGender = "Male"
            }
        }
        else
        {//female
            if(sender.isSelected)
            {
                sender.isSelected = false
                btnMale.isSelected = true
                
                sender.backgroundColor = UIColor.lightGray
                btnMale.backgroundColor = UIColor.init(red: 15.0/255.0, green: 125.0/255.0, blue: 254.0/255.0, alpha: 1)
                
                strGender = "Male"
            }
            else
            {
                sender.isSelected = true
                btnMale.isSelected = false
                
                
                
                sender.backgroundColor = UIColor.init(red: 15.0/255.0, green: 125.0/255.0, blue: 254.0/255.0, alpha: 1)
                btnMale.backgroundColor = UIColor.lightGray
                
                strGender = "Female"
                
            }
        }
        
       
        
        /*
        btnMale.backgroundColor = UIColor.init(red: 15.0/255.0, green: 125.0/255.0, blue: 254.0/255.0, alpha: 1)
        btnFemale.backgroundColor = UIColor.lightGray
        btnMale.setTitleColor(UIColor.white, for: .normal)
        btnFemale.setTitleColor(UIColor.black, for: .normal)
        */
    }
    
    @IBAction func btnHandlerFemale(_sender : UIButton)
    {
        btnMale.setTitleColor(UIColor.black, for: .normal)
        btnFemale.setTitleColor(UIColor.white, for: .normal)
        btnFemale.backgroundColor = UIColor.init(red: 15.0/255.0, green: 125.0/255.0, blue: 254.0/255.0, alpha: 1)
        btnMale.backgroundColor = UIColor.lightGray
        
    }
    
    
    // MARK: - OpenCameraForImage
    
    func btnHandlerCamera(sender:UIButton!)
    {
        if(sender.tag == 100)
        {
            selectedMediaType = "background"
        }
        else if sender.tag == 200
        {
            selectedMediaType = "image"
        }
        else
        {
            selectedMediaType = "video"
        }
    
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            
            let picker = UIImagePickerController()
            picker.delegate = self
            
            picker.allowsEditing = true
            
            picker.sourceType = UIImagePickerControllerSourceType.camera
            
            if selectedMediaType == "image" || selectedMediaType == "background"
            {
                picker.mediaTypes = [kUTTypeImage as String]
            }
            else
            {
                picker.mediaTypes = [kUTTypeMovie as String]
                picker.videoMaximumDuration = 15
            }
            
            picker.modalPresentationStyle = .fullScreen
            present(picker,
                    animated: true,
                    completion: nil)
        } else
        {
            appDelegate.ShowAlert(message: "No Camera Found")
        }
        
    }
    
    func photoLibrary()
    {
        // let myPickerController = UIImagePickerController()
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        if selectedMediaType == "image" || selectedMediaType == "background"
        {
            picker.allowsEditing = false
            
            picker.mediaTypes = [kUTTypeImage as String]
        }
        else
        {
            picker.allowsEditing = true
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.videoMaximumDuration = 15
        }
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
//    func camera()
//    {
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
//            {
//                let imagePicker = UIImagePickerController()
//                imagePicker.delegate = self
//                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
//                imagePicker.allowsEditing = false
//                self.present(imagePicker, animated: true, completion: nil)
//            }
//    }
//
//    func photoLibrary()
//    {
//        // let myPickerController = UIImagePickerController()
//        picker.delegate = self;
//        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//
//        self.present(picker, animated: true, completion: nil)
//
//    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        {
//            //  imgProfilePic.contentMode = .scaleAspectFit
//            imgviewPro.image = image
//        } else{
//            // appDelegate.ShowAlert(message: "No camera")
//        }
//        
//        self.dismiss(animated: true, completion: nil)
//    }
    
    //MARK: - UIImagePicker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        self.dismiss(animated: true, completion: nil)

        if selectedMediaType == "background"
        {
            if picker.allowsEditing
            {
                refBgImage = info[UIImagePickerControllerEditedImage] as! UIImage
            }
            else
            {
                refBgImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            }
            
            ImgBgData = UIImageJPEGRepresentation(refBgImage, 0.7)! as NSData
            
            imgBgviewPro.contentMode = .scaleAspectFill
            
            imgBgviewPro.image = refBgImage
            
        }
        else if selectedMediaType == "image"
        {
            
            if picker.allowsEditing {
                refImage = info[UIImagePickerControllerEditedImage] as! UIImage
            } else {
                refImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            }
            
            ImgData = UIImageJPEGRepresentation(refImage, 0.7)! as NSData
            
            imgviewPro.contentMode = .scaleAspectFill
            imgviewPro.image = refImage
            
        }
        else
        {
            let mediaType = info[UIImagePickerControllerMediaType] as? String
            
            if mediaType == "public.movie"
            {
                let url = info[UIImagePickerControllerMediaURL] as? URL
                
                print(url)
                
                VideoMediaUrl = url
                imgVideoThumb = HelpingMethods.sharedInstance.thumbnailForVideoAtURL(url: VideoMediaUrl as NSURL)
            }
            
            
            tblProflieDetails.reloadData()
            
        }
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - PikcerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if Pickervalue == 100
        {
            return arrCityName.count
        }
        else if Pickervalue == 101
        {
            return arrStateName.count
        }
        else if Pickervalue == 102
        {
            return arrCountryList.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if Pickervalue == 100
        {
            return (arrCityName.object(at: row) as AnyObject) as? String
        }
        else if Pickervalue == 101
        {
            return (arrStateName.object(at: row) as AnyObject) as? String
        }
        else if Pickervalue == 102
        {
            return (arrCountryList.object(at: row) as! NSDictionary).object(forKey: "name") as? String
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if Pickervalue == 100
        {
            txtCity.text = (arrCityName.object(at: row) as AnyObject) as? String
        }
        else if Pickervalue == 101
        {
            txtState.text = (arrStateName.object(at: row) as AnyObject) as? String
        }
        else if Pickervalue == 102
        {
            txtCountry.text = (arrCountryList.object(at: row) as! NSDictionary).object(forKey: "name") as? String
            
            selectedIndex = row
            
        }
    }
    
    
    //MARK:- UpdateProfile Api
    
    func UpdateProfileAPI()  {
        
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")

        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        parameters.setObject(strFirstName, forKey: "first_name" as NSCopying)
        parameters.setObject(strLastName, forKey: "last_name" as NSCopying)
        parameters.setObject(dictUserData.object(forKey: "email")as! String, forKey: "email" as NSCopying)
        parameters.setObject(strCity, forKey: "city" as NSCopying)
        parameters.setObject(strState, forKey: "state" as NSCopying)
       
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)

        if(self.selectedIndex != -1)
        {
             parameters.setObject(NSString.init(format: "%d", ((arrCountryList.object(at: selectedIndex) as! NSDictionary).object(forKey: "id") as? Int)!), forKey: "country_id" as NSCopying)
        }
        else
        {
            let strCountryID = NSString(format:"%d",self.dictUserData.object(forKey: "country_id")as! Int)
            
            parameters.setObject(strCountryID , forKey: "country_id" as NSCopying)
            
            
        }
        
        parameters.setObject(strMobileNumber, forKey: "mobile_number" as NSCopying)
        
        parameters.setObject(strDOB, forKey: "dob" as NSCopying)
        
        parameters.setObject(self.dictUserData.object(forKey: "username")as! NSString, forKey: "username" as NSCopying)
        
        parameters.setObject(strPostalCode, forKey: "zipCode" as NSCopying)
        
        parameters.setObject(strGender, forKey: "gender" as NSCopying)
        
        parameters.setObject(strAdress, forKey: "address" as NSCopying)
        
        //shipping address same
        if(isAdressSelected)
        {
            parameters.setObject("1", forKey: "is_shipping_address_same" as NSCopying)
        }
        else
        {
            parameters.setObject("0", forKey: "is_shipping_address_same" as NSCopying)
        }
        
        //PERSONAL INFORMATION
        parameters.setObject(strInspiration, forKey: "inspiration" as NSCopying)
        parameters.setObject(strEducation, forKey: "education" as NSCopying)
        parameters.setObject(strBiography, forKey: "biography" as NSCopying)
        
        //PROFESSIONAL INFORMATION
        parameters.setObject(strCompanyName, forKey: "companyName" as NSCopying)
        parameters.setObject(strWebsite, forKey: "website" as NSCopying)
        
        //SOCIAL MEDIA
        parameters.setObject(strInstagram, forKey: "instagram" as NSCopying)
        parameters.setObject(strFacebook, forKey: "facebook" as NSCopying)
        parameters.setObject(strTwitter, forKey: "twitter" as NSCopying)
        parameters.setObject(strGooglePlus, forKey: "googlePlus" as NSCopying)
        parameters.setObject(strPinterest, forKey: "pinterest" as NSCopying)
        parameters.setObject(strTumblr, forKey: "tumblr" as NSCopying)
        parameters.setObject(strYoutube, forKey: "youTube" as NSCopying)
        
        
        //profile visibilty
        if(isProfileVisibilty)
        {
            parameters.setObject("1", forKey: "profileVisibility" as NSCopying)
        }
        else
        {
            parameters.setObject("0", forKey: "profileVisibility" as NSCopying)
        }
        
        
        
        if(self.ImgData.length > 0)
        {
             parameters.setObject("", forKey: "image" as NSCopying)
        }
        
        if(self.ImgBgData.length > 0)
        {
            parameters.setObject("", forKey: "backgroung_picture" as NSCopying)
        }
        
        
        if VideoMediaUrl != nil
        {
            parameters.setObject("", forKey: "video" as NSCopying)
            parameters.setObject("", forKey: "videoThumbnail" as NSCopying)
        }
        
        print("sending data : \(parameters)")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        
        let  url  = String(format: "%@editProfileSave", kSkeuomoMainURL)
        manager.post(url as String, parameters: parameters, constructingBodyWith:{ (fromData)in/*fromData : AFMultipartFormData) in*/
            if(self.ImgData.length > 0)
            {
                fromData.appendPart(withFileData: self.ImgData as Data, name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            if (self.ImgBgData.length > 0)
            {
                fromData.appendPart(withFileData: self.ImgBgData as Data, name: "backgroung_picture", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
            if self.VideoMediaUrl != nil
            {
                let data = NSData(contentsOf: self.VideoMediaUrl)
                print(Float((data?.length)!)/1024.0/1024.0)
                fromData.appendPart(withFileData: data! as Data, name: "video", fileName: "video.mov", mimeType: "video/mov")
                
                let dataVideoThumb = UIImageJPEGRepresentation(self.imgVideoThumb, 0.7)
                fromData.appendPart(withFileData: dataVideoThumb! , name: "videoThumbnail", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
        },progress:nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            DispatchQueue.main.async
                {
                    HelpingMethods.sharedInstance.hideHUD()
                    
                    print((responseObject as! NSDictionary))
                    
                    if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                    {
                        if self.fromSideMenu == "FromSideMenu"
                        {
                            self.appDelegate.sideMenuController.openMenu()
                        }
                        else
                        {
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UPDATE_USER_PROFILE"), object: nil)
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
