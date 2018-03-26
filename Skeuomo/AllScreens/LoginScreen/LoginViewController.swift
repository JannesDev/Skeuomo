//
//  LoginViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 12/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import AFNetworking
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController, UITextFieldDelegate , GIDSignInUIDelegate , GIDSignInDelegate ,UIWebViewDelegate,FHSTwitterEngineAccessTokenDelegate{

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var myScrolllBar: UIScrollView!
    
    var strSocialType:NSString! = ""
    var strSocialuserID:NSString! = ""
    
    var strEmailID:NSString! = ""
    var strImageUrl:NSString! = ""
    var strNameUser:NSString! = ""
    var currentUser =  GIDGoogleUser()

    //instgram ashish
    
    //account : ninehertz2005
    //password: ninehertzindia@123
    @IBOutlet var viewInstagram : UIView!
    var webViews = UIWebView()
    let urlauth:NSString! = "https://api.instagram.com/oauth/authorize/"
    let apiUrl:NSString! = "https://api.instagram.com/v1/users/"
    let clientId:NSString! = "1d02091be7a74eac8437044a19ba7eeb"
    
    let clientSercret:NSString! = "6cb79f45d90e414282525da72bace4ac"
    let REDIRECT_URI:NSString! = "https://theninehertz.com/"
    let INSTAGRAM_ACCESS_TOKEN:NSString! = "access_token"
    let Scope:NSString! = "basic+public_content"
    
    var typeOfAuthentication = NSString()
    var authURL:NSString! = nil

    
    //twtter
    
    //username anveshan_tweet [twittertesting]
    var strTwitterid:String!
    var strTwitterName:String!
    
    //Google
    var StrGoogleId:NSString! = ""
    var StrGoogleEmail:NSString! = ""
    var StrGoogleuserName:NSString! = ""
    
    var dictSocialData = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        btnLogin.layer.cornerRadius = 21.0
        btnRegister.layer.cornerRadius = 21.0
        btnRegister.layer.borderColor = UIColor.init(red: 16/255.0, green: 133/255.0, blue: 251/255.0, alpha: 1.0).cgColor
        btnRegister.layer.borderWidth = 1.5
        btnRegister.layer.masksToBounds = true
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = "513504440774-kq2q0cb67ntprr4t6ndj8mb7imjoiaf1.apps.googleusercontent.com"
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - buttonsMethods
    
    @IBAction func btnFB(_ sender: Any) {
        
        //HelpingMethods.sharedInstance.ShowHUD()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            
            
            let fbLogin : FBSDKLoginManager = FBSDKLoginManager()
            fbLogin.logOut()
            
            if (FBSDKAccessToken.current() != nil)
            {
                //MBProgressHUD .showAdded(to: self.view, animated: true)
                self.UserFBExit()
                return
            }
            
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            
            // fbLoginManager.logIn(withReadPermissions: ["public_profile","email","user_friends"], handler: { (result, error) -> Void in
            fbLoginManager.logIn(withReadPermissions: ["public_profile","email","user_friends"], from: self, handler: { (result, error) -> Void in
                
                if (error == nil)
                {
                    
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    
                    if(fbloginresult.isCancelled) {
                        //Show Cancel alert
                    } else if(fbloginresult.grantedPermissions.contains("email")) {
                        
                        //   MBProgressHUD .showAdded(to: self.view, animated: true)
                        self.UserFBExit()
                        //fbLoginManager.logOut()
                    }
                }
                else
                {
                    print("FBError")
                    // MBProgressHUD.hide(for:  self.view, animated: true)
                }
            })
        }
        
    }
    
    //MARK:FBUserExitInfo
    func UserFBExit()
    {
        //HelpingMethods.sharedInstance.hideHUD()
        
        // MBProgressHUD.hide(for:  self.view, animated: true)
        if((FBSDKAccessToken.current()) != nil)
        {
            //invitable_friends{id, name,first_name, last_name,picture}
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,friends{id, name,first_name, last_name,picture}"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil)
                {
                    //print(result)
                    //  MBProgressHUD.hide(for:self.view, animated: true)
                    
                    let dicFBdetails = NSMutableDictionary.init(dictionary: result as! NSDictionary)
                    
                    print("dicFBdetails",dicFBdetails)
                    
                    self.strSocialuserID = dicFBdetails.object(forKey: "id") as! NSString!
                    if dicFBdetails.object(forKey: "email") != nil
                    {
                        self.strEmailID = dicFBdetails.object(forKey: "email") as! NSString!
                        
                    }
                    if dicFBdetails.object(forKey: "name") != nil
                    {
                        self.strNameUser = dicFBdetails.object(forKey: "name") as! NSString!
                        
                    }
                    
                    if ((dicFBdetails.object(forKey: "picture") as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "url") != nil
                    {
                        self.strImageUrl = ((dicFBdetails.object(forKey: "picture") as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "url") as! NSString!
                        
                    }
                    
                    self.dictSocialData.setObject(self.strSocialuserID, forKey: "social_id" as NSCopying)
                    
                    self.dictSocialData.setObject(dicFBdetails.object(forKey: "first_name") as! NSString!, forKey: "social_first_name" as NSCopying)
                    
                    self.dictSocialData.setObject(dicFBdetails.object(forKey: "last_name") as! NSString!, forKey: "social_last_name" as NSCopying)
                    
                    self.dictSocialData.setObject(dicFBdetails.object(forKey: "email") as! NSString!, forKey: "social_email" as NSCopying)
                    
                    
                    self.strSocialuserID = self.strSocialuserID as NSString
                    
                    self.strSocialType = "facebook"
                    
                    HelpingMethods.sharedInstance.ShowHUD()
                    self.performSelector(inBackground: #selector(self.checkUser), with: nil)
                    
                    
                    //HelpingMethods.sharedInstance.ShowHUD()
                    //  MBProgressHUD.showAdded(to: self.appDelegate.window!, animated: true)
                //    self.performSelector(inBackground: #selector(self.FacebookSocialContactApi), with: nil)
                    
                    //   }
                    
                }
                else
                {
                    print("FBFrnd error")
                    //  MBProgressHUD.hideAllHUDs(for:  self.view, animated: true)
                }
                
            })
        }
    }
    
    //MARK: twitter method
    
    @IBAction func btnTwitter(_ sender: Any)
    {
        self.view.endEditing(true)
        
        self.appDelegate.strUrlAuthanticateType = "TWITTER"
        
        FHSTwitterEngine.shared().clearAccessToken()
        FHSTwitterEngine.shared().permanentlySetConsumerKey("b9qwjtXomgQNWsznb87Riw3hF", andSecret: "4UquCYhrUz2OhBKHMTs9OiGM6CrPH63nshsYIH5arWPSTYSYCt")
        FHSTwitterEngine .shared().delegate = self
        FHSTwitterEngine.shared().loadAccessToken()
        
        let loginController = FHSTwitterEngine.shared().loginController { (boolean) -> Void in
            
            print("username = ",FHSTwitterEngine.shared().authenticatedUsername)
            self.strTwitterid = FHSTwitterEngine.shared().authenticatedID
            self.strTwitterName = FHSTwitterEngine.shared().authenticatedUsername
            print("userId = ",FHSTwitterEngine.shared().authenticatedID)
            
            self.appDelegate.strUrlAuthanticateType = "TWITTER"
            
            self.strSocialuserID = self.strTwitterid as NSString!
            self.strSocialType = "twitter"
            
            self.dictSocialData.setObject(self.strTwitterid, forKey: "social_id" as NSCopying)
            self.dictSocialData.setObject(self.strTwitterName, forKey: "social_user_name" as NSCopying)
            
            
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(self.checkUser), with: nil)
        }
        
        self.present(loginController!, animated: true, completion: nil)
    }
    
    @IBAction func btnGooglePlus(_ sender: Any) {
        
        self.GoogleSignOut()
        appDelegate.strUrlAuthanticateType = "GOOGLE"
        GIDSignIn.sharedInstance().signIn()

        
    }
    @IBAction func btnInsta(_ sender: Any)
    {
        self.MethodShowInstagram()
    }
   
    @IBAction func btnLogin(_ sender: Any)
    {
        
        if txtUserName.text?.isEmpty == true {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kUsernameRequiredText, controller: self)
        }
        else if txtPassword.text?.isEmpty == true
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle: "", strSubtitle: kPasswordRequiredText, controller: self)

        }
        else if (txtPassword.text?.characters.count)! < 6
        {
            self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"" , strSubtitle: kPasswordLengthText, controller: self)
        }
        else
        {
            if HelpingMethods.sharedInstance.isInternetAvailable() == false
            {
                self.appDelegate.kHelpingMethods.showMessageAlert(strTitle:"No Internet Connection" , strSubtitle: "Make sure your device is connected to the internet.", controller: self)
            }
            else
            {
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(LoginViewController.LoginAPi), with: nil)
            }
        }
     //self.appDelegate.showtabbar()
    }
    @IBAction func btnRegister(_ sender: Any)
    {
        //MemberShipPlansScreen
        //RegisterViewController
        let Register  = RegisterViewController(nibName:"RegisterViewController", bundle:nil)
        self.navigationController?.pushViewController(Register, animated: true)
        
        
    }
    
    @IBAction func btnForgotPasswrd(_ sender: Any)
    {
        let Forgot  = ForgotPassWordScreen(nibName:"ForgotPassWordScreen", bundle:nil)
        self.navigationController?.pushViewController(Forgot, animated: true)
    }
    //MARK:- UItextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if (textField.text == "" && string == " ")
        {
            return false
        }
        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        
        if ( textField == txtUserName)
        {
            return newLength > 20 ? false : true;
        }
        else  if ( textField == txtPassword)
        {
            return newLength > 20 ? false : true;
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func LoginAPi()  {
        
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        parameters.setObject(txtUserName.text!, forKey: "username" as NSCopying)
        parameters.setObject("IOS" ,  forKey: "device_type" as NSCopying)
        parameters.setObject("Simulator" , forKey: "device_token" as NSCopying)
        parameters.setObject(txtPassword.text! , forKey: "password" as NSCopying)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        
        
        let  url  = String(format: "%@login", kSkeuomoMainURL)
        manager.post(url as String, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            DispatchQueue.main.async
                {
                    HelpingMethods.sharedInstance.hideHUD()
                    print((responseObject as! NSDictionary))
                    
                    if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                    {
                        UserDefaults.standard.set( ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "user") as! NSDictionary, forKey: "UserDatail")
                        
                        if ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "session_id") != nil
                        {
                            
                            UserDefaults.standard.set(((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "session_id") as! String, forKey: "session_id")
                            
                        }

                        
                        let DicUser = ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "user") as! NSDictionary
                        
                        if DicUser.object(forKey: "selected_theme") != nil && !(DicUser.object(forKey: "selected_theme") is NSNull) && (DicUser.object(forKey: "selected_theme") as! NSDictionary).allKeys.count > 0
                        {
                            UserDefaults.standard.set( DicUser.object(forKey: "selected_theme") as! NSDictionary, forKey: "Theme")
                        }
                        
                        UserDefaults.standard.set("Yes", forKey: "isLogin")
                        
                        self.appDelegate.showtabbar()
                       // let Plans  = AllPlansVC(nibName:"AllPlansVC", bundle:nil)
                        //self.navigationController?.pushViewController(Plans, animated: true)
                        
                        
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

    
    
    
    
    //MARK:GooglePlus Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if user != nil {
            currentUser = user;
            
            StrGoogleId = currentUser.userID as NSString!
            StrGoogleEmail = currentUser.profile.email as NSString!
            StrGoogleuserName = currentUser.profile.name as NSString
            
            self.strSocialuserID = self.StrGoogleId as NSString
            self.strSocialType = "google"
            
            self.dictSocialData.setObject(self.StrGoogleId, forKey: "social_id" as NSCopying)
            self.dictSocialData.setObject(self.StrGoogleuserName, forKey: "social_user_name" as NSCopying)
            self.dictSocialData.setObject(self.StrGoogleEmail, forKey: "social_email" as NSCopying)
            
            
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(self.checkUser), with: nil)

            
//            self.currentUserDict=NSMutableDictionary();
//            
//            var str = currentUser.profile.name as String
//            str=str.stringByReplacingOccurrencesOfString(" ", withString: "")
//            self.currentUserDict.setObject(str, forKey: "name")
//            self.currentUserDict.setObject(currentUser.profile.email, forKey: "email")
//            self.currentUserDict.setObject(currentUser.userID, forKey: "id")
//            
          //  MBProgressHUD.showHUDAddedTo(appDelegate.window, animated: true)
            //self.GoogleSignUp()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
        func GoogleSignOut()
    {
        GIDSignIn.sharedInstance().signOut()
    }
    
    
    //MARK: Instagram Method
    func MethodShowInstagram()
    {
        HelpingMethods.sharedInstance.ShowHUD()
        
        if typeOfAuthentication .isEqual(to: "UNSIGNED")
        {
            authURL = NSString(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", urlauth,clientId,REDIRECT_URI,Scope)
        }
        else
        {
            authURL = NSString(format: "%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@&DEBUG=True", urlauth,clientId,REDIRECT_URI,Scope)
        }
        
        let request1 =  NSURLRequest(url: NSURL(string: authURL as String )! as URL)
        
        webViews = UIWebView()
        
        webViews.frame = CGRect(x:0, y:64,width:(UIScreen.main.bounds.size.width), height:(UIScreen.main.bounds.size.height))
        
        webViews.delegate = self
        
        viewInstagram.frame = CGRect(x:0, y:0,width:(UIScreen.main.bounds.size.width), height:(UIScreen.main.bounds.size.height))
        
        self.view.addSubview(viewInstagram)
        self.viewInstagram.addSubview(webViews)
        
        webViews.loadRequest(request1 as URLRequest)
    }
    
    @IBAction func MethodCancelInstagram(sender : Any)
    {
        self.viewInstagram.removeFromSuperview()
    }
    
    //MARK: - WebView Delegates
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        return self.checkRequestForCallbackURL(request: request as NSURLRequest)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        
        webViews.isHidden = false
        webViews.layer.removeAllAnimations()
        webView.isUserInteractionEnabled = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        webViews.stopLoading()
        //MBProgressHUD.hideAllHUDs(for: appDelegate.window!, animated: true)
        HelpingMethods.sharedInstance.hideHUD()
        
        webViews.layer.removeAllAnimations()
        webView.isUserInteractionEnabled = true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        //  print("Webview fail with error \(error)");
        self.webViewDidFinishLoad(webView)
        HelpingMethods.sharedInstance.hideHUD()
        //MBProgressHUD.hideAllHUDs(for: appDelegate.window!, animated: true)
    }
    
    func checkRequestForCallbackURL(request:NSURLRequest)-> Bool
    {
        var urlstr = NSString()
        urlstr   = (request.url?.absoluteString)! as NSString
        if typeOfAuthentication .isEqual(to: "UNSIGNED")
        {
            if urlstr .hasPrefix(REDIRECT_URI as String)
            {
                var range:NSRange!
                range = urlstr.range(of: "#access_token=")
                
                self.handleAuth(handleAuth: urlstr.substring(from: range.location+range.length) as NSString)
                
                return false
            }
        }
        else
        {
            if urlstr .hasPrefix(REDIRECT_URI as String)
            {
                var range:NSRange!
                range = urlstr.range(of: "code=")
                self.makePostRequest(code: urlstr.substring(from: range.location+range.length) as NSString)
                return false
            }
            
        }
        return true
    }
    
    func handleAuth(handleAuth:NSString)
    {
        //self.MethodGetInstagramImages()
        //https://api.instagram.com/v1/users/{user-id}/media/recent/?access_token=ACCESS-TOKEN
        webViews.removeFromSuperview()
        viewInstagram.removeFromSuperview()
    }
    
    func makePostRequest(code:NSString)
    {
        let post:NSString!
        post = NSString(format: "client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@", clientId,clientSercret,REDIRECT_URI,code)
        
        let postData:NSData! = (post .data(using: String.Encoding.ascii.rawValue, allowLossyConversion: true) as NSData!)
        let postLenth:String! = String(format: "%lu", postData.length)
        
        let requestData = NSMutableURLRequest(url: NSURL(string: "https://api.instagram.com/oauth/access_token/" as String )! as URL)
        //users/self/media/recent
        requestData.httpMethod = "POST"
        requestData .setValue(postLenth, forHTTPHeaderField: "Content-Length")
        requestData .setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        requestData.httpBody = postData as Data?
        
        var response: URLResponse?
        var urlData = NSData()
        do
        {
            urlData = try NSURLConnection.sendSynchronousRequest(requestData as URLRequest, returning: &response) as NSData
        }
        catch (let e)
        {
            print(e)
        }
        
        do {
            var diceInstagram = NSDictionary()
            diceInstagram = try JSONSerialization.jsonObject(with: urlData as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
            let dicUserINstagram = diceInstagram.object(forKey: "user") as! NSDictionary
            
            print("dicUserINstagram", dicUserINstagram)
            
            strSocialuserID = dicUserINstagram.object(forKey: "id") as! NSString!
            strSocialType = "instagram"
            
            //add dict
            self.dictSocialData.setObject(dicUserINstagram.object(forKey: "id") as! NSString!, forKey: "social_id" as NSCopying)
            
            self.dictSocialData.setObject(dicUserINstagram.object(forKey: "username") as! NSString!, forKey: "social_user_name" as NSCopying)
            
            HelpingMethods.sharedInstance.ShowHUD()
            self.performSelector(inBackground: #selector(checkUser), with: nil)
            
            //UserDefaults.standard.set(dicUserINstagram, forKey: "InstaUserDetails")
            //UserDefaults.standard.synchronize()
            
        }
        catch let JSONError as NSError
        {
            print("\(JSONError)")
        }
    }
    
    
    //MARK:- twitterDelegate
    func storeAccessToken(_ accessToken: String!)
    {
        // NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "SavedAccessHTTPBody")
        
        UserDefaults.standard.set(accessToken, forKey: "SavedAccessHTTPBody")
    }
    
    func loadAccessToken() -> String?
    {
        //if let outputStr = NSUserDefaults.standardUserDefaults().objectForKey("SavedAccessHTTPBody") as? String
        if let outputStr = UserDefaults.standard.object(forKey:"SavedAccessHTTPBody") as? String
        {
            return outputStr
        }
        return nil
    }
    
    //MARK:- Check user API

    func checkUser()
    {
        
        let manager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        let utcTimestamp = Date().timeIntervalSince1970
        
        let parameters = NSMutableDictionary()
        
        parameters.setObject(strSocialuserID, forKey: "social_id" as NSCopying)
        parameters.setObject(strSocialType , forKey: "social_type" as NSCopying)
        parameters.setObject("IOS" ,  forKey: "device_type" as NSCopying)
        parameters.setObject("Simulator" , forKey: "device_token" as NSCopying)
        
        let arrupperCase = (parameters.allKeys as NSArray).value(forKey: "uppercaseString")
        let sortedArray = (arrupperCase as! NSArray).sorted { ($0 as! String).localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending }
        
        let strforMD5 = NSString.init(format: "%f%@", utcTimestamp,(sortedArray as NSArray).componentsJoined(by: ""))
        let token = appDelegate.MD5(strforMD5 as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")
        
        
        
        let  url  = String(format: "%@checkUser", kSkeuomoMainURL)
        manager.post(url as String, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            DispatchQueue.main.async
                {
                    HelpingMethods.sharedInstance.hideHUD()
                    print((responseObject as! NSDictionary))
                    
                    if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
                    {
                        let responseData = (responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary
                        
                        //if(((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "new_user") as! Int == 1)
                        if(responseData.object(forKey: "new_user") as! Bool == true)
                        {//new user goto signup page
                         
                            self.dictSocialData.setObject(self.strSocialType, forKey: "social_type" as NSCopying)
                            
                            let objReg = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
                            
                            objReg.dictUserLoadedData = self.dictSocialData
                            
                            _ = self.navigationController?.pushViewController(objReg, animated: true)
                            
                        }
                        else
                        {//old user goto login page
                            
                            UserDefaults.standard.set( ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "user") as! NSDictionary, forKey: "UserDatail")
                            
                            if ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "session_id") != nil{
                                
                                UserDefaults.standard.set(((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "session_id") as! String, forKey: "session_id")
                                
                            }
                            
                            UserDefaults.standard.set("Yes", forKey: "isLogin")
                            
                            UserDefaults.standard.synchronize()
                            
                            self.appDelegate.showtabbar()
                        }
                        
                        /*
                        UserDefaults.standard.set( ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "user") as! NSDictionary, forKey: "UserDatail")
                        
                        if ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "session_id") != nil{
                            
                            UserDefaults.standard.set(((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "session_id") as! String, forKey: "session_id")
                            
                        }
                        
                        UserDefaults.standard.set("Yes", forKey: "isLogin")
                        
                        */
                        
                        
                        // let Plans  = AllPlansVC(nibName:"AllPlansVC", bundle:nil)
                        //self.navigationController?.pushViewController(Plans, animated: true)
                        
                        
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
