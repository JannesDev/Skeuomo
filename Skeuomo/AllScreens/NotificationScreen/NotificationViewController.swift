//
//  NotificationViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 22/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblNotification: UITableView!
    
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
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Buttons Methods
    
    @IBAction func btnBack(_ sender: Any)
    {
       _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "NotificationTblCell"
        var cell:NotificationTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NotificationTblCell
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("NotificationTblCell", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? NotificationTblCell
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
    }

}
