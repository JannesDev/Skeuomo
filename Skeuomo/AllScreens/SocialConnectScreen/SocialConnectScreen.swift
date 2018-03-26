//
//  SocialConnectScreen.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 19/02/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class SocialConnectScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblSettingsOption: UITableView!
    
    var arrAllOptions : NSArray!
    var arrAllImages : NSArray!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        arrAllOptions = ["FACEBOOK", "TWITTER","PINTEREST", "INSTAGRAM"]
        arrAllImages = ["fb", "tw","g+", "insta"]


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Buttons Method
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.appDelegate.sideMenuController.openMenu()
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
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "SocialConnectCell"
        var cell:SocialConnectCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SocialConnectCell
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("SocialConnectCell", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? SocialConnectCell
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
        }
        
        cell?.lblTitle.text = arrAllOptions.object(at: indexPath.row)as? String
        
        cell?.imgSocial.image = UIImage.init(named: (arrAllImages.object(at: indexPath.row) as? String)!)
        
        
//        if indexPath.row == 0
//        {
//            let fbaccessToken = fb
//            
//            
//        }
        
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
