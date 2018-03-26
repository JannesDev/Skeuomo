//
//  AucationArtWorkScreen.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 16/10/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import MobileCoreServices
import AFNetworking

class AucationArtWorkScreen: UIViewController, UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, TOCropViewControllerDelegate
{
    
    @IBOutlet weak var pickerDataSet: UIPickerView!
    @IBOutlet var viewPickerview: UIView!
    @IBOutlet var toolBarDone:UIToolbar!
    @IBOutlet weak var tblPostArtWork: UITableView!

    var arrBidsName : NSArray!
    var arrSubjects = NSArray()
    var arrGenre = NSArray()
    var arrMood = NSArray()
    var arrMedium = NSArray()
    var arrDuration = NSArray()

    var imgOriginal : UIImage!
    var imgData = Data()
    var imgThumb = Data()

    var strArtworkTitle = ""
    var strArtworkPrice = ""
    var isAddedToPrivateGallery = false
    var isShareOnSocialMedia = false
    var strSubject = ""
    var strGenre = ""
    var strMood = ""
    var strMedium = ""
    var strBidDuration = ""

    var strDescription = ""
    var strArtworkSize = ""


    var strSelectedPickerType = ""
    var selectedIndexPicker = 0
    
    var refTxtDes : UITextView!
    var refLblWord : UILabel!
    
    @IBOutlet weak var imgThemeBG: UIImageView!
    
    var dicAuctionDetail = NSDictionary()
    
    var strAuctionImgUrl = ""
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: NSNotification.Name.UITextViewTextDidChange,
                                               object: nil)
        
        arrBidsName = ["Artwork Title","Select Subject", "Select Genre", "Select Medium", "Select Mood","Bid Duration"]
        
        arrSubjects = ["Aboriginal","African","American","Canadian","Celtic","Chinese","Egyptian","Etruscan","Greek","German","French","Irish","Islamic","Japanese","Jewish","Korean","Persian","Spanish","Indian","Latin","Russian","Island","Other"]
        
        arrGenre = ["Abstract","Art Deco","Representational","History","Portrait","Landscape","Still Life","Realism","Figurative","Caricature","Graffiti","Panorama","Architecture","Animation","Mythological","Symbolic","Other"]
        
        arrMedium = ["Fine Art","Visual Art","Decorative Art","Craft","Digital","Calligraphy","Assemblage","Ceramics","Collage","Drawing","Metalwork","Mosaic","Painting","Photography","Printmaking","Sculpture","Glass","Tapestry","Other"]
        
        arrDuration = ["1-Week","2-Week","3-Week","4-Week"]

        arrMood = ["Happy","Silly","Loving","Sad","Fierce","Weird","Shocking","Relaxing","Angry","Blah","Calming","Chaotic","Accepting","Anxious","Exciting","Devious","Flirty","Apathetic","Alone","Jealous","Hopeful","Grateful","Lazy","Smart","Touching","Sleepy"]
        
        // Do any additional setup after loading the view.
        
        if dicAuctionDetail.allKeys.count > 0 {
            
             print(dicAuctionDetail)
            
            strArtworkTitle = dicAuctionDetail.object(forKey: "title") as! String
            strDescription = dicAuctionDetail.object(forKey: "description") as! String
            strSubject = dicAuctionDetail.object(forKey: "subject") as! String
            strGenre = dicAuctionDetail.object(forKey: "genre") as! String
            strMedium = dicAuctionDetail.object(forKey: "medium") as! String
            strMood = dicAuctionDetail.object(forKey: "mood") as! String
            
            strArtworkPrice = dicAuctionDetail.valueForNullableKey(key: "price")
            strArtworkSize = dicAuctionDetail.object(forKey: "size") as! String
            
            strBidDuration = dicAuctionDetail.object(forKey: "bidDuration") as! String
            
            strAuctionImgUrl = dicAuctionDetail.object(forKey: "auctionImage") as! String
            
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
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Button Methods
    
    @IBAction func btnCancelPickerView(_ sender: AnyObject)
    {
        viewPickerview.removeFromSuperview()
    }
    
    @IBAction func btnDonePickerView(_ sender: AnyObject)
    {
        viewPickerview.removeFromSuperview()
        
        if strSelectedPickerType == "Genre"
        {
            strGenre =  arrGenre.object(at: selectedIndexPicker) as! String
        }
        else if strSelectedPickerType == "Subject"
        {
            strSubject = arrSubjects.object(at: selectedIndexPicker) as! String
        }
        else if strSelectedPickerType == "Mood"
        {
            strMood =  arrMood.object(at: selectedIndexPicker) as! String
        }
        else if strSelectedPickerType == "Duration"
        {
            strBidDuration =  arrDuration.object(at: selectedIndexPicker) as! String
        }
        else
        {
            strMedium = arrMedium.object(at: selectedIndexPicker) as! String
        }
        
        tblPostArtWork.reloadData()
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnPostNow(_ sender: UIButton)
    {
        
        self.view.endEditing(true)
        
        
        if imgData.count == 0 && dicAuctionDetail.allKeys.count == 0
        {
        
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please select Art Image", strSubtitle: "", controller: self)
            return
            
        }
        
       else if strArtworkTitle == "" {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please enter Title", strSubtitle: "", controller: self)
            return
        }
        else  if strSubject == "" {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please select Subject", strSubtitle: "", controller: self)
            return
        }
        else  if strGenre == "" {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please select Genre", strSubtitle: "", controller: self)
            return
        }
        else  if strMedium == "" {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please select Medium", strSubtitle: "", controller: self)
            return
        }
        else  if strMood == "" {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please select Mood", strSubtitle: "", controller: self)
            return
        }
        else  if strBidDuration == "" {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please select Bid Duration", strSubtitle: "", controller: self)
            return
        }
        else  if strDescription == "" {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please enter Descriptions", strSubtitle: "", controller: self)
            
            return
        }
        else  if strDescription.characters.count <  250 {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Description must be atleast 250 characters", strSubtitle: "", controller: self)
            return
        }
        else  if strArtworkPrice == "" {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please enter Price", strSubtitle: "", controller: self)
            return
        }
        else  if strArtworkSize == ""
        {
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please enter Size", strSubtitle: "", controller: self)
            return
        }
        
        HelpingMethods.sharedInstance.ShowHUD()
        
        if dicAuctionDetail.allKeys.count > 0
        {
            self.performSelector(inBackground: #selector(EditArtwork), with: nil)
        }
        else
        {
            self.performSelector(inBackground: #selector(AuctionArtWork), with: nil)
        }
    }
    
    @IBAction func btnClickedDone()
    {
        self.view.endEditing(true)
    }

    func textDidChange()
    {
        let text = refTxtDes.text
        
        if((text?.characters.count)! > 0)
        {
            if(refTxtDes.text == "Enter here about me.")
            {
                refLblWord.text = "(0/5000 characters)"
            }
            else if(refTxtDes.text.characters.count <= 5000)
            {
                refLblWord.text = NSString(format: "(%d/5000 characters)", refTxtDes.text.characters.count) as String;
            }
            
        }
    }
    
    //MARK: - UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 2
        {
            return arrBidsName.count
        }
        else if section == 4
        {
            return 2
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
        else if indexPath.section == 3
        {
            return 106
        }
        else
        {
            return 70
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
            
            if imgThumb.count > 0
            {
                cell?.imgCreateBid.image = UIImage.init(data: imgThumb)
            }
            else
            {
                let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,strAuctionImgUrl)
                
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
            
            
            cell?.btnUploadImg.addTarget(self, action: #selector(btnOpenCamera(sender:)), for: .touchUpInside)
            cell?.btnUploadImg.tag = 111
            
            return cell!
            
        }
        else if indexPath.section == 2 || indexPath.section == 4
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
            cell?.btnAero.isHidden = true
            
            cell?.txtCreateBid.delegate = self
            cell?.txtCreateBid.inputAccessoryView = toolBarDone
            
            
            if indexPath.section == 2
            {
                cell?.lblCreateBids.text = arrBidsName.object(at: indexPath.row)as? String
                
                if indexPath.row == 0
                {
                    cell?.txtCreateBid.placeholder = "Title"
                    cell?.txtCreateBid.text = strArtworkTitle
                    cell?.txtCreateBid.tag = 1
                }
                else if indexPath.row == 1
                {
                    cell?.txtCreateBid.placeholder = "Aboriginal"
                    cell?.lblSeprator.isHidden = false
                    cell?.btnAero.isHidden = false
                    
                    cell?.txtCreateBid.text = strSubject
                    cell?.txtCreateBid.tag = 2
                    
                }
                else if indexPath.row == 2
                {
                    cell?.txtCreateBid.placeholder = "Abstract"
                    cell?.lblSeprator.isHidden = false
                    cell?.btnAero.isHidden = false
                    
                    cell?.txtCreateBid.text = strGenre
                    cell?.txtCreateBid.tag = 3
                    
                }
                else if indexPath.row == 3
                {
                    cell?.txtCreateBid.placeholder = "Fine Art"
                    cell?.lblSeprator.isHidden = false
                    cell?.btnAero.isHidden = false
                    
                    cell?.txtCreateBid.text = strMedium
                    cell?.txtCreateBid.tag = 4
                }
                else if indexPath.row == 4
                {
                    cell?.txtCreateBid.placeholder = "Happy"
                    cell?.lblSeprator.isHidden = false
                    cell?.btnAero.isHidden = false
                    
                    cell?.txtCreateBid.text = strMood
                    cell?.txtCreateBid.tag = 5
                    
                }
                else if indexPath.row == 5
                {
                    cell?.txtCreateBid.placeholder = "1-Week"
                    cell?.lblSeprator.isHidden = false
                    cell?.btnAero.isHidden = false
                    
                    cell?.txtCreateBid.text = strBidDuration
                    cell?.txtCreateBid.tag = 8
                    
                }
            }
            else
            {
                
                if indexPath.row == 0
                {
                    cell?.lblCreateBids.text = "STARTING PRICE ($)"
                    
                    cell?.txtCreateBid.placeholder = "$ Enter Price"
                    cell?.txtCreateBid.keyboardType = .numberPad
                    
                    cell?.txtCreateBid.text = strArtworkPrice
                    cell?.txtCreateBid.tag = 6
                }
                    
                else if indexPath.row == 1
                {
                    cell?.lblCreateBids.text = "SIZE"
                    
                    cell?.txtCreateBid.placeholder = "Enter Size"
                    cell?.txtCreateBid.keyboardType = .default
                    
                    cell?.txtCreateBid.text = strArtworkSize
                    cell?.txtCreateBid.tag = 7
                    
                }
                
            }
            
            return cell!
            
        }
        else
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
            cell?.txtViewDescription.placeholder = "Type Description"
            cell?.txtViewDescription.text = strDescription
            
            refTxtDes = cell?.txtViewDescription
            refLblWord = cell?.lblDesLength
            
            
            cell?.lblDesLength.text = NSString(format: "(%d/5000 characters)", strDescription.characters.count) as String

            
            cell?.txtViewDescription.inputAccessoryView = toolBarDone
            
            
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
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            
            let picker = UIImagePickerController()
            picker.delegate = self
            
            picker.allowsEditing = false
            
            picker.sourceType = UIImagePickerControllerSourceType.camera
            
            
            picker.mediaTypes = [kUTTypeImage as String]
            
            
            picker.modalPresentationStyle = .fullScreen
            present(picker,
                    animated: true,
                    completion: nil)
        }
        else
        {
            appDelegate.ShowAlert(message: "No Camera Found")
        }
        
    }
    
    func photoLibrary()
    {
        // let myPickerController = UIImagePickerController()
        
        
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        picker.mediaTypes = [kUTTypeImage as String]
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - UIImagePicker Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
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
            
            print("Custom Size",customimage.size)
            
            
            let toViewEDit = TOCropViewController(image: customimage)
            toViewEDit?.rotateButtonsHidden = true
            toViewEDit?.rotateClockwiseButtonHidden = false
            toViewEDit?.defaultAspectRatio = TOCropViewControllerAspectRatio.ratio3x4
            toViewEDit?.delegate = self
            self.present(toViewEDit!, animated: false, completion: nil)
        }
        
        
        
        
        
       // tblPostArtWork.reloadData()
    }
    
    func cropViewController(_ cropViewController: TOCropViewController!, didCropTo image: UIImage!, with cropRect: CGRect, angle: Int)
    {
        
        cropViewController.dismiss(animated: true, completion: nil)

        let imgCropped = image
        
        print("Custom Size",imgCropped?.size)
        
        imgData = UIImageJPEGRepresentation(imgOriginal!, 0.8)!

        imgThumb = UIImageJPEGRepresentation(imgCropped!, 0.8)!
        
        tblPostArtWork.reloadData()
        
       // let Vframe:CGRect = self.view.convertRect(imgVIew!.frame, toView: self.navigationController?.view)
        
        
//        cropViewController.dismissAnimated(fromParentViewController: self, toFrame: Vframe) {
//        }
        
    }
    
    //MARK: - TextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 2 ||  textField.tag == 3 ||  textField.tag == 4 ||  textField.tag == 5 ||  textField.tag == 8
        {
            
            self.view.endEditing(true)
            
            if textField.tag == 2
            {
                strSelectedPickerType = "Subject"
            }
            else if textField.tag == 3
            {
                strSelectedPickerType = "Genre"
            }
            else if textField.tag == 4
            {
                strSelectedPickerType = "Medium"
            }
            else if textField.tag == 5
            {
                strSelectedPickerType = "Mood"
            }
            else if textField.tag == 8
            {
                strSelectedPickerType = "Duration"
            }
            
            reloadPicker()
            
            self.view.addSubview(viewPickerview)
            
            viewPickerview.frame = self.view.frame
            
            return false
        }
        
        return true
    }
    
    func reloadPicker()
    {
        selectedIndexPicker = 0
        pickerDataSet.reloadAllComponents()
        pickerDataSet.selectRow(selectedIndexPicker, inComponent: 0, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text! == "" &&  string == " " {
            
            return false
            
        }
        
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 1
        {
            strArtworkTitle = textField.text!
        }
        else if textField.tag == 6
        {
            strArtworkPrice = textField.text!
        }
        else if textField.tag == 7
        {
            strArtworkSize = textField.text!
        }
    }
    
    //MARK: - TextViewDelegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        strDescription = textView.text!
    }
    
    //MARK: - PikcerView DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        
        if strSelectedPickerType == "Genre"
        {
            return arrGenre.count
        }
        else if strSelectedPickerType == "Subject"
        {
            return arrSubjects.count
        }
        else if strSelectedPickerType == "Mood"
        {
            return arrMood.count
        }
        else if strSelectedPickerType == "Medium"
        {
            return arrMedium.count
        }
        else if strSelectedPickerType == "Duration"
        {
            return arrDuration.count
        }
        else
        {
            return 0
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        if strSelectedPickerType == "Genre"
        {
            return arrGenre.object(at: row) as? String
        }
        else if strSelectedPickerType == "Subject"
        {
            return arrSubjects.object(at: row) as? String
        }
        else if strSelectedPickerType == "Mood"
        {
            return arrMood.object(at: row) as? String
        }
        else if strSelectedPickerType == "Duration"
        {
            return arrDuration.object(at: row) as? String
        }
        else
        {
            return arrMedium.object(at: row) as? String
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedIndexPicker = row
    }
    
    //MARK: - Webservice Methods
    
    func AuctionArtWork()
    {
        
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        manager.requestSerializer.timeoutInterval = 500
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        parameters.setObject(strArtworkTitle, forKey: "title" as NSCopying)
        parameters.setObject(strArtworkPrice, forKey: "price" as NSCopying)
        parameters.setObject(strArtworkSize, forKey: "size" as NSCopying)
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        parameters.setObject(strSubject, forKey: "subject" as NSCopying)
        parameters.setObject(strGenre, forKey: "genre" as NSCopying)
        parameters.setObject(strMood, forKey: "mood" as NSCopying)
        parameters.setObject(strMedium, forKey: "medium" as NSCopying)
        parameters.setObject(strBidDuration, forKey: "bidDuration" as NSCopying)
        parameters.setObject(strDescription, forKey: "description" as NSCopying)
        
        
        if imgData.count > 0
        {
            parameters.setObject("", forKey: "artworkImage" as NSCopying)
            
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
        
        
        let  url  = String(format: "%@auction/create", kSkeuomoMainURL)
        manager.post(url as String, parameters: parameters, constructingBodyWith:{ (fromData)in/*fromData : AFMultipartFormData) in*/
            
            if(self.imgData.count > 0)
            {
                fromData.appendPart(withFileData: self.imgData as Data, name: "artworkImage", fileName: "image.jpeg", mimeType: "image/jpeg")
                
                
                fromData.appendPart(withFileData: self.imgThumb as Data, name: "thumbnail", fileName: "image.jpeg", mimeType: "image/jpeg")

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
    
    func EditArtwork()
    {
        
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        manager.requestSerializer.timeoutInterval = 500
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        parameters.setObject(strArtworkTitle, forKey: "title" as NSCopying)
        parameters.setObject(strArtworkPrice, forKey: "price" as NSCopying)
        parameters.setObject(strArtworkSize, forKey: "size" as NSCopying)
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        
        let strAuctionID = String(format: "%d", dicAuctionDetail.object(forKey: "id") as! Int)
        parameters.setObject(strAuctionID, forKey: "id" as NSCopying)
        parameters.setObject(strSubject, forKey: "subject" as NSCopying)
        parameters.setObject(strGenre, forKey: "genre" as NSCopying)
        parameters.setObject(strMood, forKey: "mood" as NSCopying)
        parameters.setObject(strMedium, forKey: "medium" as NSCopying)
        parameters.setObject(strBidDuration, forKey: "bidDuration" as NSCopying)
        parameters.setObject(strDescription, forKey: "description" as NSCopying)
        
        if imgData.count > 0
        {
            parameters.setObject("", forKey: "artworkImage" as NSCopying)
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

        let  url  = String(format: "%@auction/edit?id=%@", kSkeuomoMainURL,strAuctionID)
        
        print("API URL: ",url)
        
        manager.post(url as String, parameters: parameters, constructingBodyWith:{ (fromData)in/*fromData : AFMultipartFormData) in*/
            
            if(self.imgData.count > 0)
            {
                fromData.appendPart(withFileData: self.imgData as Data, name: "artworkImage", fileName: "image.jpeg", mimeType: "image/jpeg")
                
                
                fromData.appendPart(withFileData: self.imgThumb as Data, name: "thumbnail", fileName: "image.jpeg", mimeType: "image/jpeg")
                
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
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UPDATEMYAUCTIONLIST"), object: nil)
                            
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
