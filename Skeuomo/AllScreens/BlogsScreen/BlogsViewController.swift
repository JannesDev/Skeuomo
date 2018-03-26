//
//  BlogsViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 18/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class BlogsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblBlogsShow: UITableView!
    var fromSideMenu = ""
    @IBOutlet var btnBackSide: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
        if fromSideMenu == "FromSideMenu"
        {
            self.btnBackSide.setImage(UIImage.init(named: "back.png"), for: .normal)
        }
        else
        {
            self.btnBackSide.setImage(UIImage.init(named: "menu'.png"), for: .normal)
            
        }
        
    }
   
    // MARK: - ButtonsMethods

    @IBAction func btnMenu(_ sender: Any)
    {
        if fromSideMenu == "FromSideMenu"
        {
            
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            self.appDelegate.sideMenuController.openMenu()
        }
    }
    @IBAction func btnCategory(_ sender: Any) {
    }
    @IBAction func btnNotification(_ sender: Any)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    @IBAction func btnSearch(_ sender: Any) {
    }

    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 290
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "BlogsTblCell"
        var cell:BlogsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? BlogsTblCell
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("BlogsTblCell", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? BlogsTblCell
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = (UIColor.clear);
        }
        //ForIncraseSeparatorSize
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
   cell?.btnReadMore.addTarget(self,action: #selector(btnReadBlogsDetailsVC),for: UIControlEvents.touchUpInside)
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       // let Blog  = BlogsDetailsVC(nibName:"BlogsDetailsVC", bundle:nil)
      //  self.navigationController?.pushViewController(Blog, animated: true)
    }
    func btnReadBlogsDetailsVC(sender:UIButton)
    {
        let Blog  = BlogsDetailsVC(nibName:"BlogsDetailsVC", bundle:nil)
        self.navigationController?.pushViewController(Blog, animated: true)
    }

}
