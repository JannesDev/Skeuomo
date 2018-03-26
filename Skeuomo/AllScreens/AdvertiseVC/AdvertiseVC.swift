//
//  AdvertiseVC.swift
//  Skeuomo
//
//  Created by usersmart on 8/21/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class AdvertiseVC: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet var tblAdvertise: UITableView!
    
    @IBOutlet weak var imgThemeBG: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
// Mark:- ButtonsMethod
    @IBAction func btnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPostYour(_ sender: Any) {
    }
    // Mark:- table view delegate and data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 136
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "cellAdvertise"
        var cell:cellAdvertise? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? cellAdvertise
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("cellAdvertise", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? cellAdvertise
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = (UIColor.clear);
        }
        
        return cell!
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
