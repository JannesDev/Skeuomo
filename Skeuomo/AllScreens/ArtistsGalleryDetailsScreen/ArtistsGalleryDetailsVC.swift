//
//  ArtistsGalleryDetailsVC.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking
import MobileCoreServices
import AVFoundation
import AVKit

class ArtistsGalleryDetailsVC: UIViewController, UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate, AVAudioPlayerDelegate
{

    @IBOutlet weak var tblArtistsData: UITableView!
    var pageTemp                    : UIPageControl!
    var clView                      : UICollectionView!
    
    var strArtworkId = ""
    var strArtworkTitle = ""
    
    @IBOutlet weak var lblPageTitle: UILabel!
    var dicArtworkDetail = NSMutableDictionary()

    
    var player : AVPlayer!
    var playerItem : AVPlayerItem!
    
    var timer1 : Timer!
    var progress : UIProgressView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblArtistsData.tableFooterView = UIView()
        lblPageTitle.text = strArtworkTitle
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetArtworkDetail), with: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)

    }

    func playerDidFinishPlaying(note: NSNotification)
    {
        // Your code here
        
        player = nil
        
        
        
        if timer1 != nil {
            
            timer1.invalidate()
            timer1 = nil
        }
        
        
        
        tblArtistsData.reloadData()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if player != nil {
            
            player.pause()
            player = nil
            
            
            if timer1 != nil {
                
                timer1.invalidate()
                timer1 = nil
            }
            
            
            
            if progress != nil {
                
                progress.progress = 0

            }
            
            tblArtistsData.reloadData()
        }

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UIButton Method
    
    @IBAction func btnLikeClicked(_ sender: UIButton)
    {
        
        let dicSend = NSMutableDictionary()
        
        dicSend.setValue(dicArtworkDetail.valueForNullableKey(key: "id"), forKey: "id")
        dicSend.setValue("artwork", forKey: "module_name")
        
        let count = dicArtworkDetail.object(forKey: "favCount") as! Int
        
        
        if dicArtworkDetail.valueForNullableKey(key: "is_favourite") == "1"
        {
            dicArtworkDetail.setValue(NSNumber.init(value: 0), forKey: "is_favourite")
            dicArtworkDetail.setValue(NSNumber.init(value: count-1), forKey: "favCount")

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadFavoriteArtwork"), object: NSNumber.init(value: 0))

        }
        else
        {
            dicArtworkDetail.setValue(NSNumber.init(value: 1), forKey: "is_favourite")
            dicArtworkDetail.setValue(NSNumber.init(value: count+1), forKey: "favCount")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadFavoriteArtwork"), object: NSNumber.init(value: 1))


        }
        
        
        
        
        
        self.performSelector(inBackground: #selector(AddFavorite(dataSend:)), with: dicSend)
        
        tblArtistsData.reloadData()
        
    }
    
    @IBAction func btnViewCommentClicked(sender:UIButton)
    {
        let reviewVC  = ReviewAndCommentListScreen(nibName : "ReviewAndCommentListScreen", bundle: nil)
        
        reviewVC.strModule = "artwork"
        reviewVC.strID = strArtworkId
        
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }
    @IBAction func btnSubmitClicked(sender:UIButton)
    {
        let reviewVC  = SubmitReviewRatingScreen(nibName : "SubmitReviewRatingScreen", bundle: nil)
        
        reviewVC.strModule = "artwork"
        reviewVC.strID = strArtworkId
        
        self.present(reviewVC, animated: true, completion: nil)
    }
    
    func btnPlayAudio(sender:UIButton!)
    {
        if dicArtworkDetail.object(forKey: "audio") != nil && (dicArtworkDetail.object(forKey: "audio") as! String).characters.count > 0
        {
            if player == nil
            {
                let strMainPath: String = dicArtworkDetail.object(forKey: "audio") as! String
                let Url = URL.init(string: String(format: "%@%@", kSkeuomoImageURL,strMainPath))
                sender.setImage(UIImage.init(named: "pause.png"), for: UIControlState.normal)
                
                playerItem = AVPlayerItem(url: Url! as URL)
                let audioSession = AVAudioSession.sharedInstance()
                
                do
                {
                    try audioSession.setCategory(AVAudioSessionCategoryPlayback)
                    try audioSession.setActive(true)
                }
                catch
                {
                    print("AVAudioSession cannot be set")
                }
                
                let asset = AVAsset(url: Url! as URL)
                let anItem = AVPlayerItem(asset: asset)
                player = AVPlayer.init(playerItem: anItem)
                
                player = AVPlayer(url: Url! as URL)
                player.play()
                
                timer1 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handlePlaydAudioTimer(_:)), userInfo: nil, repeats: true)
                
                
            }
            else
            {
                if player.rate == 1.0
                {
                    player.pause()
                    sender.setImage(UIImage.init(named: "play-b.png"), for: UIControlState.normal)
                }
                else
                {
                    player.play()
                    
                    sender.setImage(UIImage.init(named: "pause.png"), for: UIControlState.normal)
                    
                }
            }

            
        }
        
            
        
            
            
    }
    
    func handlePlaydAudioTimer(_ sender: Any)
    {
        
        let audioDuration = playerItem.asset.duration
        
        let currentTime:Float = Float(CMTimeGetSeconds(player.currentTime()))
        
        let totalDuration:Float = Float(CMTimeGetSeconds(audioDuration))
        
        progress.progress = currentTime / totalDuration
        
    }
    
    
    @IBAction func btnBack(_ sender: Any)
    {
       _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNotification(_ sender: Any)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    
    @IBAction func btnSearching(_ sender: Any) {
    }
    @IBAction func btnAddToCart(_ sender: Any) {
    }
    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if dicArtworkDetail.allKeys.count > 0
        {
            return 7
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 256
        }
        else  if indexPath.row == 1
        {
            
            if dicArtworkDetail.object(forKey: "audio") != nil && (dicArtworkDetail.object(forKey: "audio") as! String).characters.count > 0
            {
                return 127
            }
            
            return 65
        }
        else  if indexPath.row == 2
        {
            return 200
        }
        else if indexPath.row == 3
        {
            return 66
        }
        else if indexPath.row == 4 || indexPath.row == 6
        {
            return 60
        }
        else
        {
            
            let strDes =  dicArtworkDetail.object(forKey: "description") as? String
            
            let font = UIFont.init(name: "Gibson-Regular", size: 12)
            
            
            let height = self.Method_HeightCalculation(text: strDes!, font: font!, width: tableView.frame.size.width - 28)
            
            
            if height > 20
            {
                return 40 + 8 + height + 10
            }
            
            return 45
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cellIdentifier:String = "ImgShowTblCell"
            
            var cell:ImgShowTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ImgShowTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ImgShowTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ImgShowTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            let nib = UINib(nibName: "ImgShowCollectionCell", bundle: nil)
            cell?.collectionImgShow.register(nib,forCellWithReuseIdentifier: "ImgShowCollectionCell")
            
            cell?.collectionImgShow.delegate = self
            cell?.collectionImgShow.dataSource = self
            

            
            if dicArtworkDetail.object(forKey: "video") != nil &&  (dicArtworkDetail.object(forKey: "video") as! String ).characters.count > 0
            {
                cell?.page.numberOfPages = 2
            }
            else
            {
                cell?.page.numberOfPages = 1

            }

            pageTemp = cell?.page

            clView = cell?.collectionImgShow
            
            // cell?.btnDropDown.tag = indexPath.section
            //cell?.btnDropDown.addTarget(self,action: #selector(btnSelectDropDown),for: UIControlEvents.touchUpInside)
            
            return cell!
            
        }
        else  if indexPath.row == 1
        {
            let cellIdentifier:String = "ColorsHairTblCell"
            var cell:ColorsHairTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ColorsHairTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ColorsHairTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ColorsHairTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            cell?.imgTblCell.layer.masksToBounds = true
            cell?.imgTblCell.layer.cornerRadius = (cell?.imgTblCell.frame.size.width)! / 2
            
            let strUserImage = (dicArtworkDetail.object(forKey: "user") as! NSDictionary).object(forKey: "profile_picture") as! String
            
            let urlStrUser = NSString(format: "%@%@",kSkeuomoImageURL,strUserImage)
            
            let urlImageUser = URL.init(string: urlStrUser as String)
            
            
            cell?.imgTblCell.setImageWith(urlImageUser!, placeholderImage: UIImage.init(named:"user_place"))
            
            
            
            
            
            let strUsername = String(format: "%@ %@", (dicArtworkDetail.object(forKey: "user") as! NSDictionary).object(forKey: "firstName") as! String, (dicArtworkDetail.object(forKey: "user") as! NSDictionary).object(forKey: "lastName") as! String)
            
            cell?.lblUserName.text = String(format: "By %@", strUsername)
            
            cell?.lblAddress.text = (dicArtworkDetail.object(forKey: "user") as! NSDictionary).object(forKey: "city") as? String
            
            
            if dicArtworkDetail.object(forKey: "audio") != nil && (dicArtworkDetail.object(forKey: "audio") as! String).characters.count > 0
            {
                
                cell?.btnPlayAudio.isHidden = false
                cell?.progressAudio.isHidden = false
                cell?.btnPlayAudio.addTarget(self, action: #selector(btnPlayAudio(sender:)), for: .touchUpInside)
                
                
                cell?.progressAudio.progress = 0
                
                progress = cell?.progressAudio
                
                
                if player != nil {
                    
                    if player.rate == 1.0
                    {
                        cell?.btnPlayAudio.setImage(UIImage.init(named: "pause.png"), for: UIControlState.normal)
                    }
                    else
                    {
                        cell?.btnPlayAudio.setImage(UIImage.init(named: "play-b.png"), for: UIControlState.normal)
                    }
                }
                else
                {
                    cell?.btnPlayAudio.setImage(UIImage.init(named: "play-b.png"), for: UIControlState.normal)
                }
                
            }
            else
            {
                cell?.btnPlayAudio.isHidden = true
                cell?.progressAudio.isHidden = true
            }
            
            
            return cell!
            
        }
        else  if indexPath.row == 2
        {
            let cellIdentifier:String = "PaintingDetailsTblCell"
            var cell:PaintingDetailsTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PaintingDetailsTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("PaintingDetailsTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? PaintingDetailsTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            
            cell?.lblDetails.text = "DETAILS"
            
            cell?.lblSize.text = dicArtworkDetail.object(forKey: "size") as? String
            cell?.lblSubject.text = dicArtworkDetail.object(forKey: "subject") as? String
            cell?.lblGenre.text = dicArtworkDetail.object(forKey: "genre") as? String
            cell?.lblMedium.text = dicArtworkDetail.object(forKey: "medium") as? String
            cell?.lblMood.text = dicArtworkDetail.object(forKey: "mood") as? String
            
            
            return cell!
        }
        else  if indexPath.row == 3
        {
            let cellIdentifier:String = "ShippingConditionTblCell"
            var cell:ShippingConditionTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ShippingConditionTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ShippingConditionTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ShippingConditionTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            
            let TempPrice = dicArtworkDetail.object(forKey: "price") as! Int
            cell?.lblPrice.text = String(format: "$%d CAD", TempPrice)
            
            return cell!
        }
        else if indexPath.row == 4
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
            
            if dicArtworkDetail.valueForNullableKey(key: "favCount") == ""
            {
                cell?.lblFavCount.text = "0"
            }
            else
            {
                cell?.lblFavCount.text = dicArtworkDetail.valueForNullableKey(key: "favCount")
            }
            
            if dicArtworkDetail.valueForNullableKey(key: "viewcount") == ""
            {
                cell?.lblViewCount.text = "0"
            }
            else
            {
                cell?.lblViewCount.text = dicArtworkDetail.valueForNullableKey(key: "viewcount")
            }
            
            
            
            if dicArtworkDetail.valueForNullableKey(key: "is_favourite") == "1"
            {
                cell?.btnLike.isSelected = true
            }
            else
            {
                cell?.btnLike.isSelected = false
            }
            
            cell?.btnLike.tag = indexPath.row
            cell?.btnLike.addTarget(self, action: #selector(btnLikeClicked(_:)), for: .touchUpInside)
            
            
            
            
            
            
            return cell!
        }
        else if indexPath.row == 6
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
            let cellIdentifier:String = "DecriptionTblCell"
            var cell:DecriptionTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DecriptionTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("DecriptionTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? DecriptionTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            
            cell?.lblTitle.text = "ART DESCRIPTION"
            
            cell?.lblDescription.text = dicArtworkDetail.object(forKey: "description") as? String
            
            
            return cell!
        }

    }
    //MARK: - UIScrollView Delegates
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if (scrollView is UICollectionView)
        {
            let value : CGFloat = scrollView.contentOffset.x / scrollView.frame.size.width
            
            pageTemp.currentPage = Int(value)
        }
    }

    // MARK: - UICollection View Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if dicArtworkDetail.object(forKey: "video") != nil &&  (dicArtworkDetail.object(forKey: "video") as! String ).characters.count > 0
        {
            return 2
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (collectionView.frame.size.width), height: 246)
    }
    // make a cell for each cell index path
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgShowCollectionCell", for: indexPath as IndexPath) as! ImgShowCollectionCell
        
        if indexPath.row == 0
        {
            cell.btnPlayVide.isHidden = true
            
            let strImageUrl = dicArtworkDetail.object(forKey: "artworkImage") as! String
            
            
            let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,strImageUrl)
            
            let urlImage = URL.init(string: urlStr as String)
            
            
            cell.imgCollection.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))
        }
        else
        {
            
            cell.btnPlayVide.isHidden = false

            
            let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicArtworkDetail.object(forKey: "thumbnail") as? String)!)
            
            let urlImage = URL.init(string: urlStr as String)
            
            cell.imgCollection.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"art-place.png"))

            
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 1 {
            
            
            if player != nil {
                
                player.pause()
                player = nil
                
                
                if timer1 != nil {
                    
                    timer1.invalidate()
                    timer1 = nil
                }

                progress.progress = 0
                
                tblArtistsData.reloadData()
            }
            
            
            let strVideoUrl = dicArtworkDetail.object(forKey: "video") as! String
            
            let Url = URL.init(string: String(format: "%@%@", kSkeuomoImageURL,strVideoUrl))
            
            
            player = AVPlayer(url: Url!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true)
            {
                playerViewController.player!.play()
            }
        }
        else
        {
            let strImageUrl = dicArtworkDetail.object(forKey: "artworkImage") as! String
            
            let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,strImageUrl)
            
            let zoom = ZoomInZoomOut(nibName: "ZoomInZoomOut", bundle: nil)
            zoom.imgUrl = urlStr
            self.navigationController?.pushViewController(zoom, animated: true)
            
        }
    }
    
    //MARK: - Web Service Method
    
    func AddFavorite(dataSend : NSMutableDictionary)
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        parameters.setObject(dataSend.valueForNullableKey(key: "module_name"), forKey: "module_name" as NSCopying)
        
        parameters.setObject(dataSend.valueForNullableKey(key: "id"), forKey: "id" as NSCopying)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@makeFavourite", kSkeuomoMainURL)
        manager.post(url as String, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            DispatchQueue.main.async
                {
                    HelpingMethods.sharedInstance.hideHUD()
                    
                    print((responseObject as! NSDictionary))
                    
                    if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                    {
                        //  HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                    }
                    else
                    {
                        print("failed")
                        
                        HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                    }
            }
            
        }) { (task: URLSessionDataTask?, error: Error) in
            
            print("POST fails with error \(error.localizedDescription)")
            DispatchQueue.main.async
                {
                    HelpingMethods.sharedInstance.hideHUD()
                    
                    HelpingMethods.sharedInstance.Showerrormessage(error: error, controller: self)
            }
            
        }
        
    }
    
    func GetArtworkDetail()
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
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        let  url  = String(format: "%@artwork/detail?userid=%@&id=%@", kSkeuomoMainURL,strUserid,strArtworkId)
        
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            self.dicArtworkDetail = (DicResponseData.object(forKey: "artwork") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            
                            self.tblArtistsData.reloadData()
                            
                        }
                        else
                        {
                            print("Failed")
                            
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
