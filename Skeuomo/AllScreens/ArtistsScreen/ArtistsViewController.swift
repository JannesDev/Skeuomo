//
//  ArtistsViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ArtistsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet weak var collectionDataShow: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        let nib = UINib(nibName: "ArtDataCollectionCell", bundle: nil)
        collectionDataShow.register(nib,forCellWithReuseIdentifier: "ArtDataCollectionCell")
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    // MARK: - UICollection View Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (collectionView.frame.size.width/2), height: 214)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtDataCollectionCell", for: indexPath as IndexPath) as! ArtDataCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let Art  = ArtistsDetailsVC(nibName:"ArtistsDetailsVC", bundle:nil)
        self.navigationController?.pushViewController(Art, animated: true)
    }

}
