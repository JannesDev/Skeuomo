//
//  postAdvertiseVC.swift
//  Skeuomo
//
//  Created by usersmart on 8/21/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//


import UIKit

class postAdvertiseVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var lblImgsize: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var txtfldTital: UITextField!
    @IBOutlet var imgAdvertise: UIImageView!
    @IBOutlet var viewTital: UIView!
    var imageData = NSData()

    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTital.layer.borderWidth = 1.0;
        viewTital.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
        
        lblImgsize.text = "upload image size should 2000px * 1500px weight 500mb"
        
        DispatchQueue.main.async
            {
                self.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0,0)
                if self.appDelegate.screenHeight <= 568
                {
                    self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height:568)
                }
                else
                {
                    self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                }
        }
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
    }
 // MARK:- ButtonsMethod
    @IBAction func btnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK:- btn upload adv.
    
    @IBAction func btnUploadImage(_ sender: AnyObject) {
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
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil
        {
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.camera
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
        picker.allowsEditing = true
        // let myPickerController = UIImagePickerController()
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imgAdvertise.image = image
            
            //     print("Before :",image.size)
            //   NSLog(@"Before : %@",NSStringFromCGSize(image.size));
        } else{
            
            appDelegate.ShowAlert(message: "No camera")
        }
        imageData = UIImageJPEGRepresentation(imgAdvertise.image!, 0.7)! as NSData
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK:- txtfld delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Web Service Methods
    
    
    


}
