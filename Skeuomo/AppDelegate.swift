
//  AppDelegate.swift
//  Skeuomo
//
//  Created by by Jannes on 12/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import CoreLocation
import Security
import AFNetworking
import FBSDKLoginKit
import GoogleSignIn
import GoogleMaps
import GooglePlaces

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UITabBarDelegate,UITabBarControllerDelegate
{
    var strUrlAuthanticateType : NSString!

    var window: UIWindow?
    var appDelegate : AppDelegate!
    var screenHeight : CGFloat!
    var screenWidth : CGFloat!
    
    var selectTab:NSInteger = 0
    let TabLogin = UITabBarController()
    
    let kHelpingMethods = HelpingMethods.sharedInstance
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var sideMenuController = MVYSideMenuController()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        GetLocationPremission()
        
        screenWidth = UIScreen.main.bounds.size.width
        screenHeight = UIScreen.main.bounds.size.height
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.getCountryList()
        
        
        if UserDefaults.standard.object(forKey: "isLogin") != nil
        {
            showtabbar()
           // ShowMainMenu()
        }
        else
        {
            // self.showtabbar()
           showFirstPage()
        }
        
        //Google Map And Place Picker
        
        GMSServices.provideAPIKey(kSkeuomoGoogleApi)
        GMSPlacesClient.provideAPIKey(kSkeuomoGoogleApi)
        
        return true
    }
    
    func showFirstPage()
    {
        
        
        let startScreen : LandingVC =  LandingVC(nibName:"LandingVC",bundle:nil)
        
        //let startScreen : LoginViewController =  LoginViewController(nibName:"LoginViewController",bundle:nil)
        
        let NavigationController = UINavigationController(rootViewController: startScreen)
        
        window?.rootViewController = NavigationController
        
        NavigationController.isNavigationBarHidden = true
    }
    
    
    func ShowAlert(message: String)
    {
        let alert = UIAlertView()
        alert.title = "Skeuomo"
        alert.message = message
        alert.addButton(withTitle: "Ok")
        alert.show()
    }
    
    // MARK:- Location Methods
    
    func GetLocationPremission()
    {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 2
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        currentLocation = manager.location!
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        
        print("Callback Url",url)
        
        if strUrlAuthanticateType == "GOOGLE"
        {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        }
        

        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
    }

    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        
        if tabBarController.selectedIndex != 2
        {
            selectTab = TabLogin.selectedIndex
        }
    
    }
    
    
    func ShowMainViewController(ViewCount : Int)
    {
        switch ViewCount
        {
        case 0:
            let startScreen : LoginViewController =  LoginViewController(nibName:"LoginViewController",bundle:nil)
            
            let NavigationController = UINavigationController(rootViewController: startScreen)
            
            window?.rootViewController = NavigationController
            
            NavigationController.isNavigationBarHidden = true

            break
            
        case 1:
            self.showtabbar()
            
            break
        default:
            break
        }
    }
    
    //MARK - TabBar;
    func showtabbar()
    {
       // xmppManager?.connectToServer()
        
        let Home = HomeViewController(nibName: "HomeViewController", bundle:nil)
        let Messages = MessagesViewController(nibName: "MessagesViewController", bundle:nil)
        let ArtGeoMap = EventsShowVC(nibName: "EventsShowVC", bundle:nil)
        
        let DashBoard = DeshboardMenuScreen(nibName: "DeshboardMenuScreen", bundle:nil)

//        let DashBoard = DeshboardViewController(nibName: "DeshboardViewController", bundle:nil)
        
        let nav_Home = UINavigationController(rootViewController: Home)
        nav_Home.isNavigationBarHidden = true
        
        let nav_Msg = UINavigationController(rootViewController: Messages)
        nav_Msg.isNavigationBarHidden = true
        
        let nav_ArtMap = UINavigationController(rootViewController: ArtGeoMap)
        nav_ArtMap.isNavigationBarHidden = true
   
        let nav_DashB = UINavigationController(rootViewController: DashBoard)
        nav_DashB.isNavigationBarHidden = true
        
        
        let count = [nav_Home,nav_Msg,nav_ArtMap,nav_DashB]
        // let count = [nav_Home,nav_Contacts]
        
        TabLogin.viewControllers = count
        TabLogin.delegate = self
        
        let  tabItem1 : UITabBarItem = self.TabLogin.tabBar.items![0]
        tabItem1.image = UIImage (named: "homeB")?.withRenderingMode(.alwaysOriginal)
        tabItem1.selectedImage = UIImage (named: "home_active")?.withRenderingMode(.alwaysOriginal)
      
        tabItem1.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        let  tabItem2 : UITabBarItem = self.TabLogin.tabBar.items![1]
        
        tabItem2.image = UIImage (named: "msgB")?.withRenderingMode(.alwaysOriginal)
        tabItem2.selectedImage = UIImage (named: "msg_active")?.withRenderingMode(.alwaysOriginal)
        tabItem2.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let  tabItem3 : UITabBarItem = self.TabLogin.tabBar.items![2]
        tabItem3.image = UIImage (named: "country")?.withRenderingMode(.alwaysOriginal)
        tabItem3.selectedImage = UIImage (named: "map_active")?.withRenderingMode(.alwaysOriginal)
        tabItem3.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let  tabItem4 : UITabBarItem = self.TabLogin.tabBar.items![3]
        tabItem4.image = UIImage (named: "card.png")?.withRenderingMode(.alwaysOriginal)
        tabItem4.selectedImage = UIImage (named: "dashboard_active")?.withRenderingMode(.alwaysOriginal)
        tabItem4.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
       // TabLogin.tabBar.shadowImage = UIImage(named: "transparentShadow.png")
       // TabLogin.tabBar.setValue((true), forKeyPath: "_hidesShadow")
        
        UITabBar.appearance().barTintColor = UIColor.white
        self.window!.rootViewController = TabLogin
        self.window?.makeKeyAndVisible()
        let LeftMenuViewController:SideMenuViewController = SideMenuViewController(nibName:"SideMenuViewController",bundle: nil)
        
        LeftMenuViewController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
//        let HomeView  = HomeViewController(nibName:"HomeViewController",bundle: nil)
//        let navigationController = UINavigationController(rootViewController: HomeView)
//        navigationController.setNavigationBarHidden(true, animated: false)
        
        let options = MVYSideMenuOptions()
        options.contentViewScale = 1.0
        options.contentViewOpacity = 0.8
        options.shadowOpacity = 1.0
        
        sideMenuController = MVYSideMenuController(menuViewController: LeftMenuViewController, contentViewController: TabLogin, options: options)
        
        sideMenuController.menuFrame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat((window?.bounds.size.width)!-80), height: CGFloat((window?.bounds.size.height)!))
        
        self.window!.rootViewController = sideMenuController
    }
    
    
    func getCountryList()
    {
        var urlstring:String!
        urlstring = String(format: "%@country_list?", kSkeuomoMainURL)
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed);        print(urlstring)
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer.setValue("skeuomo@5632832", forHTTPHeaderField: "appkey")
        let utcTimestamp = Date().timeIntervalSince1970
        let token = MD5(NSString.init(format: "%f", utcTimestamp) as String)
        manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        manager.requestSerializer.setValue(NSString.init(format: "%f", utcTimestamp) as String, forHTTPHeaderField: "timestamp")

        manager.get(urlstring, parameters: nil, progress: nil, success: { (operation, responseObject) in
            print(responseObject)
            
           if ((responseObject as! NSDictionary).object(forKey: "code") as! Int == 200 && (responseObject as! NSDictionary).object(forKey: "status") as! Bool == true)
            {
                if ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "country") != nil
                {
                let arrCountry = ((responseObject as! NSDictionary).object(forKey: "responseData") as! NSDictionary).object(forKey: "country") as! NSArray
 
             //    kUserDefault.set
             UserDefaults.standard.set(arrCountry, forKey: "CountryList")
             
                }
                
            }
            else
            {
                //HelpingMethods.sharedInstance.showMessageAlert(strTitle: "Skeuomo", strSubtitle: ((responseObject as! NSDictionary).object(forKey: "msg") as! NSString) as String , controller: self)
            }

        }) { (operation, error) in
            
        }
        
    }
    
    
    func makeStringforToken(str : NSString) -> NSString {
      //  skeuomo@5632832
        
        return ""
    }
    func MD5(_ string: String) -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        if let d = string.data(using: String.Encoding.utf8) {
            d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
    //    func md5(_ string: String) -> String
//    {
//        
//        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
//        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
//        CC_MD5_Init(context)
//        CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
//        CC_MD5_Final(&digest, context)
//        context.deallocate(capacity: 1)
//        var hexString = ""
//        for byte in digest {
//            hexString += String(format:"%02x", byte)
//        }
//        
//        return hexString
//    }
    
}


extension NSString
{
    public func stringByAddingPercentEncodingForFormData(plusForSpace: Bool=false) -> String? {
        let unreserved = "*-._"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        
        if plusForSpace {
            allowed.addCharacters(in: " ")
        }
        
        let encoded = self.addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
        
        return encoded
    }
    
}

extension UIViewController
{
    
    func jsonString(arr: Any) -> String?
    {
        if let objectData = try? JSONSerialization.data(withJSONObject: arr, options: JSONSerialization.WritingOptions(rawValue: 0))
        {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        
        return nil
    }
    
    var appDelegate:AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func Method_HeightCalculation(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let rect =  CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let label:UILabel = UILabel(frame: rect)
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
}


