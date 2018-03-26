//
//  BlogsDetailsVC.swift
//  Skeuomo
//
//  Created by by Jannes on 21/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.

import UIKit

class BlogsDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextViewDelegate {

    @IBOutlet var vieCommentsWrite: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet var txtVieComments: SZTextView!
    @IBOutlet weak var vieComments: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSubmit.layer.cornerRadius = 4.0
        
        vieComments.layer.cornerRadius = 4.0
         vieComments.layer.borderWidth = 1.0
        vieComments.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
        
 txtVieComments.placeholder = "Write Comment"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
    }
       // MARK: - ButtonsMethod
    @IBAction func btnNotification(_ sender: Any)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddcomment(_ sender: Any)
    {
        self.vieCommentsWrite.frame = self.view.frame
        self.view.addSubview(vieCommentsWrite)
    }
    @IBAction func btnSubmit(_ sender: Any)
    {
        self.vieCommentsWrite.removeFromSuperview()
    }
    
    // MARK: - TextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        if section == 0
        {
            return 1
        }
        else
        {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 330
        }
        else
        {
            return 110
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
        let cellIdentifier:String = "BlogsDetailsTblCell"
        var cell:BlogsDetailsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? BlogsDetailsTblCell
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("BlogsDetailsTblCell", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? BlogsDetailsTblCell
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
            let cellIdentifier:String = "BlogsCommentsTblCell"
            var cell:BlogsCommentsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? BlogsCommentsTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("BlogsCommentsTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? BlogsCommentsTblCell
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
