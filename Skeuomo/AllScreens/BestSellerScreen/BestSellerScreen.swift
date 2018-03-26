
//
//  BestSellerScreen.swift
//  Skeuomo
//
//  Created by by Jannes on 16/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class BestSellerScreen: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tblSortOptions: UITableView!
    @IBOutlet weak var collectionSellers: UICollectionView!
    @IBOutlet var vieSortOptions: UIView!
    var arrSortOptions : NSArray!
    @IBOutlet weak var vieSortTblData: UIView!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var vieBottomButtons: UIView!
    @IBOutlet weak var vieTopSearching: UIView!
    
    var selectedValue : Int! = -1
    
    @IBOutlet weak var btnSearchHeader: UIButton!
    var fromSideMenu = ""
    @IBOutlet weak var btnBackSide: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
arrSortOptions = ["Featured", "Recent", "Popular", "Price Low to High", "Price High to Low"]
      
        
        self.automaticallyAdjustsScrollViewInsets = false
        
          let nib = UINib(nibName: "SellerCollectionVCell", bundle: nil)
        collectionSellers.register(nib,forCellWithReuseIdentifier: "SellerCollectionVCell")
        collectionSellers.delegate = self
        collectionSellers.dataSource = self
        
        vieTopSearching.isHidden = true
        
        // Do any additional setup after loading the view.
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
 
    // MARK: - ButtonsMethods
    
    @IBAction func btnClosepopup(_ sender: Any)
    {
        self.vieSortOptions.removeFromSuperview()
    }
    @IBAction func btnSideMenu(_ sender: Any)
    {
        // appDelegate.sideMenuController.openMenu()
        
        if fromSideMenu == "FromSideMenu"
        {
          
             self.navigationController?.popViewController(animated: true)
        }
        else
        {
             self.appDelegate.sideMenuController.openMenu()
        }
    }

    @IBAction func btnSearching(_ sender: UIButton)
    {
   
   self.collectionSellers.frame = CGRect.init(x: 14, y: 110, width: self.collectionSellers.frame.size.width, height: self.appDelegate.screenHeight-110)
       self.vieTopSearching.isHidden = false
        self.vieBottomButtons.isHidden = true
    }
    @IBAction func btnNotifications(_ sender: Any)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    @IBAction func btnFilter(_ sender: Any)
    {
        let Filtr  = FilterViewController(nibName:"FilterViewController", bundle:nil)
        self.navigationController?.pushViewController(Filtr, animated: true)
    }
    @IBAction func btnSearchOption(_ sender: UIButton)
    {
        
   self.collectionSellers.frame = CGRect.init(x: 14, y: 64, width: self.collectionSellers.frame.size.width, height: self.appDelegate.screenHeight-64)
        
          self.vieTopSearching.isHidden = true
       self.vieBottomButtons.isHidden = false
    }
    
    @IBAction func btnSortBy(_ sender: Any)
    {
        vieSortTblData.layer.cornerRadius = 4.0
        
        self.vieSortOptions.frame = self.view.frame
        self.view.addSubview(vieSortOptions)
    }
    
    
    // MARK: - UICollection View Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (collectionView.frame.size.width/2), height: 214)
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
        {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellerCollectionVCell", for: indexPath as IndexPath) as! SellerCollectionVCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let Filtr  = ArtistsDetailsVC(nibName:"ArtistsDetailsVC", bundle:nil)
        self.navigationController?.pushViewController(Filtr, animated: true)
    }
    
    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return arrSortOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 46
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "SortOptionsTblCell"
        var cell:SortOptionsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SortOptionsTblCell
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("SortOptionsTblCell", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? SortOptionsTblCell
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = (UIColor.clear);
        }
        //ForIncraseSeparatorSize
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        
        cell?.btnRadioCheck.isSelected = false

        cell?.lblSortOptions.text = arrSortOptions.object(at: indexPath.row) as? String
        cell?.btnRadioCheck.tag = indexPath.row
        
        if selectedValue == indexPath.row
        {
             cell?.btnRadioCheck.isSelected = true
        }
        
        cell?.btnRadioCheck.addTarget(self,action: #selector(btnCheckUncheckSelect),for: UIControlEvents.touchUpInside)
        
        return cell!
    }

    func btnCheckUncheckSelect(sender:UIButton)
    {
        selectedValue = sender.tag
        tblSortOptions.reloadData()
    }
}
