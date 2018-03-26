//
//  communityCommentVC.swift
//  Skeuomo
//
//  Created by usersmart on 8/21/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking


class communityCommentVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, HPGrowingTextViewDelegate
{
    @IBOutlet var tblCommunity: UITableView!
    
    @IBOutlet var textView: HPGrowingTextView!

    @IBOutlet var viewBottomTxtField: UIView!
    
    @IBOutlet var btnSend: UIButton!
    
    var strPostId = ""
    
    var currentPage = 1
    var totalPage = 0
    var totalPageRecord = 0
    
    var arrComment = NSMutableArray()
    var boolCmtGetData = false
    
    var refreshControl : UIRefreshControl!
    
    let fontDescription = UIFont.init(name: "Gibson-Light", size: 12)

    var dateFormateServer             :DateFormatter!
    var dateFormate                   :DateFormatter!
    
    
    var selectedIndexToDelete = 0
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        dateFormateServer  = DateFormatter()
        dateFormateServer.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        dateFormate  = DateFormatter()
        dateFormate.dateFormat = "MMMM dd, YYYY HH:mm:ss a"
        
        self.performSelector(onMainThread: #selector(loadTextView), with: nil, waitUntilDone: false)

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(GetCommentPost), with: nil)
        
        
        refreshControl = UIRefreshControl()
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *)
        {
            tblCommunity.refreshControl = refreshControl
        }
        else
        {
            tblCommunity.addSubview(refreshControl)
        }
        
    }
    
    
    func refreshWeatherData(_ sender: Any)
    {
       if currentPage != totalPage
       {
        if !boolCmtGetData
        {
            boolCmtGetData = true
            currentPage += 1
            performSelector(inBackground: #selector(self.GetCommentPost), with: nil)
        }
       }
        
        let when = DispatchTime.now() + 3
        
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            // Your code with delay
            self.refreshControl.endRefreshing()
        }
        
    }
    
    
   

    
    func loadTextView()
    {
        let font: UIFont = UIFont(name: "Gibson-Regular", size: CGFloat(12))!
        textView.internalTextView.font = font
        textView.placeholder = "Type a comment"
        textView.minNumberOfLines = 1
        textView.maxNumberOfLines = 4
        textView.returnKeyType = UIReturnKeyType.default
        textView.font = font
        textView.delegate = self
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 7, 5, 7)
        textView.layer.masksToBounds = true
        textView.animateHeightChange = true
    }
    
    
    // MARK: - KeyBoard Notification Handlers -
    
    func keyboardWillShow(_ note: NSNotification)
    {
        
        var containerFrame : CGRect
        
        let info : NSDictionary = note.userInfo! as NSDictionary
        
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let duration = (note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber)
        
        containerFrame = viewBottomTxtField.frame
        
        containerFrame.origin.y = self.view.frame.size.height - (keyboardSize!.height + containerFrame.size.height)
        
        viewBottomTxtField.frame = containerFrame
        
        
        tblCommunity.frame = CGRect(x: 0.0, y: 64.0, width: self.view.frame.size.width, height: self.view.frame.size.height - containerFrame.size.height - keyboardSize!.height-64)
        
        self.performSelector(onMainThread: #selector(moveContentViewToEnd), with: nil, waitUntilDone: false)
        
        // animations settings
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(CDouble(duration))
       
        // set views with new info
        viewBottomTxtField.frame = containerFrame
        
        // commit animations
        UIView.commitAnimations()
        
    }
    
    func keyboardWillHide(_ note: NSNotification)
    {
        
        var containerFrame : CGRect
        let info : NSDictionary = note.userInfo! as NSDictionary
        
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        let duration = (note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber)
        
        let curve = (note.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber)
        
        containerFrame = viewBottomTxtField.frame
        
        containerFrame.origin.y = self.view.frame.size.height - containerFrame.size.height
        
        
        tblCommunity.frame = CGRect(x: 0.0, y: 64.0, width: self.view.frame.size.width, height: containerFrame.origin.y-64)
        
        
        // animations settings
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(CDouble(duration))
        // set views with new info
        viewBottomTxtField.frame = containerFrame
        // commit animations
        UIView.commitAnimations()
        
    }
    
    
    func moveContentViewToEnd()
    {
        if tblCommunity.contentSize.height > tblCommunity.frame.size.height
        {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                let numberOfSections = self.tblCommunity.numberOfSections
                let numberOfRows = self.tblCommunity.numberOfRows(inSection: numberOfSections-1)
                
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.tblCommunity.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
            
            
        }
    }
    
    
    //MARK: - GrowingTextView Delegates -
    
    func growingTextView(_ growingTextView: HPGrowingTextView!, willChangeHeight height: Float)
    {
        let diff: CGFloat = CGFloat(growingTextView.frame.size.height) - CGFloat(height)
        var r: CGRect = viewBottomTxtField.frame
        r.size.height = r.size.height - diff
        r.origin.y = r.origin.y + diff
        viewBottomTxtField.frame = r
        tblCommunity.frame = CGRect(x: 0.0, y: 64.0, width: self.view.frame.size.width, height: viewBottomTxtField.frame.origin.y-64)
        
        
    }
    
    func growingTextViewDidChange(_ growingTextView: HPGrowingTextView)
    {
        let trimmedString: String = textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if trimmedString.characters.count > 0
        {
            btnSend.isEnabled = true
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = false
            btnSend.isEnabled = false
            textView.internalTextView.contentSize = CGSize(width: textView.frame.size.width, height: textView.frame.size.height)
            textView.internalTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            
        }
        
    }
    func showTextView()
    {
        textView.becomeFirstResponder()
    }
    func resignTextView()
    {
        textView.resignFirstResponder()
        
        
        var containerFrame : CGRect
        containerFrame = viewBottomTxtField.frame
        containerFrame.origin.y = self.view.frame.size.height - containerFrame.size.height
        viewBottomTxtField.frame = containerFrame
        tblCommunity.frame = CGRect(x: 0.0, y: 64.0, width: self.view.frame.size.width, height: viewBottomTxtField.frame.origin.y-64)
        
    }

    
    //MARK: - UIButton Event
    
    @IBAction func btnDeleteCommentClick(_ sender: UIButton)
    {
        selectedIndexToDelete = sender.tag
        
        let actionSheet = UIAlertController(title: nil, message: "Are you sure want to delete this comment", preferredStyle: UIAlertControllerStyle.alert)
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            
            let dicComment = self.arrComment.object(at: sender.tag) as! NSDictionary
            let strCommentId = dicComment.valueForNullableKey(key: "id")
            
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(self.DeleteComment(CommentId:)), with: strCommentId)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func btnBack(_ sender: Any)
    {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPostComment(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let trimmedString = textView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as String
        
        if trimmedString.characters.count == 0 {
            
            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: "Please write comment" , controller: self)
            return
        }
        
        HelpingMethods.sharedInstance.ShowHUD()
        self.performSelector(inBackground: #selector(postComment), with: nil)
        
    }
    
    @IBAction func btnSearching(_ sender: Any)
    {
        
    }
    
    @IBAction func btnNotification(_ sender: Any)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    
    
    
    //MARK:- UITableView Delegate and Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrComment.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let dicComment = arrComment.object(at: indexPath.row ) as! NSDictionary
        
        let strComment =  dicComment.object(forKey: "comment") as? String
        
        let height = self.Method_HeightCalculation(text: strComment!, font: fontDescription!, width: UIScreen.main.bounds.size.width - 30)
        
        
        let TotalHeight : CGFloat = 80
        let ExtraHeight : CGFloat = 10.0
        
        if height > 30
        {
            return TotalHeight + height + ExtraHeight
        }
        else
        {
            return TotalHeight + 35.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "cellCommunity"
        var cell:cellCommunity? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? cellCommunity
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("cellCommunity", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? cellCommunity
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = (UIColor.clear);
        }
        
        cell?.imgUser.layer.cornerRadius = (cell?.imgUser.frame.size.width)!/2
        cell?.imgUser.layer.masksToBounds = true
        
        
        cell?.btnDelete.addTarget(self, action: #selector(btnDeleteCommentClick(_:)), for: .touchUpInside)
        
        cell?.btnDelete.tag = indexPath.row
        
        
        let dicComment = arrComment.object(at: indexPath.row ) as! NSDictionary
        
        let strUserid = NSString(format:"%d",(UserDefaults.standard.object(forKey: "UserDatail")as! NSDictionary).object(forKey: "id")as! Int)
        
        let strCommentedUserId = dicComment.valueForNullableKey(key: "user_id")
        
        if strUserid as String == strCommentedUserId
        {
            cell?.btnDelete.isHidden = false
        }
        else
        {
            cell?.btnDelete.isHidden = true
        }
        
        
        let CreateDate = dateFormateServer.date(from: dicComment.valueForNullableKey(key: "created_at"))
        
        let dicUser = dicComment.object(forKey: "user") as! NSDictionary
        
        
        
        let strUserImage = dicUser.object(forKey: "profile_picture") as! String
        let urlStrUser = NSString(format: "%@%@",kSkeuomoImageURL,strUserImage)
        let urlImageUser = URL.init(string: urlStrUser as String)
        
        var strCreatedDate = ""
        
        if CreateDate != nil
        {
            strCreatedDate = dateFormate.string(from: CreateDate!)
        }
        
        cell?.lblName.text = String(format: "%@ %@", (dicUser.object(forKey: "firstName") as? String)!, (dicUser.object(forKey: "lastName") as? String)!)
        
        cell?.lblDayTime.text = strCreatedDate
        cell?.imgUser.setImageWith(urlImageUser!, placeholderImage: UIImage.init(named:"user_place"))
        
        let strComment =  dicComment.object(forKey: "comment") as? String
        cell?.lblDescription.text = strComment
        
        
        
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

    }
    
 //MARK:- UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Webservice Methods
    
    func DeleteComment(CommentId : String)
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
        
        parameters.setValue(CommentId, forKey: "id")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        //http://demo2server.in/sites/laravelapp/skeuomo/api/wallcomment/delete?id=73&userid=155&comment_id=24
        
        let  url  = String(format: "%@wallcomment/delete?id=%@&userid=%@", kSkeuomoMainURL,CommentId,strUserid)
        
        print("Get Post URL :",url)
        
        manager.get(url, parameters: nil, progress: nil, success:
            { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            self.arrComment.removeObject(at: self.selectedIndexToDelete)
                            self.tblCommunity.reloadData()
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
    
    func GetCommentPost()
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
        
        parameters.setValue(strPostId, forKey: "id")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        //http://demo2server.in/sites/laravelapp/skeuomo/api/wallpost/getcomments?page=4&id=108&userid=97
        
        let  url  = String(format: "%@wallpost/getcomments?page=%d&id=%@&userid=%@", kSkeuomoMainURL,currentPage,strPostId,strUserid)
        
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
                            
                            
                            if DicResponseData.object(forKey: "wallcomments") != nil
                            {
                                
                                if DicResponseData.object(forKey: "wallcomments") is NSArray && (DicResponseData.object(forKey: "wallcomments") as! NSArray).count == 0
                                {
                                    
                                    print("No record found")
                                    
//                                    if self.arrComment.count == 0
//                                    {
//                                        HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle:  "Record Not Found" , controller: self)
//                                    }
                                    
                                    
                                }
                                else
                                {
                                    if (DicResponseData.object(forKey: "wallcomments") as! NSDictionary).object(forKey: "data") != nil
                                    {
                                        let tempArr = (DicResponseData.object(forKey: "wallcomments") as! NSDictionary).object(forKey: "data") as! NSArray
                                        
                                        let tempTotalPage = (DicResponseData.object(forKey: "wallcomments") as! NSDictionary).object(forKey:"last_page") as! Int
                                        
                                        let tempTotalRecord = (DicResponseData.object(forKey: "wallcomments") as! NSDictionary).object(forKey:"total") as! Int
                                        
                                        if self.arrComment.count > 0 && self.currentPage == 1
                                        {
                                            self.arrComment.removeAllObjects()
                                            
                                            self.arrComment.addObjects(from: tempArr.reverseObjectEnumerator().allObjects)
                                        }
                                        else
                                        {
                                            for obj in tempArr
                                            {
                                                self.arrComment.insert(obj, at: 0)
                                            }
                                        }
                                        
                                        self.totalPage = tempTotalPage
                                        self.totalPageRecord = tempTotalRecord
                                        
                                        self.boolCmtGetData = false
                                        
                                        self.tblCommunity.reloadData()
                                        
                                    }
                                    else
                                    {
                                        
                                        print("No record found")

                                        
//                                        if self.arrComment.count == 0
//                                        {
//                                            HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle:  "Record Not Found" , controller: self)
//                                        }
                                    }
                                }
                                
                                
                                
                                
                            }
                        }
                            
                        else
                        {
                            print("failed")
                            
                           // HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                            
                            
                            
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
    
    func postComment()
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
        parameters.setObject(textView.text!, forKey: "commentText" as NSCopying)
        parameters.setObject(strPostId, forKey: "id" as NSCopying)
        
        print("sending data : \(parameters)")
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        
        print(strforMD5)
        
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        
        let  url  = String(format: "%@wallcomment/create", kSkeuomoMainURL)
        
        
        print("URL :",url)
        
        manager.post(url as String, parameters: parameters, constructingBodyWith:{ (fromData)in/*fromData : AFMultipartFormData) in*/
            
            },progress:nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
                DispatchQueue.main.async
                    {
                        HelpingMethods.sharedInstance.hideHUD()
                        
                        print((responseObject as! NSDictionary))
                        
                        if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                        {
                            print("Everything is ok now")
                            
                          //  HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
                            
                            
                           self.textView.text = ""
                            
                            let DicResponseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary

                            
                            let dicObj = DicResponseData.object(forKey: "wallcomment") as! NSDictionary
                            
                            self.arrComment.add(dicObj)
                            
                            self.tblCommunity.reloadData()
                            
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
    
    
    
}
