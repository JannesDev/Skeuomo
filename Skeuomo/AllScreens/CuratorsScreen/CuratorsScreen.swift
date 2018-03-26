//
//  CuratorsScreen.swift
//  Skeuomo
//
//  Created by Satish ios on 21/09/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class CuratorsScreen: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate
{

    @IBOutlet var clItems           : UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        let nib = UINib(nibName: "CuratorsCell", bundle: nil)
        
        clItems.register(nib, forCellWithReuseIdentifier: "CuratorsCell")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width)/2 - 8, height: 204)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        clItems!.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionView Delegate Methods
    public func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 12
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuratorsCell", for: indexPath as IndexPath) as! CuratorsCell
        
        cell.lblCuratorName.attributedText = HelpingMethods.sharedInstance.attributedString(fromText1: "John Deo", withFont: "GIBSON-REGULAR", fontSize: 13.0, textColor1: UIColor.black, fromText2: "\nBerlin, USA", withFont: "GIBSON-LIGHT", fontSize: 12.0, textColor2: UIColor.lightGray)
        
        cell.lblCuratorName.textAlignment = .center
        cell.lblCuratorName.numberOfLines = 0
        
        return cell
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let detailView = CuratorDetailsScreen(nibName: "CuratorDetailsScreen", bundle : nil)
        self.navigationController?.pushViewController(detailView, animated: true)
        
    }
    
    // MARK: - ButtonsMethods
    
    @IBAction func btnBackMenu(_ sender: Any)
    {
        appDelegate.sideMenuController.openMenu()
    }
    
    @IBAction func btnNotifications(_ sender: Any)
    {
        let Noti = NotificationViewController(nibName:"NotificationViewController",bundle:nil)
        self.navigationController?.pushViewController(Noti, animated: true)
    }
    @IBAction func btnSearch(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
