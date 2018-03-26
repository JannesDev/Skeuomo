//
//  CreateBidsVC.swift
//  Skeuomo
//
//  Created by by Jannes on 23/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class CreateBidsVC: UIViewController, UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate  {
    
    var arrBidsName : NSArray!
    var arrTimePrice : NSArray!
     let picker = UIImagePickerController()
       var imgviewPro = UIImageView()
    
        @IBOutlet var toolBarDone:UIToolbar!
    
    @IBOutlet weak var tblCreateBids: UITableView!
    @IBOutlet weak var imgThemeBG: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        arrBidsName = ["Artwork Title","Select Subject" ,"Select Genre","Select Medium","Select Mood"]
        
        arrTimePrice = ["Select Time", "Price"]
        
        
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
    }
     // MARK: - ButtonsMethods
    @IBAction func btnClickedDone()
    {
        self.view.endEditing(true)
    }
    @IBAction func btnPostNow(_ sender: Any) {
    }
    @IBAction func btnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - UITableView Data Source
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
        else if indexPath.section == 2 || indexPath.section == 4
        {
            return 70
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
            imgviewPro = (cell?.imgCreateBid)!
            
           // cell?.imgCreateBid.layer.cornerRadius = (cell?.imgCreateBid.frame.size.width)!/2
            //cell?.imgCreateBid.layer.masksToBounds = true
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
            
            cell?.btnUploadImg.addTarget(self, action: #selector(btnOpenCamera), for: .touchUpInside)
            
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
            if indexPath.section == 4
            {
                cell?.lblCreateBids.text = arrTimePrice.object(at: indexPath.row)as? String
                if indexPath.row == 0 {
                    cell?.txtCreateBid.placeholder = "11 August 2017 - 06.30"
                     cell?.txtCreateBid.isUserInteractionEnabled = false
                    cell?.btnAero.setImage(UIImage.init(named: "calNew.png"), for: .normal)
                }else if indexPath.row == 1
                {
                    cell?.txtCreateBid.placeholder = "$ Enter Price"
                    cell?.txtCreateBid.keyboardType = .phonePad
                    cell?.txtCreateBid.inputAccessoryView = toolBarDone
                    
                        cell?.btnAero.isHidden = true
                }
            }
            else
            {
                cell?.lblCreateBids.text = arrBidsName.object(at: indexPath.row)as? String
                
                if indexPath.row == 0 {
                    cell?.txtCreateBid.placeholder = "Title"
                      cell?.btnAero.isHidden = true
                }else if indexPath.row == 1
                {
                    cell?.txtCreateBid.placeholder = "Portrait"
                    cell?.btnAero.isHidden = false
                    cell?.lblSeprator.isHidden = false
                    cell?.txtCreateBid.isUserInteractionEnabled = false
                }else if indexPath.row == 2
                {
                    cell?.txtCreateBid.placeholder = "Fine Art"
                      cell?.btnAero.isHidden = false
                      cell?.lblSeprator.isHidden = false
                       cell?.txtCreateBid.isUserInteractionEnabled = false
                }
                else if indexPath.row == 3
                {
                    cell?.txtCreateBid.placeholder = "Bright"
                      cell?.btnAero.isHidden = false
                      cell?.lblSeprator.isHidden = false
                       cell?.txtCreateBid.isUserInteractionEnabled = false
                }else
                {
                    cell?.txtCreateBid.placeholder = "Oil"
                      cell?.btnAero.isHidden = false
                      cell?.lblSeprator.isHidden = false
                       cell?.txtCreateBid.isUserInteractionEnabled = false
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            //  imgProfilePic.contentMode = .scaleAspectFit
            imgviewPro.image = image
        } else{
            // appDelegate.ShowAlert(message: "No camera")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - TextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
