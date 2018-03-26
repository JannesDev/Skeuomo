//
//  FavroiteViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 24/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class FavroiteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet weak var collFavoriteData: UICollectionView!
    @IBOutlet weak var imgThemeBG: UIImageView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    var strFrom = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        let nib = UINib(nibName: "FavroiteCollectionCell", bundle: nil)
        collFavoriteData.register(nib,forCellWithReuseIdentifier: "FavroiteCollectionCell")
        self.lblHeaderTitle.text = "Favorite"
        if strFrom == "FromFavArtist"
        {
            self.lblHeaderTitle.text = "Favorite Artists"
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
        
        if UserDefaults.standard.object(forKey: "Theme") != nil {
            
            let dicTheme = UserDefaults.standard.object(forKey: "Theme") as! NSDictionary
            
            if dicTheme.allKeys.count > 0
            {
                let urlStr = NSString(format: "%@%@",kSkeuomoImageURL,(dicTheme.object(forKey: "themePic") as? String)!)
                
                let urlImage = URL.init(string: urlStr as String)
                
                imgThemeBG.setImageWith(urlImage!, placeholderImage: UIImage.init(named:""))
            }
            else
            {
                imgThemeBG.image = UIImage.init(named: "")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - ButtonsMethods
    @IBAction func btnBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

 
    // MARK: - UICollection View Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (collectionView.frame.size.width/2), height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavroiteCollectionCell", for: indexPath as IndexPath) as! FavroiteCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    }

}
