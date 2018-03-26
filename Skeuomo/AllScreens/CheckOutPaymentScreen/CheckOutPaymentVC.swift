//
//  CheckOutPaymentVC.swift
//  Skeuomo
//
//  Created by by Jannes on 21/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class CheckOutPaymentVC: UIViewController, UITextFieldDelegate {

    @IBOutlet var vieUserDetails: UIView!
    @IBOutlet var toolBarDone:UIToolbar!
    @IBOutlet var viePaymentOptions: UIView!
    @IBOutlet var myScrollingBar: UIScrollView!
    
    
    @IBOutlet weak var imgThemeBG: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        DispatchQueue.main.async
            {
                self.myScrollingBar.contentInset=UIEdgeInsetsMake(0, 0, 0,0)
                self.myScrollingBar.contentSize = CGSize(width: UIScreen.main.bounds.size.width-36, height:730)
        }
        
        // Do any additional setup after loading the view.
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
  
    // MARK: - ButtonsMethods
    @IBAction func btnClickedDone()
    {
        self.view.endEditing(true)
    }
    // MARK: - buttonsMethod
    
    @IBAction func btnDropDownset(_ sender: UIButton)
    {
       if (sender.isSelected)
        {
        vieUserDetails.isHidden = true
      self.viePaymentOptions.frame = CGRect(x:0, y:0, width:viePaymentOptions.frame.size.width , height:viePaymentOptions.frame.size.height)
            
    self.myScrollingBar.contentSize = CGSize(width: UIScreen.main.bounds.size.width-36, height:viePaymentOptions.frame.size.height)
        }
        else
        {
        vieUserDetails.isHidden = false
    self.viePaymentOptions.frame = CGRect(x:0, y: vieUserDetails.frame.size.height+10, width:viePaymentOptions.frame.size.width , height:viePaymentOptions.frame.size.height)
            
       self.myScrollingBar.contentSize = CGSize(width: UIScreen.main.bounds.size.width-36, height:750)

        }
       sender.isSelected = !sender.isSelected
    }
    @IBAction func btnProcessPayment(_ sender: UIButton)
    {
        
    }
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSearching(_ sender: UIButton)
    {
        
    }
    @IBAction func btnNotifications(_ sender: UIButton)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    
//    // MARK: - UITableView Data Source
//    func numberOfSections(in tableView: UITableView) -> Int
//    {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//            return 1
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//          return 784
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
////        if indexPath.row == 0
////        {
//            let cellIdentifier:String = "ShippingAddressTblCell"
//            var cell:ShippingAddressTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ShippingAddressTblCell
//            
//            if (cell == nil)
//            {
//                let nib:Array = Bundle.main.loadNibNamed("ShippingAddressTblCell", owner: nil, options: nil)! as [Any]
//                
//                cell = nib[0] as? ShippingAddressTblCell
//                cell!.selectionStyle = UITableViewCellSelectionStyle.none
//                cell?.backgroundColor = (UIColor.clear);
//            }
//            //ForIncraseSeparatorSize
//            cell?.preservesSuperviewLayoutMargins = false
//            cell?.separatorInset = UIEdgeInsets.zero
//            cell?.layoutMargins = UIEdgeInsets.zero
//        
//          cell?.vieAddress.layer.cornerRadius = 2.0
//         cell?.vieAddress.layer.borderWidth = 1.0
//       cell?.vieAddress.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
//        
//         cell?.vieCity.layer.cornerRadius = 2.0
//        cell?.vieCity.layer.borderWidth = 1.0
//        cell?.vieCity.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
//        
//        cell?.vieFirstName.layer.cornerRadius = 2.0
//        cell?.vieFirstName.layer.borderWidth = 1.0
//        cell?.vieFirstName.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
//        
//        cell?.vieLastName.layer.cornerRadius = 2.0
//        cell?.vieLastName.layer.borderWidth = 1.0
//        cell?.vieLastName.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
//        
//        cell?.vieState.layer.cornerRadius = 2.0
//        cell?.vieState.layer.borderWidth = 1.0
//        cell?.vieState.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
//        
//        cell?.vieCountry.layer.cornerRadius = 2.0
//        cell?.vieCountry.layer.borderWidth = 1.0
//        cell?.vieCountry.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
//        
//        cell?.viePhoneNo.layer.cornerRadius = 2.0
//        cell?.viePhoneNo.layer.borderWidth = 1.0
//        cell?.viePhoneNo.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
//        
//        cell?.txtCardno.keyboardType = .phonePad
//        cell?.txtCardno.delegate = self
// cell?.txtCardno.inputAccessoryView = toolBarDone
//        
//        cell?.txtExpiryDate.keyboardType = .phonePad
//        cell?.txtExpiryDate.delegate = self
//        cell?.txtExpiryDate.inputAccessoryView = toolBarDone
//        
//        cell?.txtCVV.keyboardType = .phonePad
//        cell?.txtCVV.delegate = self
//        cell?.txtCVV.inputAccessoryView = toolBarDone
//      //  cell?.viePayPalId.layer.cornerRadius = 2.0
//      //  cell?.viePayPalId.layer.borderWidth = 1.0
//       // cell?.viePayPalId.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
//        
//        cell?.btnDropDown.addTarget(self, action: #selector(btnDropDownSet), for: .touchUpInside)
//            return cell!
//
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//    }
//    func btnDropDownSet(sender:UIButton)
//    {
//        
//    }
//    func btnAddressHideUnhide(sender:UIButton)
//    {
////        if isClick == sender.tag
////        {
////            isClick = -1
////            
////        }
////        else
////        {
////            isClick = sender.tag
////        }
////        
////        tblPaymentOption.reloadData()
//    }
 

}
