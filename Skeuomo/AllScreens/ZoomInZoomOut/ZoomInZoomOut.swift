//
//  ZoomInZoomOut.swift
//  YouVote
//
//  Created by Ashish IOS on 12/15/16.
//  Copyright © 2016 NineHertz Pvt Ltd. All rights reserved.
//

import UIKit

class ZoomInZoomOut: UIViewController,UIScrollViewDelegate {

    @IBOutlet var Scrollview : UIScrollView!
    
    @IBOutlet var ImgView : UIImageView!
    
    @IBOutlet var Btn_Back : UIButton!
    
    var imgUrl : NSString!
    
    var IsImage = Bool()
    
    var ShowImg : UIImage!
    
    
    override func viewDidLoad()
    {
        self.tabBarController?.tabBar .isHidden = true
        super.viewDidLoad()
        
        if(IsImage)
        {
            //print("show img %@",ShowImg)
            
            //ImgView = UIImageView.init(image: UIImage.init(named: "user.jpg"))
            if #available(iOS 9.0, *) {
                  self.ImgView.image = ShowImg
                // use the feature only available in iOS 9
                // for ex. UIStackView
            } else {
                // or use some work around
                ImgView = UIImageView.init(image: ShowImg)
                
            }
            
        }
        else
        {
            let   urlImage : NSURL = NSURL(string: imgUrl as String)!
            
            ImgView.setImageWith(urlImage as URL, placeholderImage: UIImage.init(named:"art-place.png"))
        }
        
        self.ImgView.isUserInteractionEnabled = true

        Scrollview.delegate = self
        
        Scrollview.minimumZoomScale = 1.0
        Scrollview.maximumZoomScale = 5
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func Method_Back(sender :UIButton)
//    {
//        navigationController?.popViewControllerAnimated(true)
//    }

    @IBAction func Back(sender: AnyObject)
    {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return ImgView

    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: - how to use this function
    
//    //method show image zoom
//    
//    func  Method_show_image(imgURL : NSString)
//    {
//        let obj = ZoomInZoomOut(nibName:"ZoomInZoomOut",bundle: nil)
//        
//        obj.imgUrl = imgURL
//        
//        navigationController?.pushViewController(obj, animated: true)
//    }

}
