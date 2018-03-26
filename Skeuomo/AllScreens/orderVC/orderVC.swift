//
//  orderVC.swift
//  Skeuomo
//
//  Created by usersmart on 8/21/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class orderVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet var tblOrder: UITableView!
    @IBOutlet weak var imgThemeBG: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
        
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
    // Mark:- table view delegate and data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 98
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "cellOrder"
        var cell:cellOrder? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? cellOrder
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("cellOrder", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? cellOrder
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = (UIColor.clear);
        }
        
        cell?.lblDescription.text = "Lorem Ipsum is simply dummy text \n simply"
        
        return cell!
    }

    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - ButtonsMethod

    @IBAction func btnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

}
