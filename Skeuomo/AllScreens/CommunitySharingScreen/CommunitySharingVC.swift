
//
//  CommunitySharingVC.swift
//  Skeuomo
//
//  Created by by Jannes on 24/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import MobileCoreServices
import AFNetworking
import youtube_ios_player_helper

import Alamofire
import AlamofireImage

import XCDYouTubeKit

class CommunitySharingVC: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate , YTPlayerViewDelegate
{
    @IBOutlet var tool: UIToolbar!
    
    @IBOutlet weak var tblComunityData: UITableView!
    
    @IBOutlet var vieSharingBtns: UIView!
    
    var fromSideMenu = ""
    
    @IBOutlet weak var btnBackSide: UIButton!
    
    @IBOutlet weak var btnclose: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnFetch: UIButton!


    
    let fontDescription = UIFont.init(name: "Gibson-Regular", size: 12)

    var selectedIndexToDelete = 0

    @IBOutlet var viewAddVideo: UIView!
    
    @IBOutlet weak var viewAddVideoInside: UIView!
    
    

    
    // Post
    var strVideoUrl = ""
    var strPostDescription = ""
    
    var imgData = Data()

    var currentPage = 1
    var totalPage = 0
    var totalPageRecord = 0
    
    var arrPost = NSMutableArray()
    var spinner : UIActivityIndicatorView!
    
    
    var dateFormateServer             :DateFormatter!
    var dateFormate                   :DateFormatter!
    
    var YouTubePlayer = YTPlayerView()
    
    //Add Video View
    
    @IBOutlet weak var ytFetchVideo: YTPlayerView!
    
    @IBOutlet weak var txtYTUrl: UITextField!
    
    var refreshControl : UIRefreshControl!
    var boolCmtGetData = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        txtYTUrl.inputAccessoryView = tool

        
        dateFormateServer  = DateFormatter()
        dateFormateServer.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        dateFormate  = DateFormatter()
        dateFormate.dateFormat = "MMMM dd, YYYY HH:mm:ss a"
        
        
        YouTubePlayer.delegate = self
        ytFetchVideo.delegate = self

        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetMyWallPost), with: nil)
        
        
        refreshControl = UIRefreshControl()
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *)
        {
            tblComunityData.refreshControl = refreshControl
        }
        else
        {
            tblComunityData.addSubview(refreshControl)
        }
        
        
        btnclose.layer.masksToBounds = true
        btnclose.layer.cornerRadius = 2
        btnclose.layer.borderColor = UIColor.lightGray.cgColor
        btnclose.layer.borderWidth = 1
        
        btnUpload.layer.masksToBounds = true
        btnUpload.layer.cornerRadius = 2
        btnUpload.layer.borderColor = UIColor.lightGray.cgColor
        btnUpload.layer.borderWidth = 1

        btnFetch.layer.masksToBounds = true
        btnFetch.layer.cornerRadius = 2
        btnFetch.layer.borderColor = UIColor.lightGray.cgColor
        btnFetch.layer.borderWidth = 1
    }
    
    func refreshWeatherData(_ sender: Any)
    {
        if !boolCmtGetData
        {
            boolCmtGetData = true
            currentPage = 1
            performSelector(inBackground: #selector(self.GetMyWallPost), with: nil)
        }
        
        let when = DispatchTime.now() + 3
        
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            // Your code with delay
            self.refreshControl.endRefreshing()
        }

    }
    
    override func didReceiveMemoryWarning()
    {
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
    
    //MARK: - YTPlayerViewDelegate
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        
        print(error)
        
        
        
    }
    
    //MARK: - textFieldMethods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        strVideoUrl = textField.text!
    }
    
    //MARK: - UITextView Delegate 
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        strPostDescription = textView.text!
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text == "" && text == " "
        {
            return false
        }
        
        return true
        
    }
    
    
    
    //MARK: - UIImagePicker Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        self.dismiss(animated: true, completion: nil)
        
        imgData = UIImageJPEGRepresentation((info[UIImagePickerControllerEditedImage] as? UIImage)!, 0.8)!
        
        tblComunityData.reloadData()
        
    }
    
    //MARK: - UIButtons Method
    
    @IBAction func btnPlayVideoFeed(_ sender: UIButton)
    {
        let dicPost = arrPost.object(at: sender.tag) as! NSDictionary
        
        let strVideoUrl = dicPost.object(forKey: "video") as! String
        
        let fileName = strVideoUrl.youtubeID
        
        let videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: fileName)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.moviePlayerPlaybackDidFinish), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: videoPlayerViewController.moviePlayer)
        
        presentMoviePlayerViewControllerAnimated(videoPlayerViewController)
        
    }
    
    
    @IBAction func btnDeletePostClick(_ sender: UIButton)
    {
        selectedIndexToDelete = sender.tag
        
        
        
        let actionSheet = UIAlertController(title: nil, message: "Are you sure want to delete this post", preferredStyle: UIAlertControllerStyle.alert)
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            
            let dicPost = self.arrPost.object(at: sender.tag) as! NSDictionary
            let strPostId = dicPost.valueForNullableKey(key: "id")
            
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(self.DeletePost(PostId:)), with: strPostId)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
       
        
    }

    
    
    @IBAction func btnLikePost(_ sender: UIButton)
    {
        let dicPost = (arrPost.object(at: sender.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary

        let dicData = NSMutableDictionary()
        
        dicData.setValue(dicPost.valueForNullableKey(key: "id"), forKey: "id")
        
        var Likes = dicPost.object(forKey: "likes") as! Int
        
        if dicPost.object(forKey: "is_like") as! Int == 0
        {

            Likes += 1
            
            let strLike = String(format: "Likes (%d)", Likes)
            
            sender.setTitle(strLike, for: .normal)
            
            sender.setImage(UIImage.init(named: "whish"), for: .normal)
            
            dicData.setValue("1", forKey: "like")
            
            dicPost.setValue(NSNumber.init(value: 1), forKey: "is_like")
            dicPost.setValue(NSNumber.init(value: Likes), forKey: "likes")

        }
        else
        {
            Likes -= 1
            
            if Likes == 0
            {
                sender.setTitle("Like", for: .normal)
            }
            else
            {
                let strLike = String(format: "Likes (%d)", Likes)
                
                sender.setTitle(strLike, for: .normal)
            }
            
            sender.setImage(UIImage.init(named: "wish"), for: .normal)
            
            dicData.setValue("0", forKey: "like")

            dicPost.setValue(NSNumber.init(value: 0), forKey: "is_like")
            dicPost.setValue(NSNumber.init(value: Likes), forKey: "likes")
        }
        
        self.performSelector(inBackground: #selector(LikeOnPost(dicData:)), with: dicData)
        
        arrPost.replaceObject(at: sender.tag, with: dicPost.mutableCopy() as! NSDictionary)
        
    }
    
    
    @IBAction func btnCloseAddVideoView(_ sender: AnyObject)
    {
        strVideoUrl = ""
        
        viewAddVideo.removeFromSuperview()
    }
    
    @IBAction func uploadVideoUrl(_ sender: AnyObject)
    {
        print(strVideoUrl)
        
        strVideoUrl = txtYTUrl.text!
        
        viewAddVideo.removeFromSuperview()
        
        tblComunityData.reloadData()
        
    }
    
    
    @IBAction func btnAddVideo(sender : UIButton)
    {
        self.view.endEditing(true)
        
        strVideoUrl = ""
        
        txtYTUrl.text = ""
        
        self.view.addSubview(viewAddVideo)
        
        viewAddVideo.frame = self.view.frame
        
        viewAddVideoInside.frame = CGRect(x: 0, y: 183, width: UIScreen.main.bounds.size.width, height: 150)
        
        ytFetchVideo.isHidden =  true
        
    }
    
    @IBAction func btnPlayYoutubeVideo(sender : UIButton)
    {
        
        YouTubePlayer.playVideo()
        
    }
    
    
    @IBAction func btnFetchVideo(sender : UIButton)
    {
        self.view.endEditing(true)
        
        if strVideoUrl.characters.count == 0 {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please enter youtube video url to fetch details", controller: self)
            return
        }
        
        let strVideoId = strVideoUrl.youtubeID
        
        if strVideoId != nil
        {
            viewAddVideoInside.frame = CGRect(x: 0, y: 183, width: UIScreen.main.bounds.size.width, height: 301)
            
            ytFetchVideo.isHidden =  false
            
            if (strVideoId?.characters.count)! > 0
            {
                var dicPlayerVars = [String : Any]()
                
                dicPlayerVars["playsinline"] = "1"
                
                YouTubePlayer.load(withVideoId: strVideoId!, playerVars: dicPlayerVars)
                
                ytFetchVideo.load(withVideoId: strVideoId!, playerVars: dicPlayerVars)
                
                
                // tblComunityData.reloadData()
            }
            else
            {
                
                strVideoUrl = ""
                
                txtYTUrl.text = strVideoUrl
                
                HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Invalid Url", controller: self)
            }
            
        }
        else
        {
            
            strVideoUrl = ""
            
            txtYTUrl.text = strVideoUrl
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Invalid Url", controller: self)

        }
        
        
        
    }
    
    func btnPostOnWall(sender:UIButton!)
    {
        self.view.endEditing(true)
        
        if strPostDescription.characters.count == 0 && imgData.count == 0 && strVideoUrl.characters.count == 0
        {            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Please write about post or select media to post", controller: self)
            return
        }
        
    
        if strVideoUrl.characters.count > 0 && strVideoUrl.youtubeID == nil {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "", strSubtitle: "Invaild video url", controller: self)
            return
        }
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(PostOnWall), with: nil)
    }
    
    func btnOpenCamera(sender:UIButton!)
    {
        self.view.endEditing(true)
        
        
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            
            let picker = UIImagePickerController()
            picker.delegate = self
            
            picker.allowsEditing = true
            
            picker.sourceType = UIImagePickerControllerSourceType.camera
            
            
            picker.mediaTypes = [kUTTypeImage as String]
            
            
            picker.modalPresentationStyle = .fullScreen
            present(picker,
                    animated: true,
                    completion: nil)
        }
        else
        {
            appDelegate.ShowAlert(message: "No Camera Found")
        }
        
    }
    
    func photoLibrary()
    {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        picker.allowsEditing = true
        
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        picker.mediaTypes = [kUTTypeImage as String]
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func btnDoneToolBar(_ sender: AnyObject)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func btnSearching(_ sender: Any)
    {
    }
    
    @IBAction func btnNotification(_ sender: Any)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    @IBAction func btnSideMenu(_ sender: Any)
    {
        if fromSideMenu == "FromSideMenu"
        {
           _ = self.navigationController?.popViewController(animated: true)
        }
        else
        {
            self.appDelegate.sideMenuController.openMenu()
        }
    }
    @IBAction func btnAllSharing(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnClose(_ sender: Any)
    {
        self.vieSharingBtns.removeFromSuperview()
    }
    func btnOpentShareOption(sender:UIButton)
    {
        self.vieSharingBtns.frame = self.view.frame
        self.view.addSubview(vieSharingBtns)
    }
    func btnOpentCommentShow(sender:UIButton)
    {
        
        let tag = sender.tag
        
        print(tag)
        
        let dicPost = arrPost.object(at: tag) as! NSDictionary
        
        let strPostId = dicPost.valueForNullableKey(key: "id")
        
        
        
        let comment = communityCommentVC(nibName:"communityCommentVC",bundle:nil)
        comment.strPostId = strPostId
        self.navigationController?.pushViewController(comment, animated: true)
    }
    
    
    
    //MARK: - Gesture Methods
    
    func handleTapGesture(gesture : UIGestureRecognizer)
    {
        
        let dicPost = arrPost.object(at: (gesture.view?.tag)!) as! NSDictionary

        
        let strImage = dicPost.object(forKey: "image") as! String
        let urlStrImage = NSString(format: "%@%@",kSkeuomoImageURL,strImage)
        
        let zoom = ZoomInZoomOut(nibName: "ZoomInZoomOut", bundle: nil)
        zoom.imgUrl = urlStrImage
        self.navigationController?.pushViewController(zoom, animated: true)
        
    }
    
    //MARK: - UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(currentPage < totalPage)
        {
            // 1 for spinner and 1 for post cell
            return arrPost.count + 1 + 1
        }
        else
        {
            // 1 for post cell
            return arrPost.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            if imgData.count > 0 && strVideoUrl.characters.count > 0
            {
                return 386
            }
            else if imgData.count > 0 || strVideoUrl.characters.count > 0
            {
                return 5 + 54 + 8 + 130 + 8 + 40 + 4
            }
            
            return 54 + 40 + 10 + 8
        }
        else
        {
            if indexPath.row == arrPost.count + 1
            {
                return 44
            }
            
            let dicPost = arrPost.object(at: indexPath.row - 1) as! NSDictionary
            
            let strDes =  dicPost.object(forKey: "post") as? String

            
            if (dicPost.object(forKey: "image") as! String).characters.count > 0 && (dicPost.object(forKey: "video") as! String).characters.count > 0
            {
                let TotalHeight : CGFloat = 417.0
                
                let ExtraHeight : CGFloat = 15.0
                
                if strDes?.characters.count == 0
                {
                    return TotalHeight
                }
                else
                {
                    let height = self.Method_HeightCalculation(text: strDes!, font: fontDescription!, width: UIScreen.main.bounds.size.width - 36-22)
                    
                    return TotalHeight + height + ExtraHeight
                }
            }
           else if (dicPost.object(forKey: "image") as! String).characters.count > 0 || (dicPost.object(forKey: "video") as! String).characters.count > 0
            {
             
                let TotalHeight : CGFloat = 264.0
                let ExtraHeight : CGFloat = 15.0
                
                if strDes?.characters.count == 0
                {
                    return TotalHeight
                }
                else
                {
                    let height = self.Method_HeightCalculation(text: strDes!, font: fontDescription!, width: UIScreen.main.bounds.size.width - 36-22)
                    
                    return TotalHeight + height + ExtraHeight
                    
                }
                
            }
            else
            {
                
                let TotalHeight : CGFloat = 90.0
                let ExtraHeight : CGFloat = 15.0

                
                let height = self.Method_HeightCalculation(text: strDes!, font: fontDescription!, width: UIScreen.main.bounds.size.width - 36-22)
                
                if height > 30
                {
                    return TotalHeight + height + ExtraHeight
                }
                else
                {
                    return TotalHeight + 35.0

                }
            }
            
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cellIdentifier:String = "ImageShowTblCell"
            var cell:ImageShowTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ImageShowTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ImageShowTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ImageShowTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            
            cell?.btnAddPhoto.addTarget(self, action: #selector(btnOpenCamera(sender:)), for: .touchUpInside)
            
            cell?.btnPost.addTarget(self, action: #selector(btnPostOnWall(sender:)), for: .touchUpInside)
            
            cell?.btnAddVideo.addTarget(self, action: #selector(btnAddVideo(sender:)), for: .touchUpInside)
            
            
            
            cell?.txtWrite.delegate = self
            
            cell?.txtWrite.placeholder = "Write something..."
            
            cell?.txtWrite.text = self.strPostDescription
            
            cell?.txtWrite.inputAccessoryView = tool
            
            cell?.viewImage.isHidden = true
            cell?.viewMedia.isHidden = true
            
            if imgData.count > 0
            {
                cell?.imgPost.image = UIImage.init(data: imgData)
                cell?.viewImage.isHidden = false
            }
            
            if strVideoUrl.characters.count > 0
            {                
                var rect = cell?.viewImage.frame
                
                if imgData.count > 0
                {
                    rect?.origin.y = (rect?.origin.y)! + 130 + 8
                    
                    cell?.viewMedia.frame = rect!
                }
                else
                {
                    cell?.viewMedia.frame = rect!
                    
                }
                
                cell?.viewMedia.isHidden = false

                cell?.viewMedia.addSubview(YouTubePlayer)
                
                YouTubePlayer.frame = CGRect(x: 0, y: 0, width: (cell?.viewMedia.frame.size.width)!, height: (cell?.viewMedia.frame.size.height)!)
                
            }
            
            cell?.layer.masksToBounds = true
            
            return cell!
        }
        else
        {
            if indexPath.row == arrPost.count + 1
            {
                var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                
                if (cell == nil)
                {
                    cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
                    
                    spinner = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
                    spinner.frame = CGRect(x: (tableView.frame.size.width-20)/2, y: 12, width: 20, height: 20)
                    
                    cell?.addSubview(spinner)
                    
                }
                
                spinner.startAnimating()
                
                return cell!
            }
            
            let dicPost = arrPost.object(at: indexPath.row - 1) as! NSDictionary
            
            let strDes = (dicPost.object(forKey: "post") as? String)!
            
            let dicUser = dicPost.object(forKey: "user") as! NSDictionary
            
            
            let strUserImage = dicUser.object(forKey: "profile_picture") as! String
            let urlStrUser = NSString(format: "%@%@",kSkeuomoImageURL,strUserImage)
            let urlImageUser = URL.init(string: urlStrUser as String)
            
            let CreateDate = dateFormateServer.date(from: dicPost.valueForNullableKey(key: "created_at"))
            
            var strCreatedDate = ""
            
            
            if CreateDate != nil
            {
               strCreatedDate = dateFormate.string(from: CreateDate!)
            }
            
            
            
            if (dicPost.object(forKey: "image") as! String).characters.count > 0 && (dicPost.object(forKey: "video") as! String).characters.count > 0
            {
                let cellIdentifier:String = "WritePostTblCell"
                var cell:WritePostTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WritePostTblCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("WritePostTblCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? WritePostTblCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                }
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))

                
                cell?.imgPhoto.addGestureRecognizer(tapGesture)
                cell?.imgPhoto.tag = indexPath.row - 1
                
                cell?.imgPhoto.isUserInteractionEnabled = true
                
                
                cell?.btnComments.addTarget(self,action: #selector(btnOpentCommentShow),for: UIControlEvents.touchUpInside)
                
                cell?.btnComments.tag = indexPath.row - 1
                
                
                cell?.btnPlay.addTarget(self,action: #selector(btnPlayVideoFeed(_:)),for: UIControlEvents.touchUpInside)
                
                cell?.btnPlay.tag = indexPath.row - 1
                
                
                cell?.btnDelete.addTarget(self, action: #selector(btnDeletePostClick(_:)), for: .touchUpInside)
                cell?.btnDelete.tag = indexPath.row - 1
                
                let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
                
                let strCommentedUserId = dicPost.valueForNullableKey(key: "user_id")
                
                if strUserid as String == strCommentedUserId
                {
                    cell?.btnDelete.isHidden = false
                }
                else
                {
                    cell?.btnDelete.isHidden = true
                }

                
                cell?.btnLike.addTarget(self,action: #selector(btnLikePost(_:)),for: UIControlEvents.touchUpInside)
                cell?.btnLike.tag = indexPath.row - 1
                
                cell?.btnSharing.addTarget(self,action: #selector(btnOpentShareOption),for: UIControlEvents.touchUpInside)
                
                cell?.txtDescription.text = strDes
                
                cell?.viewPhoto.isHidden =  false
                cell?.viewVideoMedia.isHidden =  false
                
                
                let Likes = dicPost.object(forKey: "likes") as! Int
                
                if Likes == 0
                {
                    cell?.btnLike.setTitle("Like", for: .normal)
                }
                else
                {
                    let strLike = String(format: "Likes (%d)", Likes)
                    
                    cell?.btnLike.setTitle(strLike, for: .normal)
                }
                
                
                if dicPost.object(forKey: "is_like") as! Int == 0
                {
                    cell?.btnLike.setImage(UIImage.init(named: "wish"), for: .normal)
                }
                else
                {
                    cell?.btnLike.setImage(UIImage.init(named: "whish"), for: .normal)
                }
                
                
                if strDes.characters.count == 0
                {
                    cell?.txtDescription.isHidden = true
                    
                    
                    cell?.viewPhoto.frame = CGRect(x: 0, y: 58 , width: (cell?.frame.size.width)!, height: 145)

                    
                    cell?.viewVideoMedia.frame = CGRect(x: 0, y: (cell?.viewPhoto.frame.size.height)! + 58 + 8 , width: (cell?.frame.size.width)!, height: 145)
                    
                    
                }
                else
                {
                    cell?.txtDescription.isHidden = false
                    
                    let height = self.Method_HeightCalculation(text: strDes, font: fontDescription!, width: UIScreen.main.bounds.size.width - 36-22)
                    
                    
                    cell?.txtDescription.frame = CGRect(x: 11, y: 58, width: tableView.frame.size.width - 22, height: height + 10.0)
                    
                    
                    cell?.viewPhoto.frame = CGRect(x: 0, y: (cell?.txtDescription.frame.height)! + 8 + (cell?.txtDescription.frame.origin.y)! , width: (cell?.frame.size.width)!, height: 145)
                    
                    cell?.viewVideoMedia.frame = CGRect(x: 0, y: (cell?.viewPhoto.frame.height)! + 8 + (cell?.viewPhoto.frame.origin.y)! , width: (cell?.frame.size.width)!, height: 145)
                    
                    
                   

                    
                }
                
                
                
                
                cell?.lblUsername.text = String(format: "%@ %@", (dicUser.object(forKey: "firstName") as? String)!, (dicUser.object(forKey: "lastName") as? String)!)
                
                cell?.lblTime.text = strCreatedDate
                
                cell?.imgUser.setImageWith(urlImageUser!, placeholderImage: UIImage.init(named:"user_place"))
                
                cell?.layer.masksToBounds = true
                
                
                
                let strImage = dicPost.object(forKey: "image") as! String
                let urlStrImage = NSString(format: "%@%@",kSkeuomoImageURL,strImage)
                let urlImage = URL.init(string: urlStrImage as String)
                cell?.imgPhoto.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"placeholder"))
                
                
                let strVideoUrl = dicPost.object(forKey: "video") as! String

                let strVideoThumb = String(format: "https://img.youtube.com/vi/%@/0.jpg", strVideoUrl.youtubeID!)

                let urlVideoThumb = URL.init(string: strVideoThumb as String)

                cell?.imgVideoThumb.setImageWith(urlVideoThumb!, placeholderImage: UIImage.init(named:"placeholder"))
                
                
                
                return cell!
            }
            
            else if (dicPost.object(forKey: "image") as! String).characters.count > 0 || (dicPost.object(forKey: "video") as! String).characters.count > 0
            {
                let cellIdentifier:String = "WritePostTblCell"
                var cell:WritePostTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WritePostTblCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("WritePostTblCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? WritePostTblCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                }
                
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
                
                
                cell?.imgPhoto.addGestureRecognizer(tapGesture)
                cell?.imgPhoto.tag = indexPath.row - 1
                
                cell?.imgPhoto.isUserInteractionEnabled = true
                
                
                cell?.btnComments.addTarget(self,action: #selector(btnOpentCommentShow),for: UIControlEvents.touchUpInside)
                
                cell?.btnComments.tag = indexPath.row - 1
                
                
                cell?.btnPlay.addTarget(self,action: #selector(btnPlayVideoFeed(_:)),for: UIControlEvents.touchUpInside)
                
                cell?.btnPlay.tag = indexPath.row - 1
                
                
                cell?.btnLike.addTarget(self,action: #selector(btnLikePost(_:)),for: UIControlEvents.touchUpInside)
                cell?.btnLike.tag = indexPath.row - 1
                
                
                cell?.btnSharing.addTarget(self,action: #selector(btnOpentShareOption),for: UIControlEvents.touchUpInside)
                
                cell?.txtDescription.text = strDes
                cell?.lblUsername.text = String(format: "%@ %@", (dicUser.object(forKey: "firstName") as? String)!, (dicUser.object(forKey: "lastName") as? String)!)
                cell?.lblTime.text = strCreatedDate
                
                cell?.imgUser.setImageWith(urlImageUser!, placeholderImage: UIImage.init(named:"user_place"))
                
                cell?.layer.masksToBounds = true

                cell?.viewPhoto.isHidden =  true
                cell?.viewVideoMedia.isHidden =  true
                
                
                cell?.btnDelete.addTarget(self, action: #selector(btnDeletePostClick(_:)), for: .touchUpInside)
                cell?.btnDelete.tag = indexPath.row - 1
                
                let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
                
                let strCommentedUserId = dicPost.valueForNullableKey(key: "user_id")
                
                if strUserid as String == strCommentedUserId
                {
                    cell?.btnDelete.isHidden = false
                }
                else
                {
                    cell?.btnDelete.isHidden = true
                }
                
                
                let Likes = dicPost.object(forKey: "likes") as! Int
                
                if Likes == 0
                {
                    cell?.btnLike.setTitle("Like", for: .normal)
                }
                else
                {
                    let strLike = String(format: "Likes (%d)", Likes)
                    
                    cell?.btnLike.setTitle(strLike, for: .normal)
                }
                
                
                if dicPost.object(forKey: "is_like") as! Int == 0
                {
                    cell?.btnLike.setImage(UIImage.init(named: "wish"), for: .normal)
                }
                else
                {
                    cell?.btnLike.setImage(UIImage.init(named: "whish"), for: .normal)
                }
                
                
                if (dicPost.object(forKey: "image") as! String).characters.count > 0
                {
                    cell?.viewPhoto.isHidden =  false

                    let strImage = dicPost.object(forKey: "image") as! String
                    let urlStrImage = NSString(format: "%@%@",kSkeuomoImageURL,strImage)
                    let urlImage = URL.init(string: urlStrImage as String)
                    cell?.imgPhoto.setImageWith(urlImage!, placeholderImage: UIImage.init(named:"placeholder"))
                    
                    if strDes.characters.count == 0
                    {
                        cell?.txtDescription.isHidden = true
                        
                        cell?.viewPhoto.frame = CGRect(x: 0, y: 60 , width: (cell?.frame.size.width)!, height: 145)
                    }
                    else
                    {
                        cell?.txtDescription.isHidden = false
                        let height = self.Method_HeightCalculation(text: strDes, font: fontDescription!, width: UIScreen.main.bounds.size.width - 36-22)
                        cell?.txtDescription.frame = CGRect(x: 11, y: 58, width: tableView.frame.size.width - 22, height: height + 10.0)
                        
                        cell?.viewPhoto.frame = CGRect(x: 0, y: (cell?.txtDescription.frame.height)! + 8 + (cell?.txtDescription.frame.origin.y)! , width: (cell?.frame.size.width)!, height: 145)
                    }
                }
                else
                {
                    cell?.viewVideoMedia.isHidden =  false
                    let strVideoUrl = dicPost.object(forKey: "video") as! String
                    let strVideoThumb = String(format: "https://img.youtube.com/vi/%@/0.jpg", strVideoUrl.youtubeID!)
                    let urlVideoThumb = URL.init(string: strVideoThumb as String)
                    cell?.imgVideoThumb.setImageWith(urlVideoThumb!, placeholderImage: UIImage.init(named:"placeholder"))
                    
                    if strDes.characters.count == 0
                    {
                        cell?.txtDescription.isHidden = true
                        
                        cell?.viewVideoMedia.frame = CGRect(x: 0, y: 60 , width: (cell?.frame.size.width)!, height: 145)
                        
                    }
                    else
                    {
                        cell?.txtDescription.isHidden = false
                        
                        let height = self.Method_HeightCalculation(text: strDes, font: fontDescription!, width: UIScreen.main.bounds.size.width - 36-22)
                        
                        cell?.txtDescription.frame = CGRect(x: 11, y: 58, width: tableView.frame.size.width - 22, height: height + 10.0)
                        
                        cell?.viewVideoMedia.frame = CGRect(x: 0, y: (cell?.txtDescription.frame.height)! + 8 + (cell?.txtDescription.frame.origin.y)! , width: (cell?.frame.size.width)!, height: 145)
                        
                        
                        
                        
                    }
                    
                    
                }
                
                return cell!
            }
            else
            {
                let cellIdentifier:String = "TextShowTblCell"
                var cell:TextShowTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? TextShowTblCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("TextShowTblCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? TextShowTblCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                }
                
                cell?.btnComments.addTarget(self,action: #selector(btnOpentCommentShow),for: UIControlEvents.touchUpInside)
                
                cell?.btnComments.tag = indexPath.row - 1
                
                
                cell?.btnLike.addTarget(self,action: #selector(btnLikePost(_:)),for: UIControlEvents.touchUpInside)
                cell?.btnLike.tag = indexPath.row - 1
                
                
                cell?.btnSharing.addTarget(self,action: #selector(btnOpentShareOption),for: UIControlEvents.touchUpInside)
                
                
                cell?.txtDescription.text = strDes
                cell?.lblUsername.text = String(format: "%@ %@", (dicUser.object(forKey: "firstName") as? String)!, (dicUser.object(forKey: "lastName") as? String)!)
                cell?.lblTime.text = strCreatedDate
                
                cell?.imgUser.setImageWith(urlImageUser!, placeholderImage: UIImage.init(named:"user_place"))
                
                cell?.layer.masksToBounds = true

                
                cell?.btnDelete.addTarget(self, action: #selector(btnDeletePostClick(_:)), for: .touchUpInside)
                cell?.btnDelete.tag = indexPath.row - 1
                
                let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
                
                let strCommentedUserId = dicPost.valueForNullableKey(key: "user_id")
                
                if strUserid as String == strCommentedUserId
                {
                    cell?.btnDelete.isHidden = false
                }
                else
                {
                    cell?.btnDelete.isHidden = true
                }
                
                let Likes = dicPost.object(forKey: "likes") as! Int
                
                if Likes == 0
                {
                    cell?.btnLike.setTitle("Like", for: .normal)
                }
                else
                {
                    let strLike = String(format: "Likes (%d)", Likes)
                    cell?.btnLike.setTitle(strLike, for: .normal)
                }
            
                if dicPost.object(forKey: "is_like") as! Int == 0
                {
                    cell?.btnLike.setImage(UIImage.init(named: "wish"), for: .normal)
                }
                else
                {
                    cell?.btnLike.setImage(UIImage.init(named: "whish"), for: .normal)
                }
                
                return cell!
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row == arrPost.count - 1
        {
            if currentPage != totalPage
            {
                currentPage = currentPage + 1
                self.performSelector(inBackground: #selector(GetMyWallPost), with:nil)
            }
        }
    }

    
    //MARK: - Movie Finished
    
    func moviePlayerPlaybackDidFinish(notification : NSNotification)
    {
    }
    
    
    //MARK: - Webservice Methods
    
    func DeletePost(PostId : String)
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
        
        parameters.setValue(PostId, forKey: "id")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        //http://demo2server.in/sites/laravelapp/skeuomo/api/wallpost/delete?id=135&userid=97
        
        let  url  = String(format: "%@wallpost/delete?id=%@&userid=%@", kSkeuomoMainURL,PostId,strUserid)
        
        print("Get Post URL :",url)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            self.arrPost.removeObject(at: self.selectedIndexToDelete)
                            self.tblComunityData.reloadData()
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
    func LikeOnPost(dicData : NSDictionary)
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        manager.requestSerializer.timeoutInterval = 500
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        parameters.setObject(dicData.object(forKey: "id") as! String, forKey: "id" as NSCopying)
        
        parameters.setObject(dicData.object(forKey: "like") as! String, forKey: "like" as NSCopying)

        print("sending data : \(parameters)")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        
        print(strforMD5)
        
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        
        let  url  = String(format: "%@wallpost/postlike", kSkeuomoMainURL)
        manager.post(url as String, parameters: parameters, constructingBodyWith:{ (fromData)in/*fromData : AFMultipartFormData) in*/
            
            },progress:nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            print("Liked")
                            
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
                    
                    //  MBProgressHUD.hide(for: self.appDelegate.window!, animated: true)
            }
        }
    }
    
    func PostOnWall()
    {
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        manager.requestSerializer.setValue((UserDefaults.standard.object(forKey: "session_id")as! NSString) as String, forHTTPHeaderField: "user")
        
        manager.requestSerializer.timeoutInterval = 500
        
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        parameters.setObject(strUserid, forKey: "userid" as NSCopying)
        
        
        var strPostDes = ""
        
        if strPostDescription.characters.count > 0
        {
            strPostDes = strPostDescription.trimmingCharacters(in: NSCharacterSet.whitespaces)
        }
        
        parameters.setObject(strVideoUrl, forKey: "add_video_url" as NSCopying)
        parameters.setObject(strPostDes, forKey: "message_wall" as NSCopying)
        
        if imgData.count > 0
        {
            parameters.setObject("", forKey: "photo" as NSCopying)
        }
        
        
        
        print("sending data : \(parameters)")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        
        print(strforMD5)
        
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        
        let  url  = String(format: "%@wallpost/create", kSkeuomoMainURL)
        manager.post(url as String, parameters: parameters, constructingBodyWith:{ (fromData)in/*fromData : AFMultipartFormData) in*/
            
            if(self.imgData.count > 0)
            {
                fromData.appendPart(withFileData: self.imgData as Data, name: "photo", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
            },progress:nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            print("Everything is ok now")
                            
                            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                            
                            
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            
                            let dicObj = DicResponseData.object(forKey: "wallpost") as! NSDictionary
                            
                            self.arrPost.insert(dicObj, at: 0)
                            
                            
                            
                            
                           self.strPostDescription = ""
                           self.imgData = Data()
                           self.strVideoUrl = ""
                            
                            self.tblComunityData.reloadData()
                            
                            self.tblComunityData.scrollsToTop = true
                            

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
                    
                    //  MBProgressHUD.hide(for: self.appDelegate.window!, animated: true)
            }
        }
    }
    
    func GetMyWallPost()
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
        
        parameters.setValue(currentPage, forKey: "page")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        
        //http://demo2server.in/sites/laravelapp/skeuomo/api/wallpost/posts?userid=72
        
        let  url  = String(format: "%@wallpost/posts?userid=%@&page=%d", kSkeuomoMainURL,strUserid,currentPage)
        
        print("Get Post URL :",url)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                            
                            
                            if DicResponseData.object(forKey: "wallpost") != nil
                            {
                                
                                if DicResponseData.object(forKey: "wallpost") is NSArray && (DicResponseData.object(forKey: "wallpost") as! NSArray).count == 0
                                {
                                    HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle:  "Record Not Found" , controller: self)
                                }
                                else
                                {
                                    if (DicResponseData.object(forKey: "wallpost") as! NSDictionary).allKeys.count > 0 && (DicResponseData.object(forKey: "wallpost") as! NSDictionary).object(forKey: "data") != nil
                                    {
                                        
                                        self.boolCmtGetData = false
                                        
                                        let tempArr = (DicResponseData.object(forKey: "wallpost") as! NSDictionary).object(forKey: "data") as! NSArray
                                        
                                        
                                        let tempTotalPage = (DicResponseData.object(forKey: "wallpost") as! NSDictionary).object(forKey:"last_page") as! Int
                                        
                                        let tempTotalRecord = (DicResponseData.object(forKey: "wallpost") as! NSDictionary).object(forKey:"total") as! Int
                                        
                                        if self.currentPage == 1
                                        {
                                            self.arrPost.removeAllObjects()
                                        }
                                        
                                        self.arrPost.addObjects(from: tempArr as! [NSDictionary])
                                        
                                        self.totalPage = tempTotalPage
                                        self.totalPageRecord = tempTotalRecord
                                        
                                        self.tblComunityData.reloadData()
                                        
                                    }
                                }
                               
                                
                            }
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

extension String
{
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: self.characters.count)
        
        guard let result = regex?.firstMatch(in: self, options: [], range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
    
    func GetutfString() -> String {
        return String(cString:self.cString(using: String.Encoding.isoLatin1)!, encoding: String.Encoding.utf8)!
    }
    
}

