//
//  DeshboardMenuScreen.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 03/01/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class DeshboardMenuScreen: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var tblDashboard: UITableView!
    
    @IBOutlet weak var imgThemeBG: UIImageView!
    
    var arrDashboardSection : NSArray!
    
    var arrDashboardSectionIcon : NSArray!

    let fontSection = UIFont.init(name: "Gibson-Regular", size: 15)

    var arrSelectedOption = NSMutableArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        arrDashboardSection = ["Profile","Portfolio", "Shop Arts", "My Favorites", "Events","Advertise","Inbox", "Invite Friends", "Collection"]
        
        arrDashboardSectionIcon = ["profile","post_artwork","create_bid","favorite","create_event","advertise","inbox","invite_friend","collection"]
        
//        arrDashboardList = ["My Profile","Themes", "Create Your Events", "Upload Artwork", "Auction Artwork","Upload Art Shop Product","Inbox", "Orders", "Invite Friends", "Favorite (6)","My Bookings","My Events", "My Gallery", "My Auctions", "My Placed Bids","My Shop Art", "My Collections (6)", "Favorite Artists (6)", "Report", "Advertise Artwork"]
//        
//        arrImgDashboardList = ["profile","themes","create_event","post_artwork","create_bid","create_bid","inbox","orders","invite_friend","favorite","create_event","create_event","library","auction","placed_bid","placed_bid","collection","favroite_artist","report","advertise"]
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
        
        if UserDefaults.standard.object(forKey: "Theme") != nil
        {
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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - UIButton Event
    
    @IBAction func btnSectionClicked(_ sender: UIButton)
    {
        if arrSelectedOption.contains(sender.tag)
        {
            arrSelectedOption.remove(sender.tag)
        }
        else
        {
            arrSelectedOption.add(sender.tag)
        }
        
        tblDashboard.reloadData()
    }
    
    @IBAction func btnSideMenu(_ sender: UIButton)
    {
        appDelegate.sideMenuController.openMenu()
    }
    
    @IBAction func btnNotification(_ sender: UIButton)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        
        self.navigationController?.pushViewController(Noti, animated: true)
    }

    //MARK: - UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return arrDashboardSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if arrSelectedOption.contains(section)
        {
            switch section
            {
            case 0:
                return 2
            case 1:
                return 4
            case 2:
                return 3
            case 3:
                return 3
            case 4:
                return 3
            case 5:
                return 2
            case 6:
                return 1
            case 7:
                return 1
            case 8:
                return 1
            default:
                return 0
            }
            
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
     
        let viewBG = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        
        viewBG.backgroundColor = UIColor.clear

        let viewContent = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 39))
        viewContent.backgroundColor = UIColor.white
        
        let imgIcon = UIImageView(frame: CGRect(x: 8, y: 12, width: 16, height: 16))
        
        imgIcon.image = UIImage.init(named: arrDashboardSectionIcon.object(at: section) as! String)
        
        imgIcon.contentMode = .scaleAspectFit
        
        let lblTitle = UILabel(frame: CGRect(x: 32, y: 0, width: tableView.frame.size.width - 150, height: 39))
        lblTitle.text = arrDashboardSection.object(at: section) as? String
        lblTitle.font = fontSection
        lblTitle.textColor = UIColor(red: 16.0/255.0, green: 135.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        
        let btnArrow = UIButton(frame: CGRect(x: tableView.frame.size.width - 40, y: 5, width: 30, height: 30))
        
        btnArrow.setTitle("", for: .normal)
        btnArrow.setTitle("", for: .selected)

        btnArrow.setImage(UIImage.init(named: "down_arrow.png"), for: .normal)
        btnArrow.setImage(UIImage.init(named: "up_arrow.png"), for: .selected)

        viewBG.addSubview(lblTitle)
        viewBG.addSubview(btnArrow)

        let btnSection = UIButton(frame: viewContent.frame)
        
        btnSection.setTitle("", for: .normal)
        
        btnSection.addTarget(self, action: #selector(btnSectionClicked(_:)), for: .touchUpInside)
        btnSection.tag = section
        
        viewContent.addSubview(lblTitle)
        viewContent.addSubview(imgIcon)
        viewContent.addSubview(btnArrow)
        viewContent.addSubview(btnSection)
        viewBG.addSubview(viewContent)
        
        if arrSelectedOption.contains(section)
        {
            btnArrow.isSelected =  true
        }
        else
        {
            btnArrow.isSelected =  false
        }
        
        return viewBG
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "DeshboardMenuCell"
        var cell:DeshboardMenuCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DeshboardMenuCell
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("DeshboardMenuCell", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? DeshboardMenuCell
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
        }
        
        switch indexPath.section
        {
        case 0:

            switch indexPath.row {
            case 0:
                cell?.lblTitle.text = "My Profile"
            case 1:
                cell?.lblTitle.text = "Themes"
            default:
                cell?.lblTitle.text = ""
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                cell?.lblTitle.text = "Upload Artwork"
            case 1:
                cell?.lblTitle.text = "My Gallery"
            case 2:
                cell?.lblTitle.text = "Auction Artwork"
            case 3:
                cell?.lblTitle.text = "Auctioned Artwork"
            default:
                cell?.lblTitle.text = ""
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell?.lblTitle.text = "Upload Art Shop Product"
            case 1:
                cell?.lblTitle.text = "My Shop Arts"
            case 2:
                cell?.lblTitle.text = "Orders"
            default:
                cell?.lblTitle.text = ""
            }
        case 3:
            switch indexPath.row {
            case 0:
                cell?.lblTitle.text = "My Bids"
            case 1:
                cell?.lblTitle.text = "Favorite Artists"
            case 2:
                cell?.lblTitle.text = "Favorite"
            default:
                cell?.lblTitle.text = ""
            }
        case 4:
            switch indexPath.row
            {
            case 0:
                cell?.lblTitle.text = "Add Event"
            case 1:
                cell?.lblTitle.text = "Booked Events"
            case 2:
                cell?.lblTitle.text = "My Events"
            default:
                cell?.lblTitle.text = ""
            }
        case 5:
            switch indexPath.row
            {
            case 0:
                cell?.lblTitle.text = "Advertise Artwork"
            case 1:
                cell?.lblTitle.text = "Report"
            default:
                cell?.lblTitle.text = ""
            }
        case 6:
            switch indexPath.row
            {
            case 0:
                cell?.lblTitle.text = "Inbox"
            
            default:
                cell?.lblTitle.text = ""
            }
        case 7:
            switch indexPath.row
            {
            case 0:
                cell?.lblTitle.text = "Invite Friends"
            
            default:
                cell?.lblTitle.text = ""
            }
        case 8:
            switch indexPath.row
            {
            case 0:
                cell?.lblTitle.text = "My Collections"
                
            default:
                cell?.lblTitle.text = ""
            }        default:
            
            cell?.lblTitle.text = ""
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.section
        {
        case 0:
            switch indexPath.row
            {
            case 0:
                let MyPro  = MyProfileViewController(nibName:"MyProfileViewController", bundle:nil)
                self.navigationController?.pushViewController(MyPro, animated: true)
                break
            case 1:
                let theme = ChooseThemeScreen(nibName:"ChooseThemeScreen",bundle:nil)
                self.navigationController?.pushViewController(theme, animated: true)
                break
                
            default:
                break
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                let PostYour = PostYourArtworkVC(nibName:"PostYourArtworkVC",bundle:nil)
                self.navigationController?.pushViewController(PostYour, animated: true)
                break
            case 1:
                let MyLib = MyLibraryVC(nibName:"MyLibraryVC",bundle:nil)
                self.navigationController?.pushViewController(MyLib, animated: true)
                break
            case 2:
                let PostYour = AucationArtWorkScreen(nibName:"AucationArtWorkScreen",bundle:nil)
                self.navigationController?.pushViewController(PostYour, animated: true)
                break
            case 3:
                let MyAuction = MyAuctionViewController(nibName:"MyAuctionViewController",bundle:nil)
                self.navigationController?.pushViewController(MyAuction, animated: true)
                break
                
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                let ShopArt = UploadShopArtScreen(nibName:"UploadShopArtScreen",bundle:nil)
                self.navigationController?.pushViewController(ShopArt, animated: true)
                break
            case 1:
                let MyShopArt = MyShopArtScreen(nibName:"MyShopArtScreen",bundle:nil)
                self.navigationController?.pushViewController(MyShopArt, animated: true)
                break
            case 2:
                let order = orderVC(nibName:"orderVC",bundle:nil)
                self.navigationController?.pushViewController(order, animated: true)
                break
            default:
                break
            }
        case 3:
            switch indexPath.row {
            case 0:
                let MyPlace = MyPlacedBidsVC(nibName:"MyPlacedBidsVC",bundle:nil)
                self.navigationController?.pushViewController(MyPlace, animated: true)
                break
            case 1:
                let Fav = FavroiteViewController(nibName:"FavroiteViewController",bundle:nil)
                Fav.strFrom = "FromFavArtist"
                self.navigationController?.pushViewController(Fav, animated: true)
                break
            case 2:
                let Favroite = FavroiteViewController(nibName:"FavroiteViewController",bundle:nil)
                self.navigationController?.pushViewController(Favroite, animated: true)
                break
                
            default:
                break
                
            }
        case 4:
            switch indexPath.row
            {
            case 0:
                let Create = CreateEventsVC(nibName:"CreateEventsVC",bundle:nil)
                self.navigationController?.pushViewController(Create, animated: true)
                break
            case 1:
                let MyBooking = MyBookedEvents(nibName:"MyBookedEvents",bundle:nil)
                self.navigationController?.pushViewController(MyBooking, animated: true)
                break
            case 2:
                let MyEvent = MyEventScreen(nibName:"MyEventScreen",bundle:nil)
                self.navigationController?.pushViewController(MyEvent, animated: true)
                
                break
                
            default:
                break
            }
        case 5:
            switch indexPath.row
            {
            case 0:
                let post = postAdvertiseVC(nibName:"postAdvertiseVC",bundle:nil)
                self.navigationController?.pushViewController(post, animated: true)
                break
            case 1:
                let Report = ReportViewController(nibName:"ReportViewController",bundle:nil)
                self.navigationController?.pushViewController(Report, animated: true)
                break
                
            default:
                break
            }
        case 6:
            switch indexPath.row
            {
            case 0:
                let Message = MessageDetailsVC(nibName:"MessageDetailsVC",bundle:nil)
                self.navigationController?.pushViewController(Message, animated: true)
                break
                
            default:
                break
            }
        case 7:
            switch indexPath.row
            {
            case 0:
                let Invite = InviteFriendVC(nibName:"InviteFriendVC",bundle:nil)
                self.navigationController?.pushViewController(Invite, animated: true)
                break
                
            default:
                break
            }
            
        case 8:
            switch indexPath.row
            {
            case 0:
                let MyColl = MyCollectionsVC(nibName:"MyCollectionsVC",bundle:nil)
                self.navigationController?.pushViewController(MyColl, animated: true)
                break
                
            default:
                break
            }
            
        default:
            break
        }
        
       
        
//        if (indexPath as NSIndexPath).section == 0
//        {
//            switch (indexPath as NSIndexPath).row
//            {
//            case 0:
//                let MyPro  = MyProfileViewController(nibName:"MyProfileViewController", bundle:nil)
//                self.navigationController?.pushViewController(MyPro, animated: true)
//                break
//            case 1:
//                let theme = ChooseThemeScreen(nibName:"ChooseThemeScreen",bundle:nil)
//                self.navigationController?.pushViewController(theme, animated: true)
//                break
//            case 2:
//                let Create = CreateEventsVC(nibName:"CreateEventsVC",bundle:nil)
//                self.navigationController?.pushViewController(Create, animated: true)
//                break
//            case 3:
//                let PostYour = PostYourArtworkVC(nibName:"PostYourArtworkVC",bundle:nil)
//                self.navigationController?.pushViewController(PostYour, animated: true)
//                break
//            case 4:
//                let PostYour = AucationArtWorkScreen(nibName:"AucationArtWorkScreen",bundle:nil)
//                self.navigationController?.pushViewController(PostYour, animated: true)
//                break
//            case 5:
//                let ShopArt = UploadShopArtScreen(nibName:"UploadShopArtScreen",bundle:nil)
//                self.navigationController?.pushViewController(ShopArt, animated: true)
//                break
//            case 6:
//                let Message = MessageDetailsVC(nibName:"MessageDetailsVC",bundle:nil)
//                self.navigationController?.pushViewController(Message, animated: true)
//                break
//            case 7:
//                let order = orderVC(nibName:"orderVC",bundle:nil)
//                self.navigationController?.pushViewController(order, animated: true)
//                break
//                
//            case 8:
//                let Invite = InviteFriendVC(nibName:"InviteFriendVC",bundle:nil)
//                self.navigationController?.pushViewController(Invite, animated: true)
//                break
//                
//            case 9:
//                let Favroite = FavroiteViewController(nibName:"FavroiteViewController",bundle:nil)
//                self.navigationController?.pushViewController(Favroite, animated: true)
//                break
//                
//            case 10:
//                let MyBooking = MyBookedEvents(nibName:"MyBookedEvents",bundle:nil)
//                self.navigationController?.pushViewController(MyBooking, animated: true)
//                break
//                
//            case 11:
//                let MyEvent = MyEventScreen(nibName:"MyEventScreen",bundle:nil)
//                self.navigationController?.pushViewController(MyEvent, animated: true)
//                break
//                
//            case 12:
//                let MyLib = MyLibraryVC(nibName:"MyLibraryVC",bundle:nil)
//                self.navigationController?.pushViewController(MyLib, animated: true)
//                break
//            case 13:
//                let MyAuction = MyAuctionViewController(nibName:"MyAuctionViewController",bundle:nil)
//                self.navigationController?.pushViewController(MyAuction, animated: true)
//                break
//            case 14:
//                let MyPlace = MyPlacedBidsVC(nibName:"MyPlacedBidsVC",bundle:nil)
//                self.navigationController?.pushViewController(MyPlace, animated: true)
//                break
//                
//            case 15:
//                let MyShopArt = MyShopArtScreen(nibName:"MyShopArtScreen",bundle:nil)
//                self.navigationController?.pushViewController(MyShopArt, animated: true)
//                break
//                
//            case 16:
//                let MyColl = MyCollectionsVC(nibName:"MyCollectionsVC",bundle:nil)
//                self.navigationController?.pushViewController(MyColl, animated: true)
//                break
//            case 17:
//                let Fav = FavroiteViewController(nibName:"FavroiteViewController",bundle:nil)
//                Fav.strFrom = "FromFavArtist"
//                self.navigationController?.pushViewController(Fav, animated: true)
//                break
//            case 18:
//                let Fav = ReportViewController(nibName:"ReportViewController",bundle:nil)
//                self.navigationController?.pushViewController(Fav, animated: true)
//                break
//                
//            case 19:
//                let post = postAdvertiseVC(nibName:"postAdvertiseVC",bundle:nil)
//                self.navigationController?.pushViewController(post, animated: true)
//                break
//                
//            default:
//                
//                break;
//            }
//        }
            
                
                

}
}
