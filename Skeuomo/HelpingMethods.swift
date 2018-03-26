//
//  HelpingMethods.swift
//  Skeuomo
//
//  Created by Deepak iOS on 15/09/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit
import FCAlertView
import MBProgressHUD
import AFNetworking
import SystemConfiguration


class HelpingMethods: NSObject {

    static let sharedInstance: HelpingMethods = {
        let instance = HelpingMethods()
        // setup code
        return instance
    }()
    
    func showMessageAlert(strTitle : String , strSubtitle : String , controller : UIViewController)  {
        
        let alert = FCAlertView()
        alert.showAlert(inView: controller, withTitle: strTitle, withSubtitle: strSubtitle, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
    }

    func ShowHUD()  {
        MBProgressHUD.showAdded(to: (UIApplication.shared.delegate as! AppDelegate).window!, animated: true)
        
    }
    
    func hideHUD()  {
        MBProgressHUD.hide(for: (UIApplication.shared.delegate as! AppDelegate).window!, animated: true)
    }
    
    func thumbnailForVideoAtURL(url: NSURL) -> UIImage? {
        
        let asset = AVAsset(url: url as URL)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        var time = asset.duration
        
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
    
    //MARK:Image Orientation
    func fixedOrientation(img : UIImage) -> UIImage {
        
        
        if img.imageOrientation == UIImageOrientation.up {
            return img
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch img.imageOrientation
        {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: img.size.width, y: img.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: img.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: img.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        
        switch img.imageOrientation
        {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: img.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: img.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        }
        
        let ctx: CGContext = CGContext(data: nil, width: Int(img.size.width), height: Int(img.size.height), bitsPerComponent: img.cgImage!.bitsPerComponent, bytesPerRow: 0, space: img.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch img.imageOrientation
        {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(img.cgImage!, in: CGRect(origin: CGPoint.zero, size: img.size))
        default:
            ctx.draw(img.cgImage!, in: CGRect(origin: CGPoint.zero, size: img.size))
            break
        }
        
        let cgImage: CGImage = ctx.makeImage()!
        
        return UIImage(cgImage: cgImage)
    }

    
    
    func Showerrormessage(error : Error , controller : UIViewController)
    {
        let nserror = error as NSError
        
        let errorData: Data? = nserror.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! Data?
        
        do {
            if let data = errorData,
                let json = try JSONSerialization.jsonObject(with: data) as? NSDictionary,
                 let code = json["code"] as? Int
               {
                let alert = FCAlertView()
                alert.showAlert(inView: controller, withTitle: "", withSubtitle: json["msg"] as! String, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
               }
            
        }
        catch
        {
            print("Error deserializing JSON: \(error)")
        }
        

    }
    
    // MARK : Check internet connection
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    //MARK: End
    //MARK: - EmailValidation
    
    func isValidEmail(_ testStr:String) -> Bool
    {
        print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    
    
    
//    func encodeUrlString(strURl:String) -> String
//    {
//        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
//
//        if let escapedString = strURl.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
//        {
//
//            //do something with escaped string
//
//            return escapedString
//        }
//
//        return ""
//    }
    
    
    func getDynamicHeight(strText:NSString, Width:CGFloat, font:NSString, fontSize:CGFloat) -> CGRect
    {
    let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle.init()
        
    paragraphStyle.lineSpacing = 1
    
    
    let dict = [NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.init(name: font as String, size: fontSize)] as [String : Any]
    
    let  captionlableSize: CGRect = strText.boundingRect(with: CGSize(width: CGFloat(Width), height: CGFloat(FLT_MAX)), options: .usesLineFragmentOrigin, attributes: dict, context: nil)
    
    return captionlableSize
        
    }
    
    func attributedString(fromText1 string1: String, withFont fontName1 : String, fontSize size1: CGFloat, textColor1 color1 : UIColor, fromText2 string2: String, withFont fontName2 : String, fontSize size2: CGFloat, textColor2 color2 : UIColor) -> NSMutableAttributedString
    {
        let attrs1 = [NSFontAttributeName : UIFont.init(name: fontName1, size: size1)!, NSForegroundColorAttributeName : color1]
        
        let attrs2 = [NSFontAttributeName : UIFont.init(name: fontName2, size: size2)!, NSForegroundColorAttributeName : color2]
        
        let attributedString1 = NSMutableAttributedString(string:"\(string1) ", attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:"\(string2)", attributes:attrs2)
        
        attributedString1.append(attributedString2)
        return attributedString1
    }
    
    
    func removeUserdData()
    {
        
        UserDefaults.standard.removeObject(forKey: "UserDatail")
        UserDefaults.standard.removeObject(forKey: "session_id")
        UserDefaults.standard.removeObject(forKey: "isLogin")
        UserDefaults.standard.removeObject(forKey: "Theme")

        UserDefaults.standard.synchronize()
    }
}
