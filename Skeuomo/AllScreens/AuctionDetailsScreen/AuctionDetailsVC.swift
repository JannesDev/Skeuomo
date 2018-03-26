//
//  AuctionDetailsVC.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking

class AuctionDetailsVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblAuctionDetails: UITableView!
    
    var strArtworkId = ""
    var strArtworkTitle = ""

    @IBOutlet weak var lblPageTitle: UILabel!
    
    var dicAuctionDetail = NSDictionary()
    
    let  formater = DateFormatter()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tblAuctionDetails.tableFooterView = UIView()
        
        lblPageTitle.text = strArtworkTitle
        
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"

        
        // Do any additional setup after loading the view.
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetAuctionDetail), with: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAuctionDetail(notification:)), name: NSNotification.Name(rawValue: "UPDATEAUCTIONDETAIL"), object: nil)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
    
    func updateAuctionDetail(notification : NSNotification)
    {
        self.performSelector(inBackground: #selector(GetAuctionDetail), with: nil)

    }
    
    // MARK: - UIButtons

    @IBAction func btnViewCommentClicked(sender:UIButton)
    {
        let reviewVC  = ReviewAndCommentListScreen(nibName : "ReviewAndCommentListScreen", bundle: nil)
        
        reviewVC.strModule = "auction"
        reviewVC.strID = strArtworkId
        
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }
    
    @IBAction func btnSubmitClicked(sender:UIButton)
    {
        let reviewVC  = SubmitReviewRatingScreen(nibName : "SubmitReviewRatingScreen", bundle: nil)
        
        reviewVC.strModule = "auction"
        reviewVC.strID = strArtworkId
        
        self.present(reviewVC, animated: true, completion: nil)
    }
    
    @IBAction func btnback(_ sender: Any)
    {
       _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNotification(_ sender: Any)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    @IBAction func btnSearching(_ sender: Any)
    {
        
    }
    @IBAction func btnPlaceBid(_ sender: Any)
    {
        if dicAuctionDetail.allKeys.count > 0
        {
            
            print(dicAuctionDetail)
            
            
            let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)

            
            let auctionUserID = String(describing: dicAuctionDetail.object(forKey: "user_id") as! NSNumber)
            
            if strUserid as String == auctionUserID {
                
                HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: "You can not bid on own auction" , controller: self)
            }
            else
            {
                let TempPrice = dicAuctionDetail.object(forKey: "price") as! Int
                let TempHighestBid = dicAuctionDetail.object(forKey: "highestBid") as! Int
                let TempTotalBid = dicAuctionDetail.object(forKey: "totalBid") as! Int
                
                
                let placeBid = PlaceBidScreen(nibName: "PlaceBidScreen", bundle: nil)
                placeBid.totalBid = TempTotalBid
                placeBid.startPrice = TempPrice
                placeBid.highestBid = TempHighestBid
                placeBid.strAuctionId = String(dicAuctionDetail.object(forKey: "id") as! Int)
                
                
                _ = self.navigationController?.pushViewController(placeBid, animated: true)
            }
            
            
           
            
            
        }
    }
    
    // MARK: - UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if dicAuctionDetail.allKeys.count > 0
        {
            return 8
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 242
        }
        else  if indexPath.row == 1 ||  indexPath.row == 7
        {
            return 60
        }
        else  if indexPath.row == 2
        {
            return 76
        }
        else  if indexPath.row == 3
        {
            return 195
        }
        else  if  indexPath.row == 4
        {
            let strDes =  dicAuctionDetail.object(forKey: "description") as? String

            let font = UIFont.init(name: "Gibson-Regular", size: 12)
            
            let height = self.Method_HeightCalculation(text: strDes!, font: font!, width: tableView.frame.size.width - 16)
            
            if height > 20
            {
               return 40 + 8 + height + 10
            }
            
          return 45
            
        }
        else  if  indexPath.row == 5
        {
           return 76
        }
        else
        {
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cellIdentifier:String = "ColorImgTblCell"
            var cell:ColorImgTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ColorImgTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ColorImgTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ColorImgTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicAuctionDetail.object(forKey: "thumbnail") as? String)!)
            
            let urlImage = URL.init(string: urlStr as String)
            
            cell?.imgCollCell.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))
            
            return cell!

        }
        else if indexPath.row == 1
        {
            let cellIdentifier:String = "SharingBtnTblCell"
            var cell:SharingBtnTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SharingBtnTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("SharingBtnTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? SharingBtnTblCell
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
            
            let cellIdentifier:String = "ColorClientInfoTblCell"
            var cell:ColorClientInfoTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ColorClientInfoTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ColorClientInfoTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ColorClientInfoTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //For Incrase Separator Size
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            cell?.imgTblCell.layer.masksToBounds = true
            cell?.imgTblCell.layer.cornerRadius = (cell?.imgTblCell.frame.size.width)! / 2
            
            
            let strUserImage = (dicAuctionDetail.object(forKey: "user") as! NSDictionary).object(forKey: "profile_picture") as! String
            
            let urlStrUser = NSString(format: "%@%@",kSkeuomoImageURL,strUserImage)
            
            let urlImageUser = URL.init(string: urlStrUser as String)
            
            
            cell?.imgTblCell.setImageWith(urlImageUser!, placeholderImage: UIImage.init(named:"user_place"))

            
            
            
            
            let strUsername = String(format: "%@ %@", (dicAuctionDetail.object(forKey: "user") as! NSDictionary).object(forKey: "firstName") as! String, (dicAuctionDetail.object(forKey: "user") as! NSDictionary).object(forKey: "lastName") as! String)
            
            cell?.lblUserName.text = String(format: "By %@", strUsername)
            
            cell?.lblAddress.text = (dicAuctionDetail.object(forKey: "user") as! NSDictionary).object(forKey: "city") as? String
            
            return cell!

        }
        else if indexPath.row == 3
        {
            let cellIdentifier:String = "AuctionOtherDetailCell"
            var cell:AuctionOtherDetailCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? AuctionOtherDetailCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("AuctionOtherDetailCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? AuctionOtherDetailCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            cell?.lblSize.text = dicAuctionDetail.object(forKey: "size") as? String
            cell?.lblSubject.text = dicAuctionDetail.object(forKey: "subject") as? String
            cell?.lblGenre.text = dicAuctionDetail.object(forKey: "genre") as? String
            cell?.lblMedium.text = dicAuctionDetail.object(forKey: "medium") as? String
            cell?.lblMood.text = dicAuctionDetail.object(forKey: "mood") as? String

            return cell!
        }
        else  if indexPath.row == 4
        {
            let cellIdentifier:String = "AuctionDescriptionCell"
            var cell:AuctionDescriptionCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? AuctionDescriptionCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("AuctionDescriptionCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? AuctionDescriptionCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
            }
            
            //For Incrase Separator Size
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            cell?.lblDescription.text = dicAuctionDetail.object(forKey: "description") as? String
            
            return cell!
        }
        else  if indexPath.row == 5
        {
            let cellIdentifier:String = "ColorBidsTblCell"
            var cell:ColorBidsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ColorBidsTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ColorBidsTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ColorBidsTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            let TempPrice = dicAuctionDetail.object(forKey: "price") as! Int
            
            cell?.lblStartingPrice.text = String(format: "$%d", TempPrice)
            
            let TempHighestBid = dicAuctionDetail.object(forKey: "highestBid") as! Int
            
            cell?.lblHighestBid.text = String(format: "$%d", TempHighestBid)
            
            cell?.lblTotalBid.text = String(dicAuctionDetail.object(forKey: "totalBid") as! Int)
            
            return cell!
        }
            
        else if indexPath.row == 7
        {
            let cellIdentifier:String = "CreateCommentAndRatingCell"
            var cell:CreateCommentAndRatingCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CreateCommentAndRatingCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("CreateCommentAndRatingCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? CreateCommentAndRatingCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            
            cell?.btnSubmitReview.addTarget(self, action: #selector(btnSubmitClicked(sender:)), for: .touchUpInside)
            
            cell?.btnViewComments.addTarget(self, action: #selector(btnViewCommentClicked(sender:)), for: .touchUpInside)
            
            
            
            return cell!
        }
        else
        {
            let cellIdentifier:String = "ColorTimeDayTblCell"
            
            var cell:ColorTimeDayTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ColorTimeDayTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ColorTimeDayTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ColorTimeDayTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //For Incrase Separator Size
            
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            cell?.dateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handlePlaydAudioTimer(_:)), userInfo: NSNumber.init(value: indexPath.row), repeats: true)

            return cell!
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0
        {
            let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicAuctionDetail.object(forKey: "thumbnail") as? String)!)
            let zoom = ZoomInZoomOut(nibName: "ZoomInZoomOut", bundle: nil)
            zoom.imgUrl = urlStr
            self.navigationController?.pushViewController(zoom, animated: true)
            
        }
    }
    
    
    func handlePlaydAudioTimer(_ sender: Timer)
    {
        let x = sender.userInfo as! Int
        let indexPath = NSIndexPath.init(item: x, section: 0)
        var isVisble = false
        
        for cell in tblAuctionDetails.visibleCells
        {
            if cell is ColorTimeDayTblCell
            {
                let cellAuction = cell as! ColorTimeDayTblCell
                let indexPathNew = tblAuctionDetails.indexPath(for: cellAuction)
                if indexPath as IndexPath == indexPathNew!
                {
                    isVisble = true
                }
            }
        }
        
        if isVisble == false
        {
            return
        }
        
        let cell = tblAuctionDetails.cellForRow(at: indexPath as IndexPath) as! ColorTimeDayTblCell
        
        let endBid = dicAuctionDetail.object(forKey: "endBid") as! String
        
        let dateEndBid = formater.date(from: endBid)
        
        if dateEndBid! > Date()
        {
            let currentDate = NSDate()
            let diff = NSCalendar.current.dateComponents([.day, .hour, .minute, .second], from: currentDate as Date, to: dateEndBid!)
            
            let strDay = String(describing: diff.day!)
            let strHour = String(describing: diff.hour!)
            let strMin = String(describing: diff.minute!)
            let strSec = String(describing: diff.second!)
            
            cell.lblDays.text = strDay
            cell.lblHour.text = strHour
            cell.lblMin.text = strMin
            cell.lblSec.text = strSec
        }
    }
    
    
    //MARK: - Web Service Method
    
    func GetAuctionDetail()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)

        parameters.setValue(strUserid, forKey: "userid")
        
        parameters.setValue(strArtworkId, forKey: "id")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted
            { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending
        }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        
        let token = appDelegate.MD5(strforMD5 as String)
        
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@auction/detail?userid=%@&id=%@", kSkeuomoMainURL,strUserid,strArtworkId)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            self.dicAuctionDetail = DicResponseData.object(forKey: "auction") as! NSDictionary
                            
                            self.tblAuctionDetails.reloadData()
                        }
                        else
                        {
                            print("failed")
                            
                            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                        }
                }
                
            },
                    failure:{(operation, error) in
                        print("Error: " + (error.localizedDescription))
                        DispatchQueue.main.async
                            {
                                HelpingMethods.sharedInstance.hideHUD()
                        }
        })
        
    }
    
    
}
