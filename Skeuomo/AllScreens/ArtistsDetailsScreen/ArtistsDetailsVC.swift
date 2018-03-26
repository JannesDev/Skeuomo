//
//  ArtistsDetailsVC.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ArtistsDetailsVC: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tblArtstsDetails: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - ButtonsMethod
    
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNotification(_ sender: UIButton)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }

    @IBAction func BtnSearch(_ sender: UIButton) {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtiestCollCell", for: indexPath as IndexPath) as! ArtiestCollCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    }
    
    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 266
        }
            
        else  if indexPath.row == 1
        {
            return 64
        }
            
        else  if indexPath.row == 2
        {
            return 84
        }
        else if indexPath.row == 3
        {
            return 340
        }
        else
        {
          return 212
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cellIdentifier:String = "ImgProfileTblCell"
            var cell:ImgProfileTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ImgProfileTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ImgProfileTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ImgProfileTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            return cell!

        }
        else  if indexPath.row == 1
        {
            let cellIdentifier:String = "RatingTblCell"
            var cell:RatingTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RatingTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("RatingTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? RatingTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            return cell!
        }
        else  if indexPath.row == 2
        {
            let cellIdentifier:String = "AudioBiographyTblCell"
            var cell:AudioBiographyTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? AudioBiographyTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("AudioBiographyTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? AudioBiographyTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            return cell!
        }
        else  if indexPath.row == 3
        {
            let cellIdentifier:String = "DetailsAndImgTblCell"
            var cell:DetailsAndImgTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DetailsAndImgTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("DetailsAndImgTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? DetailsAndImgTblCell
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
            let cellIdentifier:String = "ArtistsCollectionCell"
            var cell:ArtistsCollectionCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ArtistsCollectionCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ArtistsCollectionCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ArtistsCollectionCell
                
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            let nib = UINib(nibName: "ArtiestCollCell", bundle: nil)
            cell?.collDataShow.register(nib,forCellWithReuseIdentifier: "ArtiestCollCell")
            
            cell?.collDataShow.delegate = self
            cell?.collDataShow.dataSource = self
            
            return cell!
        }

}


}
