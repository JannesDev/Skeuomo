//
//  MessagesViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var txtSearching: UITextField!
    @IBOutlet weak var tblMsgShow: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
    }
     // MARK: - ButtonsMethod
    @IBAction func btnSearch(_ sender: Any) {
    }
    
    @IBAction func btnSideMenu(_ sender: Any)
    {
    self.appDelegate.sideMenuController.openMenu()
    }
    @IBAction func btnNotificaion(_ sender: Any)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    
      // MARK: - UItextField
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "MessagesTblCell"
        var cell:MessagesTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MessagesTblCell
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("MessagesTblCell", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? MessagesTblCell
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = (UIColor.clear);
        }
        //ForIncraseSeparatorSize
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let Msg  = MessageDetailsVC(nibName:"MessageDetailsVC", bundle:nil)
        self.navigationController?.pushViewController(Msg, animated: true)
    }


}
