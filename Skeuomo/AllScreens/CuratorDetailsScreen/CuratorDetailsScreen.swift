//
//  CuratorDetailsScreen.swift
//  Skeuomo
//
//  Created by Satish ios on 22/09/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class CuratorDetailsScreen: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate
{
    @IBOutlet var tblDetals         : UITableView!
    
    @IBOutlet var viewProfilePic    : UIView!
    @IBOutlet var viewCareerExp     : UIView!
    @IBOutlet var viewLatestWork    : UIView!
    @IBOutlet var viewBiography     : UIView!
    @IBOutlet var viewFavorite      : UIView!
    
    @IBOutlet var btnCareer         : UIButton!
    @IBOutlet var btnLatest         : UIButton!
    @IBOutlet var btnBiogra         : UIButton!
    
    var strSelectedHeader : NSString = ""
    
    var arrDescription : NSArray = ["","This is test text for Career Experience section here it is expandable cell it will automatically closess if user selected any other sections.","This is test text for Latest Work section here it is expandable cell it will automatically closess if user selected any other sections.","This is test text for Biography section here it is expandable cell it will automatically closess if user selected any other sections. Here user can watch the other users biography by tapping on the play button."]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tblDetals.separatorStyle = .none

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIButton Events
    
    @IBAction func method_Back(_sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // Mark:- table view delegate and data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        switch section
        {
        case 0:
            return viewProfilePic
        case 1:
            return viewCareerExp
        case 2:
            return viewLatestWork
        case 3:
            return viewBiography
        case 4:
            return viewFavorite
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        switch section
        {
        case 0:
            return 242
        case 1:
            return 56
        case 2:
            return 56
        case 3:
            return 56
        case 4:
            return 75
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section
        {
        case 0:
            return 2
        case 1:
            if strSelectedHeader.isEqual(to: "careerexp")
            {
                return 1
            }
            else
            {
                return 0
            }
        case 2:
            if strSelectedHeader.isEqual(to: "latestwork")
            {
                return 1
            }
            else
            {
                return 0
            }
        case 3:
            if strSelectedHeader.isEqual(to: "biography")
            {
                return 1
            }
            else
            {
                return 0
            }
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.section
        {
        case 0:
            return 77
        case 1:
            if strSelectedHeader.isEqual(to: "careerexp")
            {
                let strText = "\(arrDescription.object(at: indexPath.section))"
                
                let lblHeight = HelpingMethods.sharedInstance.getDynamicHeight(strText: strText as NSString, Width:  UIScreen.main.bounds.size.width - 56, font: "GIBSON-LIGHT", fontSize: 12.0)
                
                return lblHeight.size.height +  31
            }
            else
            {
                return 0
            }
        case 2:
            if strSelectedHeader.isEqual(to: "latestwork")
            {
                let strText = "\(arrDescription.object(at: indexPath.section))"
                
                let lblHeight = HelpingMethods.sharedInstance.getDynamicHeight(strText: strText as NSString, Width: UIScreen.main.bounds.size.width - 56, font: "GIBSON-LIGHT", fontSize: 12.0)
                
                return lblHeight.size.height +  31
            }
            else
            {
                return 0
            }
        case 3:
            if strSelectedHeader.isEqual(to: "biography")
            {
                let strText = "\(arrDescription.object(at: indexPath.section))"
                
                let lblHeight = HelpingMethods.sharedInstance.getDynamicHeight(strText: strText as NSString, Width: UIScreen.main.bounds.size.width - 56, font: "GIBSON-LIGHT", fontSize: 12.0)
                
                return lblHeight.size.height +  172
            }
            else
            {
                return 0
            }
        case 4:
            return (12 * 220)/2 + 45
        default:
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cellIdentifier:String = "CuratorInfoCell"
            var cell:CuratorInfoCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CuratorInfoCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("CuratorInfoCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? CuratorInfoCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
               // cell?.backgroundColor = (UIColor.clear);
            }
            
            if indexPath.row == 0
            {
                cell?.lblInfoTitle.text = "COMPANY NAME"
                cell?.lblInfoDesc.text = "Lyte Info Pvt. Ltd"
            }
            else
            {
                cell?.lblInfoTitle.text = "WEBSITE"
                cell?.lblInfoDesc.text = "Lyterart.com"
            }
            
            return cell!
        }
        else if indexPath.section == 1
        {
            let cellIdentifier:String = "CuratorExpandingCell"
            var cell:CuratorExpandingCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CuratorExpandingCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("CuratorExpandingCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? CuratorExpandingCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                //cell?.backgroundColor = (UIColor.clear);
            }
            

            cell?.lblDescription.text = "\(arrDescription.object(at: indexPath.section))"
            
            
            return cell!
        }
        else if indexPath.section == 2
        {
            let cellIdentifier:String = "CuratorExpandingCell"
            var cell:CuratorExpandingCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CuratorExpandingCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("CuratorExpandingCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? CuratorExpandingCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                //cell?.backgroundColor = (UIColor.clear);
            }
            
            
            cell?.lblDescription.text = "\(arrDescription.object(at: indexPath.section))"
            
            
            return cell!
        }
        else if indexPath.section == 3
        {
            let cellIdentifier:String = "CuratorBiographyCell"
            var cell: CuratorBiographyCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CuratorBiographyCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("CuratorBiographyCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? CuratorBiographyCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                //cell?.backgroundColor = (UIColor.clear);
            }
            
            let strText = "\(arrDescription.object(at: indexPath.section))"
            
            let lblHeight = HelpingMethods.sharedInstance.getDynamicHeight(strText: strText as NSString, Width: UIScreen.main.bounds.size.width - 56, font: "GIBSON-LIGHT", fontSize: 12.0)
            
            cell?.lblDescription.text = strText
            
            var lFrame = cell?.lblDescription.frame
            
            lFrame?.size.height = lblHeight.size.height
            
            cell?.lblDescription.frame = lFrame!
            
            var vFrame = cell?.viewVideo.frame
            
            vFrame?.origin.y = (cell?.lblDescription.frame.origin.y)! + (cell?.lblDescription.frame.size.height)! + 8
            
            cell?.viewVideo.frame = vFrame!
            
            
            return cell!
        }
        else
        {
            let cellIdentifier:String = "CuratorFavCollectionCell"
            var cell: CuratorFavCollectionCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CuratorFavCollectionCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("CuratorFavCollectionCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? CuratorFavCollectionCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                //cell?.backgroundColor = (UIColor.clear);
            }
            
            cell?.clFav.dataSource = self
            cell?.clFav.delegate = self
            
            let nib = UINib(nibName: "FavItemCell", bundle: nil)
            cell?.clFav.register(nib, forCellWithReuseIdentifier: "FavItemCell")
            
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            
            layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width)/2 - 24, height: 220)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            cell?.clFav.collectionViewLayout = layout
            
            return cell!
        }
        
        
        
        
    }
    
    
    // MARK: - UICollectionView Delegate Methods
    public func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 12
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavItemCell", for: indexPath as IndexPath) as! FavItemCell
        
        cell.lblFavUserName.attributedText = HelpingMethods.sharedInstance.attributedString(fromText1: "John Deo", withFont: "GIBSON-REGULAR", fontSize: 13.0, textColor1: UIColor.black, fromText2: "\nBerlin, USA", withFont: "GIBSON-LIGHT", fontSize: 12.0, textColor2: UIColor.lightGray)
        
        cell.lblFavUserName.numberOfLines = 0
        
        
        return cell
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        
        
    }
    
    // MARK: - UIButton Events
    
    @IBAction func method_CareerExp(_sender : UIButton)
    {
        
        
        _sender.isSelected = !_sender.isSelected
        
        if _sender.isSelected == true
        {
            strSelectedHeader = "careerexp"
            
            btnCareer.setImage(UIImage.init(named: "a-up"), for: .normal)
            btnLatest.setImage(UIImage.init(named: "a-down"), for: .normal)
            btnBiogra.setImage(UIImage.init(named: "a-down"), for: .normal)
            
        }
        else
        {
            strSelectedHeader = ""
            
            btnCareer.setImage(UIImage.init(named: "a-down"), for: .normal)
        }
        
        tblDetals.reloadData()
        
        
    }
    @IBAction func method_LatestWork(_sender : UIButton)
    {
        
        
        _sender.isSelected = !_sender.isSelected
        
        if _sender.isSelected == true
        {
            
            strSelectedHeader = "latestwork"
            
            btnCareer.setImage(UIImage.init(named: "a-down"), for: .normal)
            btnBiogra.setImage(UIImage.init(named: "a-down"), for: .normal)
            btnLatest.setImage(UIImage.init(named: "a-up"), for: .normal)
            
        }
        else
        {
            
            strSelectedHeader = ""
            
            btnLatest.setImage(UIImage.init(named: "a-down"), for: .normal)
            
        }
        tblDetals.reloadData()
        
    }
    @IBAction func method_Biography(_sender : UIButton)
    {
        
        
        _sender.isSelected = !_sender.isSelected
        
        if _sender.isSelected == true
        {
            
            strSelectedHeader = "biography"
            
            btnBiogra.setImage(UIImage.init(named: "a-up"), for: .normal)
            btnCareer.setImage(UIImage.init(named: "a-down"), for: .normal)
            btnLatest.setImage(UIImage.init(named: "a-down"), for: .normal)
            
        }
        else
        {
            strSelectedHeader = ""
            
            btnBiogra.setImage(UIImage.init(named: "a-down"), for: .normal)
            
        }
        
        tblDetals.reloadData()
        
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
