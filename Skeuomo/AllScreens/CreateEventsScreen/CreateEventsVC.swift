//
//  CreateEventsVC.swift
//  Skeuomo
//
//  Created by by Jannes on 23/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking


class MDTextField: UITextField
{
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool
    {
        if action == #selector(UIResponderStandardEditActions.paste(_:))
        {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}


class CreateEventsVC: UIViewController, UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate,TOCropViewControllerDelegate,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var arrBidsName : NSArray!
    var arrTimePrice : NSArray!
    var arrEventDtls : NSArray!
    
    let picker = UIImagePickerController()
    var imgviewPro = UIImageView()
    
    @IBOutlet var toolBarDone:UIToolbar!
    @IBOutlet weak var tblCreateEvents: UITableView!
    @IBOutlet weak var imgThemeBG: UIImageView!
    
    //
    @IBOutlet weak var btnDraft: UIButton!
    @IBOutlet weak var btnPublish: UIButton!
    

    
    @IBOutlet weak var pickerDataSet: UIPickerView!
    @IBOutlet var viewPickerview: UIView!
    
    
    
    var selectedIndexPicker = 0
    var arrEventType : NSArray!
    var lblDescriptionCount : UILabel!
    var lblAdditionalInfoCount : UILabel!
    var strDescriptionCount = "0 / 5000 Words"
    var strAdditionalInfoCount = "0 / 5000 Words"
    
    
    var imgOriginal : UIImage!
    
    var dataOrigionalImage  = Data()
    var dataThumbImage      = Data()
    
    var strEventType = ""
    var strEventName = ""
    var strDescription = ""
    var strAdditionalInfo = ""
    var strAddress = ""
    var strLat = ""
    var strLng = ""

    var strMaxTickets = ""
    var strPrice = ""
    var strStartDateTime = ""
    var strEndDateTime = ""
    var strDateType = ""
    var strSocialSharingStatus = "0"
    var strPicture = ""

    //dob
    @IBOutlet var viewDatePicker            : UIView!
    @IBOutlet var picker_Date               : UIDatePicker!
    var selectDate                          : NSDate!
    var dateFormateSearch                   : DateFormatter!
    var dateFormateServer             :DateFormatter!
    
    var dicEventDetail = NSDictionary()
    
    var selectedActionForEvent = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        arrBidsName = ["Event Type","Event Title"]
        arrEventDtls = ["Address"]
        arrTimePrice = ["Select Time", "Price"]
        arrEventType = ["Free","Paid","Fundraiser"]
        
        
        //dob
        let now : Date = Date()
        //let date : Date = self.logicalOneYearAgo(from: now)
        let components = NSDateComponents()
        components.year = 1900
        // picker_Date.minimumDate = Calendar.current.date(from: components as DateComponents)
        picker_Date.minimumDate = now
        picker_Date.date = now
        dateFormateSearch  = DateFormatter()
        dateFormateSearch.dateFormat = "dd/MM/YYYY HH:mm:ss"
        
        dateFormateServer  = DateFormatter()
        dateFormateServer.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAddress(_:)), name: NSNotification.Name(rawValue: kSkeuomoUpdateEventAddress), object: nil)
        
        
        if dicEventDetail.allKeys.count > 0 {
            
            print(dicEventDetail)
            
            strEventType = dicEventDetail.object(forKey: "event_type") as! String
            strEventName = dicEventDetail.object(forKey: "name") as! String
            strDescription = dicEventDetail.object(forKey: "description") as! String
            strAdditionalInfo = dicEventDetail.object(forKey: "addtional_information") as! String
            
            strAdditionalInfo = dicEventDetail.object(forKey: "addtional_information") as! String
            strAddress = dicEventDetail.object(forKey: "address") as! String
            strLat = dicEventDetail.object(forKey: "latitude") as! String
            strLng = dicEventDetail.object(forKey: "longitude") as! String

            let strStartTime = dicEventDetail.object(forKey: "event_start_date") as! String
            
            let startDate = dateFormateServer.date(from: strStartTime)
            
            strStartDateTime = dateFormateSearch.string(from: startDate!)
            
            
            let strEndTime = dicEventDetail.object(forKey: "event_end_date") as! String
            
            let EndDate = dateFormateServer.date(from: strEndTime)
                
            strEndDateTime = dateFormateSearch.string(from: EndDate!)

            strMaxTickets = dicEventDetail.valueForNullableKey(key: "max_tickets")

            strPrice = dicEventDetail.valueForNullableKey(key: "price")
            
            
            strPicture = dicEventDetail.object(forKey: "picture") as! String
            
            
            if dicEventDetail.valueForNullableKey(key: "is_socialShare") == "" || dicEventDetail.valueForNullableKey(key: "is_socialShare") == "0"
            {
                strSocialSharingStatus = "0"
            }
            else
            {
                strSocialSharingStatus = "1"
            }
            
            
            if dicEventDetail.valueForNullableKey(key: "status") == "1"
            {
                btnDraft.isHidden = true
                
                DispatchQueue.main.async
                    {
                    
                        self.btnPublish.frame = CGRect(x: 10, y: self.view.frame.size.height - 50, width: self.view.frame.size.width - 20, height: 42)

                }
                
                
            }
            
        }
        
        
    }
    
    func updateAddress(_ noti:Notification)
    {
        if noti.object != nil
        {
            let dicPickupLocation = noti.object as! NSDictionary
            print(dicPickupLocation)
            strAddress = dicPickupLocation.object(forKey: "location") as! String
            strLat = dicPickupLocation.object(forKey: "latitude") as! String
            strLng = dicPickupLocation.object(forKey: "longitude") as! String

            tblCreateEvents.reloadData()
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
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - ButtonsMethods
    @IBAction func btnBack(_ sender: Any)
    {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if sender.tag == 111
        {
            selectedActionForEvent = "draft"
        }
        else
        {
            selectedActionForEvent = "publish"
        }
        
        let dtStart = dateFormateSearch.date(from: strStartDateTime)
        let dtEnd = dateFormateSearch.date(from: strEndDateTime)
        
        if dataOrigionalImage.count == 0 && dicEventDetail.allKeys.count == 0
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please Add Event Image", controller: self)
        }
        else if strEventType.isEmpty == true
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please select Event Type", controller: self)
        }
        else if strEventName.isEmpty == true
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter Event Title", controller: self)
        }
        else if strDescription.isEmpty == true
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter Event Description", controller: self)
        }
        else if strDescription.characters.count < 250
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Description must be at least 250 characters.", controller: self)
        }
        else if strAdditionalInfo.isEmpty == true
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter Additional Information ", controller: self)
        }
        else if strAdditionalInfo.characters.count < 250
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "The Addtional Information must be at least 250 characters.", controller: self)
        }
        else if strAddress.isEmpty == true
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter your Address", controller: self)
        }
        else if dicEventDetail.allKeys.count == 0 && dtEnd! < dtStart!
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "The event end date must be a date after or equal to event start date.", controller: self)
        }
        else if strEventType.lowercased() == "free"
        {
            if strMaxTickets.isEmpty == true
            {
                HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter Maximum Tickets", controller: self)
            }
                
            else
            {
                print("success")
                
                HelpingMethods.sharedInstance.ShowHUD()
                
                if dicEventDetail.allKeys.count > 0 {
                    
                    self.performSelector(inBackground: #selector(EditEvent), with: nil)

                }
                else
                {
                    self.performSelector(inBackground: #selector(AddEvent), with: nil)

                }
            }

        }
        else
        {
            if strMaxTickets.isEmpty == true
            {
                HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter Maximum Tickets", controller: self)
            }
            else if strPrice.isEmpty == true
            {
                HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter Price", controller: self)
            }
            else
            {
                print("success")
                
                HelpingMethods.sharedInstance.ShowHUD()
                
                if dicEventDetail.allKeys.count > 0 {
                    
                    self.performSelector(inBackground: #selector(EditEvent), with: nil)
                    
                }
                else
                {
                    self.performSelector(inBackground: #selector(AddEvent), with: nil)
                    
                }
            }

        }
        
    }
    @IBAction func btnClickedDone()
    {
        self.view.endEditing(true)
    }
    
    @IBAction func btnCancelPickerView(_ sender: AnyObject)
    {
        viewPickerview.removeFromSuperview()
    }
    
    @IBAction func btnDonePickerView(_ sender: AnyObject)
    {
        viewPickerview.removeFromSuperview()
        
        strEventType =  arrEventType.object(at: selectedIndexPicker) as! String
        tblCreateEvents.reloadData()
    }
    
    @IBAction func btn_SocialShare(_sender : UIButton)
    {
        _sender.isSelected = !_sender.isSelected
        
        if _sender.isSelected == true
        {
            strSocialSharingStatus = "1"
        }
        else
        {
            strSocialSharingStatus = "0"
        }
        
        
    }
    
    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        if section == 2
        {
            return arrBidsName.count
        }
        else if section == 5
        {
            return arrEventDtls.count
        }
        else if section == 7
        {
            if strEventType.lowercased() == "free" ||  strEventType == ""
            {
                return 1
            }
                
            else
            {
                return 2
            }
        }
        else
        {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 310
        }
        else if indexPath.section == 1
        {
            return 48
        }
        else if indexPath.section == 2 || indexPath.section == 5 || indexPath.section == 7
        {
            return 70
        }
        else if indexPath.section == 6
        {
            return 75
        }
        else if indexPath.section == 9
        {
            return 56
        }
        else
        {
            return 106
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cellIdentifier:String = "BidsImgTblCell"
            var cell:BidsImgTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? BidsImgTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("BidsImgTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? BidsImgTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            if dataOrigionalImage.count > 0
            {
                cell?.imgCreateBid.image = UIImage.init(data: dataOrigionalImage)
            }
            else
            {
                let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,strPicture)
                
                let urlImage = URL.init(string: urlStr as String)
                
                cell?.imgCreateBid.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"placeholder.png"))
            }
            
            return cell!
            
        }
        else if indexPath.section == 1
        {
            let cellIdentifier:String = "BidUploadBtnTblCell"
            var cell:BidUploadBtnTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? BidUploadBtnTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("BidUploadBtnTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? BidUploadBtnTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
           cell?.btnUploadImg.setTitle("Upload Your Event Image", for: .normal)
            cell?.btnUploadImg.addTarget(self, action: #selector(btnOpenCamera), for: .touchUpInside)
            
            return cell!
            
        }
        else if indexPath.section == 2 || indexPath.section == 5  || indexPath.section == 7
        {
            let cellIdentifier:String = "CreateBidsTblCell"
            var cell:CreateBidsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CreateBidsTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("CreateBidsTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? CreateBidsTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            cell?.vieTitleBG.layer.cornerRadius = 2.0
            cell?.vieTitleBG.layer.borderWidth = 1.0
            cell?.vieTitleBG.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
            cell?.lblSeprator.isHidden = true
            
            cell?.txtCreateBid.delegate = self
            
            if dicEventDetail.allKeys.count > 0 && dicEventDetail.valueForNullableKey(key: "status") == "1"
            {
                cell?.txtCreateBid.isUserInteractionEnabled = false
            }
            
            
            if indexPath.section == 2
            {
                cell?.lblCreateBids.text = arrBidsName.object(at: indexPath.row)as? String
                
                if indexPath.row == 0
                {
                    cell?.txtCreateBid.text = strEventType
                    cell?.txtCreateBid.placeholder = "Type"

                    cell?.txtCreateBid.tag = 21
                    
                     cell?.btnAero.isHidden = false

                }
                else if indexPath.row == 1
                {
                    cell?.txtCreateBid.text = strEventName
                    cell?.txtCreateBid.placeholder = "Title"
                    cell?.txtCreateBid.tag = 22
                     cell?.btnAero.isHidden = true
                }
            }
          else  if indexPath.section == 7
            {
                cell?.btnAero.isHidden = true
                
                if indexPath.row == 0
                {
                    cell?.lblCreateBids.text = "Maximum Tickets"
                    
                    cell?.txtCreateBid.placeholder = "No. of Tickets"
                    cell?.txtCreateBid.keyboardType = .phonePad
                    cell?.txtCreateBid.delegate = self
                    cell?.txtCreateBid.text = strMaxTickets
                    cell?.txtCreateBid.tag = 71
                    
                    cell?.txtCreateBid.inputAccessoryView = toolBarDone
                }
                else if indexPath.row == 1
                {
                    
                    if strEventType.lowercased() == "paid"
                    {
                        cell?.lblCreateBids.text = "Ticket Price ($)"
                    }
                    else if strEventType.lowercased() == "fundraiser"
                    {
                        cell?.lblCreateBids.text = "Goal Price ($)"
                    }
                    
                    cell?.txtCreateBid.placeholder = "$ Enter Price"
                    cell?.txtCreateBid.keyboardType = .phonePad
                    cell?.txtCreateBid.delegate = self
                    cell?.txtCreateBid.text = strPrice
                    cell?.txtCreateBid.tag = 72

                    cell?.txtCreateBid.inputAccessoryView = toolBarDone
                }
            }
            else
            {
                cell?.lblCreateBids.text = arrEventDtls.object(at: indexPath.row)as? String
                
                if indexPath.row == 0
                {
                    cell?.txtCreateBid.placeholder = "Type Address"
                    cell?.txtCreateBid.delegate = self
                    cell?.txtCreateBid.text = strAddress
                    cell?.txtCreateBid.tag = 51
                    cell?.btnAero.isHidden = true
                }
            }
            return cell!
            
        }
        else if indexPath.section == 3 || indexPath.section == 4
        {
            let cellIdentifier:String = "BidDescriptionTblCell"
            var cell:BidDescriptionTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? BidDescriptionTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("BidDescriptionTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? BidDescriptionTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            cell?.vieDescriptionBG.layer.cornerRadius = 2.0
            cell?.vieDescriptionBG.layer.borderWidth = 1.0
            cell?.vieDescriptionBG.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
         
            cell?.txtViewDescription.delegate = self
            
            if indexPath.section == 3
            {
                cell?.lblTitle.text = "Description"
                
                cell?.txtViewDescription.placeholder = "Type Description"
                
                cell?.txtViewDescription.tag = 31
                
                cell?.txtViewDescription.text = strDescription
                
                cell?.lblDesLength.text = strDescriptionCount
                self.lblDescriptionCount = (cell?.lblDesLength)!
            }
            else if indexPath.section == 4
            {
                cell?.lblTitle.text = "Additional Information"
                
                cell?.txtViewDescription.placeholder = "Enter Additional Information"
                
                cell?.txtViewDescription.tag = 41
                
                cell?.txtViewDescription.text = strAdditionalInfo
                
                cell?.lblDesLength.text = strAdditionalInfoCount
                self.lblAdditionalInfoCount = (cell?.lblDesLength)!
            }
            
            
            
            return cell!
            
        }
        else if indexPath.section == 8
        {
            let cellIdentifier:String = "SocialTickCell"
            var cell:SocialTickCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SocialTickCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("SocialTickCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? SocialTickCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            
            if dicEventDetail.allKeys.count > 0 && dicEventDetail.valueForNullableKey(key: "status") == "1"
            {
                cell?.btnTick.isUserInteractionEnabled = false
            }
            
            if strSocialSharingStatus == "0"
            {
                cell?.btnTick.isSelected = false
            }
            else
            {
                cell?.btnTick.isSelected = true
            }
            
            cell?.btnTick.addTarget(self, action: #selector(btn_SocialShare(_sender:)), for: .touchUpInside)
            
            return cell!
        }
        else
        {
            let cellIdentifier:String = "DateTimeTblCell"
            var cell:DateTimeTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DateTimeTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("DateTimeTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? DateTimeTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            cell?.vieFrom.layer.cornerRadius = 2.0
            cell?.vieFrom.layer.borderWidth = 1.0
            cell?.vieFrom.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
            cell?.vieTo.layer.cornerRadius = 2.0
            cell?.vieTo.layer.borderWidth = 1.0
            cell?.vieTo.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
            
            cell?.txtStartDate.text = strStartDateTime
            cell?.txtStartDate.delegate = self
            cell?.txtStartDate.tag = 61
            
            cell?.txtEndDate.text = strEndDateTime
            cell?.txtEndDate.delegate = self
            cell?.txtEndDate.tag = 62
            
            if dicEventDetail.allKeys.count > 0 && dicEventDetail.valueForNullableKey(key: "status") == "1"
            {
                cell?.txtStartDate.isUserInteractionEnabled = false
                cell?.txtEndDate.isUserInteractionEnabled = false
            }
            
            return cell!
  
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    func btnOpenCamera(sender:UIButton!)
    {
        
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
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,
                    animated: true,
                    completion: nil)
        } else {
            appDelegate.ShowAlert(message: "No Camera Found")
        }
        
    }
    
    func photoLibrary()
    {
        // let myPickerController = UIImagePickerController()
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        imgOriginal = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        print("Original Size",imgOriginal.size)
        
        if imgOriginal.size.width < 750 || imgOriginal.size.height < 400
        {
            
            let actionSheet = UIAlertController(title: nil, message: "The Artwork Image width must be greater than 750px and height must be greater than 400px.", preferredStyle: UIAlertControllerStyle.alert)
            
            actionSheet.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            
            self.present(actionSheet, animated: true, completion: nil)
            
            return
        }
        else
        {
            let customimage = HelpingMethods.sharedInstance.fixedOrientation(img: (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
            
            let toViewEDit = TOCropViewController(image: customimage)
            
            toViewEDit?.rotateButtonsHidden = true
            toViewEDit?.rotateClockwiseButtonHidden = false
            toViewEDit?.defaultAspectRatio = TOCropViewControllerAspectRatio.ratio3x4
            toViewEDit?.delegate = self
            self.present(toViewEDit!, animated: false, completion: nil)
        }
        
    }
    
    
    
    
    
    func cropViewController(_ cropViewController: TOCropViewController!, didCropTo image: UIImage!, with cropRect: CGRect, angle: Int)
    {
        
        cropViewController.dismiss(animated: true, completion: nil)
        
        let imgCropped = image
        
        dataOrigionalImage = UIImageJPEGRepresentation(imgOriginal!, 0.8)!
        
        dataThumbImage = UIImageJPEGRepresentation(imgCropped!, 0.8)!
        
        tblCreateEvents.reloadData()
    }

    // MARK: - TextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        
        let newLength = (textView.text?.characters.count)! + text.characters.count - range.length
        
        if textView.text == "" && text == " " {
            
            return false
        }
            
        else if newLength > 5000
        {
            return false
        }
        
        
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        
        
        let len: Int = textView.text.characters.count
        if textView.tag == 31
        {
            strDescription = textView.text!
            
            lblDescriptionCount.text = "\(len)/ 5000 Words"
            strDescriptionCount = "\(len)/ 5000 Words"
        }
        else
        {
            strAdditionalInfo = textView.text!
            
            lblAdditionalInfoCount.text = "\(len)/ 5000 Words"
            strAdditionalInfoCount = "\(len)/ 5000 Words"
        }
        
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField.tag == 21
        {
            reloadPicker()
            
            viewPickerview.frame = self.view.frame
            
            self.view.addSubview(viewPickerview)
            
            
            
            return false
        }
        else if textField.tag == 61
        {
            strDateType = "from"
            
            self.view.endEditing(true)
            viewDatePicker.frame = self.view.frame
            self.view.addSubview(viewDatePicker)
            
            return false
        }
        else if textField.tag == 62
        {
            strDateType = "to"
            
            self.view.endEditing(true)
            viewDatePicker.frame = self.view.frame
            self.view.addSubview(viewDatePicker)
            
            return false
        }
        else if textField.tag == 51
        {
            let locationVC = SearchLocationScreen(nibName:"SearchLocationScreen",bundle:nil)
            self.navigationController?.pushViewController(locationVC, animated: true)
            
            return false
        }
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField.tag == 22
        {
            strEventName = textField.text!
        }
        else if textField.tag == 51
        {
            strAddress = textField.text!
        }
        else if textField.tag == 71
        {
            strMaxTickets = textField.text!
        }
        else if textField.tag == 72
        {
            strPrice = textField.text!
        }
    }
    
 
    
    func reloadPicker()
    {
        selectedIndexPicker = 0
        pickerDataSet.reloadAllComponents()
        pickerDataSet.selectRow(selectedIndexPicker, inComponent: 0, animated: true)
    }
    
    //MARK: - PikcerView DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return arrEventType.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return arrEventType.object(at: row) as? String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedIndexPicker = row
    }
    
    // MARK: -  DOB tool bar events
    
    @IBAction func method_didFinishPickingDate(_sender:AnyObject)
    {
        self.view.endEditing(true)
        viewDatePicker.removeFromSuperview()
        
        if strDateType == "from"
        {
            strStartDateTime = dateFormateSearch.string(from: picker_Date.date)
        }
        else
        {
            strEndDateTime = dateFormateSearch.string(from: picker_Date.date)
        }
        
        tblCreateEvents.reloadData()
    }
    @IBAction func method_didCancelPickingDate(_sender:AnyObject)
    {
        self.view.endEditing(true)
        viewDatePicker.removeFromSuperview()
        
    }
    
    //MARK: -  API Methods
    
    func AddEvent()
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
        
        parameters.setObject(strEventType.lowercased(), forKey: "event_type" as NSCopying)
        parameters.setObject(strEventName, forKey: "name" as NSCopying)
        parameters.setObject(strDescription, forKey: "description" as NSCopying)
        parameters.setObject(strAdditionalInfo, forKey: "addtional_information" as NSCopying)
        parameters.setObject(strStartDateTime, forKey: "event_start_date" as NSCopying)
        parameters.setObject(strEndDateTime, forKey: "event_end_date" as NSCopying)
        parameters.setObject(strMaxTickets, forKey: "max_tickets" as NSCopying)
        
        parameters.setObject(strSocialSharingStatus, forKey: "is_socialShare" as NSCopying)
        if selectedActionForEvent == "draft"
        {
            parameters.setObject("draft", forKey: "button" as NSCopying)
        }
        
        if strEventType.lowercased() == "free"
        {
            parameters.setObject("1", forKey: "price" as NSCopying)
        }
        else
        {
            parameters.setObject(self.strPrice, forKey: "price" as NSCopying)
        }
        
        parameters.setObject(strAddress, forKey: "address" as NSCopying)
        parameters.setObject(strLat, forKey: "latitude" as NSCopying)
        parameters.setObject(strLng, forKey: "longitude" as NSCopying)

        if dataOrigionalImage.count > 0
        {
            parameters.setObject("", forKey: "picture" as NSCopying)
            parameters.setObject("", forKey: "thumbnail" as NSCopying)

        }
        
        print("sending data : \(parameters)")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        
        print(strforMD5)
        
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@event/create?", kSkeuomoMainURL)
        
        print("AddEvent URL  : \(url)")
        
        manager.post(url as String, parameters: parameters, constructingBodyWith:{ (fromData)in/*fromData : AFMultipartFormData) in*/
            
            if(self.dataOrigionalImage.count > 0)
            {
                fromData.appendPart(withFileData: self.dataOrigionalImage as Data, name: "picture", fileName: "image.jpeg", mimeType: "image/jpeg")
                
                fromData.appendPart(withFileData: self.dataThumbImage as Data, name: "thumbnail", fileName: "image.jpeg", mimeType: "image/jpeg")

                
            }
            
        },progress:nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            DispatchQueue.main.async
                {
                    HelpingMethods.sharedInstance.hideHUD()
                    print((responseObject as! NSDictionary))
                    
                    if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                    {
                        print("Everything is ok now")
                        
                        HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                        
                        
                        _ = self.navigationController?.popViewController(animated: true)
                        
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
    
    func EditEvent()
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
        
        let strEventID = String(format: "%d", dicEventDetail.object(forKey: "id") as! Int)
        
        parameters.setObject(strEventID, forKey: "id" as NSCopying)
        
        parameters.setObject(strEventType.lowercased(), forKey: "event_type" as NSCopying)
        parameters.setObject(strEventName, forKey: "name" as NSCopying)
        parameters.setObject(strDescription, forKey: "description" as NSCopying)
        parameters.setObject(strAdditionalInfo, forKey: "addtional_information" as NSCopying)
        parameters.setObject(strStartDateTime, forKey: "event_start_date" as NSCopying)
        parameters.setObject(strEndDateTime, forKey: "event_end_date" as NSCopying)
        parameters.setObject(strMaxTickets, forKey: "max_tickets" as NSCopying)
        
        parameters.setObject(strSocialSharingStatus, forKey: "is_socialShare" as NSCopying)
        
        
        if strEventType.lowercased() == "free"
        {
            parameters.setObject("1", forKey: "price" as NSCopying)
        }
        else
        {
            parameters.setObject(self.strPrice, forKey: "price" as NSCopying)
        }
        
        parameters.setObject(strAddress, forKey: "address" as NSCopying)
        parameters.setObject(strLat, forKey: "latitude" as NSCopying)
        parameters.setObject(strLng, forKey: "longitude" as NSCopying)
        
        if dataOrigionalImage.count > 0
        {
            parameters.setObject("", forKey: "picture" as NSCopying)
            
        }
        
        if selectedActionForEvent == "draft"
        {
            parameters.setObject("draft", forKey: "button" as NSCopying)
        }
        
        
        print("sending data : \(parameters)")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        
        print(strforMD5)
        
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@event/edit?", kSkeuomoMainURL)
        
        print("AddEvent URL  : \(url)")
        
        manager.post(url as String, parameters: parameters, constructingBodyWith:{ (fromData)in/*fromData : AFMultipartFormData) in*/
            
            if(self.dataOrigionalImage.count > 0)
            {
                fromData.appendPart(withFileData: self.dataOrigionalImage as Data, name: "picture", fileName: "image.jpeg", mimeType: "image/jpeg")
                
                
                fromData.appendPart(withFileData: self.dataThumbImage as Data, name: "thumbnail", fileName: "image.jpeg", mimeType: "image/jpeg")

            }
            
            },progress:nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            print("Everything is ok now")
                            
                            let dicEditedEvent = ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "event") as! NSDictionary
                            
                            
                            
                            
                            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                            
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UPDATEMYEVENTLIST"), object: dicEditedEvent)
                            
                            
                            
                            
                            _ = self.navigationController?.popViewController(animated: true)

                            
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
