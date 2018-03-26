//
//  MessageDetailsVC.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class MessageDetailsVC: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var txtTypeMsg: UITextField!
    
    @IBOutlet weak var tblMessageShow: UITableView!
    
    @IBOutlet weak var vieDropDown: UIView!
    
    @IBOutlet var vieVideoButtons: UIView!
   @IBOutlet var vieTxtAttachBtn: UIView!
    
    @IBOutlet weak var btnAttachClick: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        vieDropDown.isHidden = true
        
        
        
        DispatchQueue.main.async
            {
                self.tblMessageShow.frame = CGRect.init(x: 0, y: 64, width: self.tblMessageShow.frame.size.width, height: self.view.frame.size.height-64-46)
                
                self.vieTxtAttachBtn.frame = CGRect.init(x: 0, y: self.view.frame.size.height-46, width: self.view.frame.size.width, height:46)
                
                self.vieVideoButtons.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height:70)
        }
    }
    
    func animateTextField(textField: UITextField, up: Bool)
    {
        let movementDistance:CGFloat!
       
        
        if appDelegate.screenHeight <= 568
        {
          movementDistance = -224
        }
       else if appDelegate.screenHeight == 736
        {
          movementDistance = -270
        }
        else if appDelegate.screenHeight == 667
        {
           movementDistance = -256
        }
        else
        {
          movementDistance = -285
        }
      
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up:true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up:false)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
            self.tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - ButtonsMethods
    @IBAction func btnOptions(_ sender: UIButton)
    {
        if sender.isSelected == false
        {
            vieDropDown.isHidden = false
        }
        else
        {
            vieDropDown.isHidden = true
        }
        sender.isSelected = !sender.isSelected
    }
    @IBAction func btnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSendMsg(_ sender: Any) {
    }
    @IBAction func btnAttachFile(_ sender: UIButton)
    {
        if (sender.isSelected)
        {
            self.tblMessageShow.frame = CGRect.init(x: 0, y: 64, width: self.tblMessageShow.frame.size.width, height: self.view.frame.size.height-64-46)
            
            vieTxtAttachBtn.frame = CGRect.init(x: 0, y: self.view.frame.size.height-46, width: self.view.frame.size.width, height:46)
            
            vieVideoButtons.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height:70)
            
        }
        else
        {
            
            self.tblMessageShow.frame = CGRect.init(x: 0, y: 64, width: self.tblMessageShow.frame.size.width, height: self.view.frame.size.height-64-46-70)
            
            vieTxtAttachBtn.frame = CGRect.init(x: 0, y: self.view.frame.size.height-70-46, width: self.view.frame.size.width, height:46)
            
            vieVideoButtons.frame = CGRect.init(x: 0, y: self.view.frame.size.height-70, width: self.view.frame.size.width, height:70)
          }
        
        sender.isSelected = !sender.isSelected
    }
    // MARK: - TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
    
    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 115
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row <= 2
        {
            let cellIdentifier:String = "ChatRoomOtherTblCell"
            var cell:ChatRoomOtherTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChatRoomOtherTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ChatRoomOtherTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ChatRoomOtherTblCell
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
            let cellIdentifier:String = "ChatRoomUserTblCell"
            var cell:ChatRoomUserTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChatRoomUserTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ChatRoomUserTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ChatRoomUserTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
 


}
