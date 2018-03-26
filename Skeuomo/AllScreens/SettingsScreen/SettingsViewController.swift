//
//  SettingsViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 22/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var tblSettingsOption: UITableView!

    var arrAllOptions : NSArray!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        arrAllOptions = ["NOTIFICATIONS", "PROFILE","SOCIAL ACCOUNTS", "PAYMENT INFO", "CHANGE PASSWORD"]
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - ButtonsMethod
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.appDelegate.sideMenuController.openMenu()
    }
    
    @IBAction func btnSearching(_ sender: UIButton)
    {
    }
    @IBAction func btnNotifications(_ sender: UIButton)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }

    @IBAction func btnNotificationSettings(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
    }
    // MARK: - UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrAllOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "SettingsTblCell"
        var cell:SettingsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SettingsTblCell
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("SettingsTblCell", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? SettingsTblCell
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = (UIColor.clear);
        }
        
        cell?.lblSettingsName.text = arrAllOptions.object(at: indexPath.row)as? String
     
        
        if indexPath.row == 0
        {
            cell?.btnAero.isHidden = true
            cell?.switchNotification.isHidden = false
        }
        else
        {
            cell?.btnAero.isHidden = false
            cell?.switchNotification.isHidden = true
        }
        
       
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (indexPath as NSIndexPath).section == 0
        {
            switch (indexPath as NSIndexPath).row
            {
            case 0:
              
                break

            case 1:
                let profile = MyProfileViewController(nibName:"MyProfileViewController",bundle:nil)
                self.navigationController?.pushViewController(profile, animated: true)
                break
            case 2:
                let profile = SocialConnectScreen(nibName:"SocialConnectScreen",bundle:nil)
                self.navigationController?.pushViewController(profile, animated: true)
                break
            case 3:
                let Payment = CheckOutPaymentVC(nibName:"CheckOutPaymentVC",bundle:nil)
                self.navigationController?.pushViewController(Payment, animated: true)
                break
            case 4:
                let Change = ChangePasswordScreen(nibName:"ChangePasswordScreen",bundle:nil)
                self.navigationController?.pushViewController(Change, animated: true)
                break
           
            default:
                break;
            }
        }
    }

}
