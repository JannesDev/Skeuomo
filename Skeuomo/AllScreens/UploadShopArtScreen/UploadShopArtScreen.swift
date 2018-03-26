//
//  UploadShopArtScreen.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 25/12/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

import MobileCoreServices
import AFNetworking


class UploadShopArtScreen: UIViewController, UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, TOCropViewControllerDelegate
{

    @IBOutlet weak var imgThemeBG: UIImageView!

    @IBOutlet weak var pickerDataSet: UIPickerView!
    @IBOutlet var viewPickerview: UIView!
    @IBOutlet var toolBarDone:UIToolbar!
    @IBOutlet weak var tblShopArt: UITableView!
    
    var arrType = NSArray()
    var arrBrand = NSArray()
    
    var imgOriginal : UIImage!
    var imgData = Data()
    var imgThumb = Data()
    
    var strShopArtTitle = ""
    var strShopArtPrice = ""
    var strShopArtQuantity = ""
    var strShopArtSize = ""

    var isFeatured = false
    
    var strType = ""
    var strTypeId = ""

    var strBrand = ""
    var strBrandId = ""

    var strMaterial = ""

    var strDescription = ""
    
    var strSelectedPickerType = ""
    var selectedIndexPicker = 0
    
    var refTxtDes : UITextView!
    var refLblWord : UILabel!
    
    var dicShopArtDetail = NSDictionary()
    
    var strShopArtImgUrl = ""
    
    var arrShippingDetail = NSMutableArray()
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        

        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: NSNotification.Name.UITextViewTextDidChange,
                                               object: nil)

        // Do any additional setup after loading the view.
        
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetShopArtOption), with: nil)
        
        if dicShopArtDetail.allKeys.count > 0
        {
            print(dicShopArtDetail)
            
            strShopArtTitle = dicShopArtDetail.object(forKey: "title") as! String
            strShopArtPrice = dicShopArtDetail.valueForNullableKey(key: "price")
            strShopArtQuantity = dicShopArtDetail.valueForNullableKey(key: "quantity")
            strShopArtSize = dicShopArtDetail.object(forKey: "size") as! String
            strType = dicShopArtDetail.object(forKey: "type") as! String
            strBrand = dicShopArtDetail.object(forKey: "brand") as! String
            strMaterial = dicShopArtDetail.object(forKey: "materials") as! String
            strDescription = dicShopArtDetail.object(forKey: "description") as! String
            strShopArtImgUrl = dicShopArtDetail.object(forKey: "shopartImage") as! String
            
            if dicShopArtDetail.valueForNullableKey(key: "is_featured") == "no"
            {
                isFeatured = false
            }
            else
            {
                isFeatured = true
            }
            
            
            let strShippingDetail = dicShopArtDetail.object(forKey: "shipping") as! String
            
            var array:NSArray?
            
            if let data = strShippingDetail.data(using: String.Encoding.utf8) {
                
                do {
                    array = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray
                    
                    if array != nil && (array?.count)! > 0
                    {
                        arrShippingDetail.addObjects(from: array as! [String])
                    }
                    
                } catch let error as NSError {
                    print(error)

            }
            
            }
            
        }
        else
        {
             arrShippingDetail.add("")
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
    
    
    @IBAction func btnIsFeature(_ sender: UIButton)
    {
        if sender.isSelected
        {
            sender.isSelected = false
            isFeatured = false
        }
        else
        {
            sender.isSelected = true
            isFeatured = true
        }
    }
    
    @IBAction func btnRemoveShippingDetail(_ sender: UIButton)
    {
        
        self.view.endEditing(true)
        
        arrShippingDetail.removeObject(at: sender.tag)
        
        tblShopArt.reloadData()
    }
    
    @IBAction func btnAddMore(_ sender: AnyObject)
    {
        arrShippingDetail.add("")
        
        tblShopArt.reloadData()
    }
    
    @IBAction func btnCancelPickerView(_ sender: AnyObject)
    {
        viewPickerview.removeFromSuperview()
    }
    
    @IBAction func btnDonePickerView(_ sender: AnyObject)
    {
        viewPickerview.removeFromSuperview()
        
        if strSelectedPickerType == "Type"
        {
            strType =  (arrType.object(at: selectedIndexPicker) as! NSDictionary).valueForNullableKey(key: "name")
            
            strTypeId =  (arrType.object(at: selectedIndexPicker) as! NSDictionary).valueForNullableKey(key: "id")
        }
        else
        {
            strBrand = (arrBrand.object(at: selectedIndexPicker) as! NSDictionary).valueForNullableKey(key: "name")
            
            strBrandId = (arrBrand.object(at: selectedIndexPicker) as! NSDictionary).valueForNullableKey(key: "id")
        }
        
        tblShopArt.reloadData()
    }
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnPostNow(_ sender: UIButton)
    {
        
        self.view.endEditing(true)
        
        
        if imgData.count == 0 && dicShopArtDetail.allKeys.count == 0
        {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please select Art Image", strSubtitle: "", controller: self)
            return
            
        }
            
        else if strShopArtTitle == "" {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please enter Title", strSubtitle: "", controller: self)
            return
        }
        else  if strShopArtPrice == "" {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please enter Price", strSubtitle: "", controller: self)
            return
        }
        else  if strShopArtQuantity == "" {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please enter Quantity", strSubtitle: "", controller: self)
            return
        }
        else  if strShopArtSize == "" {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please enter Size", strSubtitle: "", controller: self)
            return
        }
        else  if strType == "" {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please select Type", strSubtitle: "", controller: self)
            return
        }
        else  if strBrand == "" {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please select Brand", strSubtitle: "", controller: self)
            return
        }
        else  if strMaterial == "" {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Please enter Material", strSubtitle: "", controller: self)
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
        else
        {
        
            let arrTempShipping = NSMutableArray()
            
            for obj in arrShippingDetail {
                
                if obj as! String != "" {
                    
                   arrTempShipping.add(obj)
                }
                
            }
            
            if arrTempShipping.count == 0 {
                
                HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter shipping detail", controller: self)
                return
            }
            
        }
        
        
        
        
        HelpingMethods.sharedInstance.ShowHUD()
        
        if dicShopArtDetail.allKeys.count > 0
        {
            self.performSelector(inBackground: #selector(EditArtwork), with: nil)
        }
        else
        {
            self.performSelector(inBackground: #selector(PostShopArt), with: nil)
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
            return 8
        }
        else if section == 4
        {
            return 2 + arrShippingDetail.count
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
        else if indexPath.section == 4
        {
            if indexPath.row == 0
            {
                return 35
            }
            else
            {
                return 40
            }
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
                let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,strShopArtImgUrl)
                
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
            
            cell?.btnUploadImg.setTitle("Upload Product Image", for: .normal)
            
            cell?.btnUploadImg.addTarget(self, action: #selector(btnOpenCamera(sender:)), for: .touchUpInside)
            
            cell?.btnUploadImg.tag = 111
            
            return cell!
            
        }
        else if indexPath.section == 2
        {
            
            if indexPath.row == 4
            {
                let cellIdentifier:String = "ShopArtFeaturedCell"
                var cell:ShopArtFeaturedCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ShopArtFeaturedCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("ShopArtFeaturedCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? ShopArtFeaturedCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                
                cell?.btnFeatured.addTarget(self, action: #selector(btnIsFeature(_:)), for: .touchUpInside)
                
                
                if isFeatured == true {
                    
                    cell?.btnFeatured.isSelected = true
                }
                else
                {
                    cell?.btnFeatured.isSelected = false

                }
                
                
                return cell!
            }
            
            
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
            
            cell?.txtCreateBid.keyboardType = .default
            
            if indexPath.row == 0
            {
                cell?.lblCreateBids.text = "PRODUCT TITLE"
                cell?.txtCreateBid.placeholder = "Title"
                cell?.txtCreateBid.text = strShopArtTitle
                cell?.txtCreateBid.tag = 1
            }
            else if indexPath.row == 1
            {
                cell?.lblCreateBids.text = "PRICE ($)"
                cell?.txtCreateBid.placeholder = "Enter Price"
                cell?.txtCreateBid.text = strShopArtPrice
                
                cell?.txtCreateBid.keyboardType = .decimalPad
                
                cell?.txtCreateBid.tag = 2
                
            }
            else if indexPath.row == 2
            {
                cell?.lblCreateBids.text = "QUANTITY"
                cell?.txtCreateBid.placeholder = "Quantity"
                cell?.txtCreateBid.text = strShopArtQuantity

                cell?.txtCreateBid.keyboardType = .numberPad
                cell?.txtCreateBid.tag = 3
            }
            else if indexPath.row == 3
            {
                cell?.lblCreateBids.text = "SIZE"
                cell?.txtCreateBid.placeholder = "Size"
                
                cell?.txtCreateBid.text = strShopArtSize

                
                cell?.txtCreateBid.tag = 4
            }
                
            else if indexPath.row == 5
            {
                cell?.lblCreateBids.text = "SELECT TYPES"
                cell?.txtCreateBid.placeholder = "Select"
                
                
                cell?.txtCreateBid.text = strType

                
                cell?.lblSeprator.isHidden = false
                cell?.btnAero.isHidden = false
                
                cell?.txtCreateBid.tag = 5
                
            }
            else if indexPath.row == 6
            {
                cell?.lblCreateBids.text = "SELECT BRANDS"
                cell?.txtCreateBid.placeholder = "Select"
                
                
                cell?.txtCreateBid.text = strBrand

                
                cell?.lblSeprator.isHidden = false
                cell?.btnAero.isHidden = false
                
                cell?.txtCreateBid.tag = 6
                
            }
            else if indexPath.row == 7
            {
                cell?.lblCreateBids.text = "MATERIALS"
                cell?.txtCreateBid.placeholder = "Materials"
                
                cell?.txtCreateBid.text = strMaterial
                
                cell?.txtCreateBid.tag = 7
            }
            
            
            return cell!
            
        }
            
        else if indexPath.section == 4
        {
            
            if indexPath.row == 0
            {
                let cellIdentifier:String = "ShopArtShippingStaticCell"
                var cell:ShopArtShippingStaticCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ShopArtShippingStaticCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("ShopArtShippingStaticCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? ShopArtShippingStaticCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                
                return cell!
            }
            else if indexPath.row == arrShippingDetail.count + 1
            {
                let cellIdentifier:String = "ShopArtAddMoreCell"
                var cell:ShopArtAddMoreCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ShopArtAddMoreCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("ShopArtAddMoreCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? ShopArtAddMoreCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                
                cell?.btnAddMore.addTarget(self, action: #selector(btnAddMore(_:)), for: .touchUpInside)
                
                return cell!
            }
            
            let cellIdentifier:String = "ShopArtShippingEntryCell"
            var cell:ShopArtShippingEntryCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ShopArtShippingEntryCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ShopArtShippingEntryCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ShopArtShippingEntryCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            cell?.ViewTitleBG.layer.cornerRadius = 2.0
            cell?.ViewTitleBG.layer.borderWidth = 1.0
            cell?.ViewTitleBG.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
            
            cell?.btnRemove.tag = indexPath.row - 1
            cell?.btnRemove.addTarget(self, action: #selector(btnRemoveShippingDetail(_:)), for: .touchUpInside)
            
            cell?.txtEntry.delegate = self
            cell?.txtEntry.inputAccessoryView = toolBarDone
            
            cell?.txtEntry.keyboardType = .default
            
            cell?.txtEntry.text = arrShippingDetail.object(at: indexPath.row - 1) as? String
            
            if indexPath.row == 1
            {
                cell?.btnRemove.isHidden = true
            }
            else
            {
                cell?.btnRemove.isHidden = false
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
            
            cell?.lblTitle.text = "SHORT DESCRIPTION"
            
            
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
        
        
        
        
        
        // tblPostArtWork.reloadData()
    }
    
    func cropViewController(_ cropViewController: TOCropViewController!, didCropTo image: UIImage!, with cropRect: CGRect, angle: Int)
    {
        
        cropViewController.dismiss(animated: true, completion: nil)
        
        let imgCropped = image
        
        print(imgCropped?.size)
        
        imgData = UIImageJPEGRepresentation(imgOriginal!, 0.8)!
        
        imgThumb = UIImageJPEGRepresentation(imgCropped!, 0.8)!
        
        tblShopArt.reloadData()
        
        // let Vframe:CGRect = self.view.convertRect(imgVIew!.frame, toView: self.navigationController?.view)
        
        
        //        cropViewController.dismissAnimated(fromParentViewController: self, toFrame: Vframe) {
        //        }
        
    }
    
    //MARK: - TextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 5 ||  textField.tag == 6
        {
            self.view.endEditing(true)
            
            if textField.tag == 5
            {
                strSelectedPickerType = "Type"
            }
            else if textField.tag == 6
            {
                strSelectedPickerType = "Brand"
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
        
        
        let newLength = textField.text!.characters.count + string.characters.count - range.length
        
        if textField.text! == "" &&  string == " "
        {
            return false
        }
        
        
        if textField.tag == 2 || textField.tag == 3
        {
            if textField.text! == "" &&  string == "0"
            {
                return false
            }
            
            let inverseSet = NSCharacterSet(charactersIn:"0123456789.").inverted
            
            let components = string.components(separatedBy: inverseSet)
            
            let filtered = components.joined(separator: "")
            
            if string != filtered
            {
                return false
            }

            
            return newLength > 10 ? false : true

        }
        
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let buttonPosition : CGPoint = textField.convert(CGPoint.zero, to: tblShopArt)
        
        let indexPath = self.tblShopArt.indexPathForRow(at: buttonPosition)

        if indexPath?.section == 4 {
            
            let str = textField.text!
            
            arrShippingDetail.replaceObject(at: (indexPath?.row)! - 1, with: str)
            
            
        }
        else
        {
        
            if textField.tag == 1
            {
                strShopArtTitle = textField.text!
            }
            else if textField.tag == 2
            {
                strShopArtPrice = textField.text!
            }
            else if textField.tag == 3
            {
                strShopArtQuantity = textField.text!
            }
            else if textField.tag == 4
            {
                strShopArtSize = textField.text!
            }
            else if textField.tag == 7
            {
                strMaterial = textField.text!
            }
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
        
        if strSelectedPickerType == "Type"
        {
            return arrType.count
        }
        else if strSelectedPickerType == "Brand"
        {
            return arrBrand.count
        }
        
        else
        {
            return 0
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        if strSelectedPickerType == "Type"
        {
            return (arrType.object(at: row) as? NSDictionary)?.object(forKey: "name") as? String
        }
        
        else
        {
            return (arrBrand.object(at: row) as? NSDictionary)?.object(forKey: "name") as? String
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedIndexPicker = row
    }
    
    //MARK: - Webservice Methods
    
    func PostShopArt()
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
        
        parameters.setObject(strShopArtQuantity, forKey: "quantity" as NSCopying)
        parameters.setObject(strShopArtPrice, forKey: "price" as NSCopying)
        parameters.setObject(strShopArtTitle, forKey: "title" as NSCopying)
        parameters.setObject(strDescription, forKey: "description" as NSCopying)
        parameters.setObject(strShopArtSize, forKey: "size" as NSCopying)
        
        if isFeatured == true
        {
            parameters.setObject("yes", forKey: "is_featured" as NSCopying)
        }
        else
        {
            parameters.setObject("no", forKey: "is_featured" as NSCopying)
        }
        
        parameters.setObject(strBrand, forKey: "brand" as NSCopying)
        parameters.setObject(strMaterial, forKey: "materials" as NSCopying)
        parameters.setObject(strType, forKey: "type" as NSCopying)
        
        let arrTempShipping = NSMutableArray()
        
        for obj in arrShippingDetail
        {
            if obj as! String != ""
            {
                arrTempShipping.add(obj as! String)
            }
        }

        let strJson = self.jsonString(arr: arrTempShipping)
        
        
        parameters.setObject(strJson!, forKey: "shipping" as NSCopying)

       
        
        
        if imgData.count > 0
        {
            parameters.setObject("", forKey: "shopartImage" as NSCopying)
            
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
        
        
        let  url  = String(format: "%@shopart/create", kSkeuomoMainURL)
        
        manager.post(url as String, parameters: parameters, constructingBodyWith:{ (fromData)in/*fromData : AFMultipartFormData) in*/
            
            if(self.imgData.count > 0)
            {
                fromData.appendPart(withFileData: self.imgData as Data, name: "shopartImage", fileName: "image.jpeg", mimeType: "image/jpeg")
                
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
        
        
        let strId = dicShopArtDetail.valueForNullableKey(key: "id")
        
        
        let parameters = NSMutableDictionary()
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        parameters.setObject(strId, forKey: "id" as NSCopying)

        parameters.setObject(strShopArtQuantity, forKey: "quantity" as NSCopying)
        parameters.setObject(strShopArtPrice, forKey: "price" as NSCopying)
        parameters.setObject(strShopArtTitle, forKey: "title" as NSCopying)
        parameters.setObject(strDescription, forKey: "description" as NSCopying)
        parameters.setObject(strShopArtSize, forKey: "size" as NSCopying)
        
        if isFeatured == true
        {
            parameters.setObject("yes", forKey: "is_featured" as NSCopying)
        }
        else
        {
            parameters.setObject("no", forKey: "is_featured" as NSCopying)
        }
        
        parameters.setObject(strBrand, forKey: "brand" as NSCopying)
        parameters.setObject(strMaterial, forKey: "materials" as NSCopying)
        parameters.setObject(strType, forKey: "type" as NSCopying)
        
        let arrTempShipping = NSMutableArray()
        
        for obj in arrShippingDetail
        {
            if obj as! String != ""
            {
                arrTempShipping.add(obj as! String)
            }
        }
        
        let strJson = self.jsonString(arr: arrTempShipping)
        
        
        parameters.setObject(strJson!, forKey: "shipping" as NSCopying)
        
        
        
        
        if imgData.count > 0
        {
            parameters.setObject("", forKey: "shopartImage" as NSCopying)
            
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
        
        let  url  = String(format: "%@shopart/edit", kSkeuomoMainURL)
        
        print("API URL: ",url)
        
        manager.post(url as String, parameters: parameters, constructingBodyWith:{ (fromData)in/*fromData : AFMultipartFormData) in*/
            
            if(self.imgData.count > 0)
            {
                fromData.appendPart(withFileData: self.imgData as Data, name: "shopartImage", fileName: "image.jpeg", mimeType: "image/jpeg")
                
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
                            
                            let dic = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateMyShopArtList"), object: dic.object(forKey: "shopart") as! NSDictionary)
                            
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

    
    func GetShopArtOption()
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
        
        //shopart/getOptions?userid=97
        
        let  url  = String(format: "%@shopart/getOptions?userid=%@", kSkeuomoMainURL,strUserid)
        
        print("Get Post URL :",url)
        
        manager.get(url, parameters: nil, progress: nil, success:
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
