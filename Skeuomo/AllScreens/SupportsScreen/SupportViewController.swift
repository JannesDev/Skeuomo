//
//  SupportViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 22/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.


import UIKit

class SupportViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    var arrAllSports : NSArray!
    var arrAllOptions : NSArray!
    var arrSupportSlt = NSMutableArray()
    var arrGeting : NSArray!
    var arrAccount : NSArray!
    var arrBuying : NSArray!
    var arrSellOn : NSArray!
    var arrApplyTo : NSArray!
    
    @IBOutlet weak var tblSupportShow: UITableView!
    var isClick: Int!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        isClick = -1
        arrGeting = ["How to Sell", "Why buy on Skeuomo", "Our mission"]
        arrAccount = ["How can I build a collection?", "How do I verify my email address?", "How do I close my account?"]
        arrBuying = ["How do Skeuomo's 'Free Shipping Promotions' work?", "Will I be liable to Pay Duty on my Artwork?", "How will my Artwork be shipped?"]
        arrSellOn = ["Manage your shop", "Fulfil order", "Get paid"]
        
arrApplyTo = ["Why sell on Skeuomo", "Application Process"]
        
arrAllOptions = ["GETTING STARTED","GETTING STARTED", "ACCOUNT & PROFILE", "ACCOUNT & PROFILE","BUYING","BUYING" ,"WHY SELL ON SKEUOMO","WHY SELL ON SKEUOMO", "APPLY TO SELL", "APPLY TO SELL"]
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
    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        if section == 0 || section == 2 || section == 4 || section == 6 || section == 8
        {
             return 1
        }
        else if section == 9
        {
           return 2
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 || indexPath.section == 2 || indexPath.section == 4 || indexPath.section == 6 || indexPath.section == 8
        {
              return 44
        }
        else
        {
//                if indexPath.section == 1
//                {
//                    if isClick >= 0 && isClick == indexPath.row
//                    {
//                       return 153
//                    }
//                    else
//                    {
//                       return 42
//                    }
//                }
//                else if indexPath.section == 3
//                {
//                    if isClick >= 0 && isClick == indexPath.row
//                    {
//                        return 153
//                    }
//                    else
//                    {
//                        return 42
//                    }
//            }
          
           return 42
            }
       
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 || indexPath.section == 2 || indexPath.section == 4 || indexPath.section == 6 || indexPath.section == 8
        {
        let cellIdentifier:String = "SupportHeadingTblCell"
        var cell:SupportHeadingTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SupportHeadingTblCell
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("SupportHeadingTblCell", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? SupportHeadingTblCell
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = (UIColor.clear);
        }
            cell?.lblOptions.text = arrAllOptions.object(at: indexPath.section) as? String
        
        return cell!
        }
        else
        {
            if arrSupportSlt.contains(indexPath.section)
            {
                let cellIdentifier:String = "SupportDetailsTblCell"
                var cell:SupportDetailsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SupportDetailsTblCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("SupportDetailsTblCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? SupportDetailsTblCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                return cell!
            }
            else
            {
            let cellIdentifier:String = "GettingStartTblCell"
            var cell:GettingStartTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? GettingStartTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("GettingStartTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? GettingStartTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }

            cell?.vieQuestions.layer.borderWidth = 1.0
            cell?.vieQuestions.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
                
                if indexPath.section == 1
                {
                     cell?.btnPlusMinus.tag = indexPath.row
                    cell?.lblHowToQuestions.text = arrGeting.object(at:indexPath.row)as? String
                }
               else if indexPath.section == 3
                {
                     cell?.btnPlusMinus.tag = indexPath.row
                    cell?.lblHowToQuestions.text = arrAccount.object(at:indexPath.row)as? String
                }
               else if indexPath.section == 5
                {
                     cell?.btnPlusMinus.tag = indexPath.row
                    cell?.lblHowToQuestions.text = arrBuying.object(at:indexPath.row)as? String
                }
               else if indexPath.section == 7
                {
                     cell?.btnPlusMinus.tag = indexPath.row
                    cell?.lblHowToQuestions.text = arrSellOn.object(at:indexPath.row)as? String
                }
                else if indexPath.section == 9
                {
                     cell?.btnPlusMinus.tag = indexPath.row
                    cell?.lblHowToQuestions.text = arrApplyTo.object(at:indexPath.row)as? String
                }
            
                
            if arrSupportSlt.contains(indexPath.section)
            {
                cell?.btnPlusMinus.isSelected = true
            }
            else
            {
                cell?.btnPlusMinus.isSelected = false
            }
            
           
            cell?.btnPlusMinus.addTarget(self,action: #selector(btnSetPlusMinus),for: UIControlEvents.touchUpInside)
            
            return cell!
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    func btnSetPlusMinus(sender:UIButton)
    {
//        if arrSupportSlt.contains(sender.tag)
//        {
//            arrSupportSlt.remove(sender.tag)
//        }
//        else
//        {
//            arrSupportSlt.add(sender.tag)
//        }
print("SenderTAG", sender.tag)
        if isClick >= 0 && isClick == sender.tag
        {
            isClick = -1
        }
        else
        {
            isClick = sender.tag
        }
        print("SenderTAG", isClick)
      tblSupportShow.reloadData()
        
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        
//    }

}
