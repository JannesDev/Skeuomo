//
//  HomeViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 16/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var tblHomeData: UITableView!
    
    var arrArtist : NSArray!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        arrArtist = ["ARTISAN GALLERIA", "AUCTION ATRIUM"]
        self.automaticallyAdjustsScrollViewInsets = false
        tblHomeData.tableFooterView = UIView()
        
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
    // MARK: - ButtonsMethods
    @IBAction func btnSideMenu(_ sender: Any)
    {
         appDelegate.sideMenuController.openMenu()
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
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 || indexPath.row == 1
        {
            return 172
        }
        else  if indexPath.row == 2
        {
            return 100//74
        }
        else  if indexPath.row == 3
        {
            return 158
        }
        else  if indexPath.row == 4
        {
            return 44
        }
        else
        {
            return 146
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cellIdentifier:String = "BestSellerTblCell"
            var cell:BestSellerTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? BestSellerTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("BestSellerTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? BestSellerTblCell
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
            let cellIdentifier:String = "ImgCollectionTblCell"
            var cell:ImgCollectionTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ImgCollectionTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ImgCollectionTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ImgCollectionTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            let nib = UINib(nibName: "ImgCollectionCell", bundle: nil)
            
            cell?.collectionImgShow.register(nib,forCellWithReuseIdentifier: "ImgCollectionCell")
            
            //cell?.collectionImgShow.tag = indexPath.row
            
            cell?.collectionImgShow.delegate = self
             cell?.collectionImgShow.dataSource = self
            
            
            
            return cell!
        }
        else  if indexPath.row == 2
        {
            let cellIdentifier:String = "ArtCummunityTblCell"
            var cell:ArtCummunityTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ArtCummunityTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ArtCummunityTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ArtCummunityTblCell
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
            let cellIdentifier:String = "NewsFromBlogTblCell"
            var cell:NewsFromBlogTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NewsFromBlogTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("NewsFromBlogTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? NewsFromBlogTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
                  cell?.btnReadMore.addTarget(self, action: #selector(btnReadBlogsDetailsVC), for: .touchUpInside)
            return cell!
        }
        else  if indexPath.row == 4
        {
            let cellIdentifier:String = "BtnViewAllTblCell"
            var cell:BtnViewAllTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? BtnViewAllTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("BtnViewAllTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? BtnViewAllTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
                 cell?.btnViewAll.addTarget(self, action: #selector(btnViewBlogsScreen), for: .touchUpInside)
            return cell!
        }
        else
        {
            let cellIdentifier:String = "ArtShopTblCell"
            var cell:ArtShopTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ArtShopTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ArtShopTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ArtShopTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            cell?.btnArtShop.layer.cornerRadius = 2.0
            cell?.btnArtShop.layer.masksToBounds = true
            cell?.btnArtShop.addTarget(self, action: #selector(btnArtShopScreen), for: .touchUpInside)
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            let GDetails = BestSellerScreen(nibName:"BestSellerScreen", bundle:nil)
             GDetails.fromSideMenu = "FromSideMenu"
            self.navigationController?.pushViewController(GDetails, animated: true)
        }
        else  if indexPath.row == 2
        {
            let GDetails = CommunitySharingVC(nibName:"CommunitySharingVC", bundle:nil)
             GDetails.fromSideMenu = "FromSideMenu"
            self.navigationController?.pushViewController(GDetails, animated: true)
        }
    }
    func btnReadBlogsDetailsVC(sender:UIButton)
    {
        let GDetails = BlogsDetailsVC(nibName:"BlogsDetailsVC", bundle:nil)
        self.navigationController?.pushViewController(GDetails, animated: true)
    }
    
    func btnViewBlogsScreen(sender:UIButton)
    {
        let GDetails = BlogsViewController(nibName:"BlogsViewController", bundle:nil)
       GDetails.fromSideMenu = "FromSideMenu"
        self.navigationController?.pushViewController(GDetails, animated: true)
    }
    func btnArtShopScreen(sender:UIButton)
    {
        let GDetails = VendorViewController(nibName:"VendorViewController", bundle:nil)
        self.navigationController?.pushViewController(GDetails, animated: true)
    }
    // MARK: - UICollection View Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrArtist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: ((collectionView.frame.size.width/2)), height: 165)
    }
    
    // make a cell for each cell index path
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgCollectionCell", for: indexPath as IndexPath) as! ImgCollectionCell
        
        cell.lblArtisan.text = arrArtist.object(at: indexPath.item) as? String
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.item == 0
        {
            let GDetails = ArtistsGalleriaVC(nibName:"ArtistsGalleriaVC", bundle:nil)
             GDetails.fromSideMenu = "FromSideMenu"
            self.navigationController?.pushViewController(GDetails, animated: true)
        }
        else
        {
            let GDetails = AuctionViewController(nibName:"AuctionViewController", bundle:nil)
               GDetails.fromSideMenu = "FromSideMenu"
            self.navigationController?.pushViewController(GDetails, animated: true)
        }
        
    }
    
    
    func getLocationFromAddressString(_ addressStr:NSString) -> CLLocationCoordinate2D
    {
        var latitude:Double = 0
        var longitude:Double = 0
        
        var esc_addr:NSString!
        esc_addr = addressStr.addingPercentEscapes(using: String.Encoding.utf8.rawValue) as NSString!
        let req = NSString(format: "http://maps.google.com/maps/api/geocode/json?sensor=true&components=locality&address=%@", esc_addr)
        
        //var result = NSString(contentsOfURL: NSURL(string: req as String)!, encoding: NSUTF8StringEncoding, error: nil)
        var result:NSString!
        do {
            result = try String (contentsOf: URL(string: req as String)!, encoding: String.Encoding.utf8) as NSString!
        }
        catch {
            print(error)
        }
        if (result != nil)
        {
            var scanner:Scanner!
            scanner = Scanner(string: result as String)
            if scanner .scanUpTo("\"lat\":", into: nil) && scanner .scanUpTo("\"lat\":", into: nil)
            {
                scanner .scanDouble(&latitude)
                
            }
            
            if scanner .scanUpTo("\"lng\":", into: nil) && scanner .scanUpTo("\"lng\":", into: nil)
            {
                scanner .scanDouble(&longitude)
                
            }
        }
        
        var error:NSError!
        var jsonData:Data!
        jsonData = result .data(using: String.Encoding.utf8.rawValue)
        var jsonResults:NSDictionary!
        do {
            
            jsonResults = try JSONSerialization.jsonObject(with: jsonData!, options: []) as! NSDictionary
            print("jsonResults",jsonResults)
            //if (![[resultDic objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"])
            if jsonResults.object(forKey: "status") as! String == "OK"
            {
                var arrRes = NSArray()
                
                arrRes = jsonResults.object(forKey: "results") as! NSArray
                
                let dicData = arrRes[0] as! NSDictionary
                
                let dicGeo = dicData.object(forKey: "geometry") as! NSDictionary
                
                let dicLocation = dicGeo.object(forKey: "location") as! NSDictionary
                
                latitude = (dicLocation.object(forKey: "lat")! as AnyObject).doubleValue
                longitude = (dicLocation.object(forKey: "lng")! as AnyObject).doubleValue
                
                print("longitude",longitude)
                print("latitude",latitude)
                
                
            }
            // success ...
        }
        catch
        {
            // failure
            print("Fetch failed: \((error as NSError).localizedDescription)")
        }
        var center = CLLocationCoordinate2DMake(latitude,longitude)
        center.latitude = latitude
        center.longitude = longitude
        return center
        
        
    }
    

}
