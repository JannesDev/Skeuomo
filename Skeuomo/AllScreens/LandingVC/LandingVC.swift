//
//  LandingVC.swift
//  Skeuomo
//
//  Created by Ashish IOS on 10/3/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class LandingVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collview :  UICollectionView!
    
    @IBOutlet weak var pageControll : UIPageControl!
    
    @IBOutlet weak var lblHeading   : UILabel!
    
    @IBOutlet weak var lblDes   : UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "CellLandingImg", bundle: nil)
        
        collview.register(nib,forCellWithReuseIdentifier: "CellLandingImg")
        
        self.automaticallyAdjustsScrollViewInsets =   false;
    }
    
    // MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        
        let cellSize:CGSize = CGSize(width: self.collview.frame.size.width , height:self.collview.frame.size.height )
        return cellSize
        
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellLandingImg", for: indexPath as IndexPath) as! CellLandingImg
        
        if(indexPath.item == 0)
        {
            cell.imgBG.image =  UIImage.init(named: "slide1.png")
        }
        else if(indexPath.item == 1)
        {
            cell.imgBG.image =  UIImage.init(named: "slide2.png")
        }
        else
        {
            cell.imgBG.image =  UIImage.init(named: "slide3.png")
        }
        
        
        return cell
    }
    
    
    // MARK: CollectionView Delegate End
    //MARK: Scrollview Method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        
        let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
        
        let selectedPage = Int(currentPage)
        
        pageControll.currentPage = selectedPage
        
        switch selectedPage {
        case 0:
             self.lblHeading.text = "Welcome"
             self.lblDes.text = "The world's leading online art gallery"
            break
        case 1:
            self.lblHeading.text = "Discover"
            self.lblDes.text = "New work by Skeuomo artist from around the world"
            break
        case 2:
            self.lblHeading.text = "Artshop"
            self.lblDes.text = "List & sell services and art supplies on the art shop"
            break
        default:
            break
        }
        
        
    }
    
    @IBAction func MethodGetStart(_  sender : UIButton)
    {
        appDelegate.ShowMainViewController(ViewCount: 0)
    }
}
