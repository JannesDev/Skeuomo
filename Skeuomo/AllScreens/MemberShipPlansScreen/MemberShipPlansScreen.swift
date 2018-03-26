//
//  MemberShipPlansScreen.swift
//  Skeuomo
//
//  Created by Satish ios on 21/09/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class MemberShipPlansScreen: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet var pageControl       : UIPageControl!
    @IBOutlet var clPlans           : UICollectionView!
    
    var arrPlansDetails : NSArray = ["Create Public Gallery Only (no market place access)","Limit of 5 items artwork items per gallery","Invite others to our talent page via social media share and tweet","Social network features (unlimited)"]
    
    var arrPlanImages : NSArray = ["1plan","2plan","3plan","4plan"]
    
    var arrPlanTitle : NSArray = ["ARTISAN ACCOUNT","ARTISAN ACCOUNT","CURATOR ACCOUNT","VENDOR ACCOUNT"]
    
    var arrPlanAmmount : NSArray = ["FREE","$149.99","$169.99","$169.99"]
    
    var arrSubRed : NSArray = [CGFloat(0.0/255.0),CGFloat(0.0/255.0),CGFloat(252.0/255.0),CGFloat(0.0/255.0)]
    var arrSubGreen : NSArray = [CGFloat(147.0/255.0),CGFloat(144.0/255.0),CGFloat(93.0/255.0),CGFloat(0.0/255.0)]
    var arrSubBlue : NSArray = [CGFloat(255.0/255.0),CGFloat(29.0/255.0),CGFloat(0.0/255.0),CGFloat(147.0/255.0)]
    
    var arrLineRed : NSArray = [CGFloat(73.0/255.0),CGFloat(74.0/255.0),CGFloat(151.0/255.0),CGFloat(57.0/255.0)]
    var arrLineGreen : NSArray = [CGFloat(146.0/255.0),CGFloat(164.0/255.0),CGFloat(64.0/255.0),CGFloat(33.0/255.0)]
    var arrLineBlue : NSArray = [CGFloat(188.0/255.0),CGFloat(149.0/255.0),CGFloat(20.0/255.0),CGFloat(72.0/255.0)]

    override func viewDidLoad()
    {
        super.viewDidLoad()

         pageControl.numberOfPages = 4
        
        let nib = UINib(nibName: "PlansPriviewCell", bundle: nil)
        clPlans.register(nib, forCellWithReuseIdentifier: "PlansPriviewCell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews()
    {
        
        pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
        
    }
    
    // MARK: - UICollection View Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrPlanImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        let cellSize:CGSize = CGSize.init(width: clPlans.frame.width, height: clPlans.frame.height)
        
        return cellSize
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlansPriviewCell", for: indexPath) as! PlansPriviewCell
        
        if indexPath.item == 0
        {
            cell.lblCad.isHidden = true
            cell.lblPerYear.isHidden = true
        }
        else
        {
            cell.lblCad.isHidden = false
            cell.lblPerYear.isHidden = false
        }
        
        cell.lblTitle.text = "\(arrPlanTitle.object(at: indexPath.row))"
        cell.lblAmount.text = "\(arrPlanAmmount.object(at: indexPath.row))"
        cell.lblAmount.adjustsFontSizeToFitWidth = true
        
        cell.scrlPage.tag = indexPath.item
        cell.scrlPage.delegate = self
        
        cell.tblPlans.separatorStyle = .none
        cell.tblPlans.dataSource = self
        cell.tblPlans.delegate = self
        
        cell.imgPlane.image = UIImage.init(named: "\(arrPlanImages.object(at: indexPath.row))")
        
        let subRed : CGFloat = arrSubRed.object(at: indexPath.row) as! CGFloat
        let subGreen : CGFloat = arrSubGreen.object(at: indexPath.row) as! CGFloat
        let subBlue : CGFloat = arrSubBlue.object(at: indexPath.row) as! CGFloat
        
        let lineRed : CGFloat = arrLineRed.object(at: indexPath.row) as! CGFloat
        let lineGreen : CGFloat = arrLineGreen.object(at: indexPath.row) as! CGFloat
        let lineBlue : CGFloat = arrLineBlue.object(at: indexPath.row) as! CGFloat
        
        
        
        cell.lblSubScribe.textColor = UIColor.init(red: subRed, green: subGreen, blue: subBlue, alpha: 1.0)
        
        cell.lblLine.textColor = UIColor.init(red: lineRed, green: lineGreen, blue: lineBlue, alpha: 1.0)
        
        
        cell.btnSuscribe.addTarget(self, action: #selector(MethodClickOnSuscribe), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
    
    func MethodClickOnSuscribe(_ sender  : UIButton)
    {
        self.appDelegate.showtabbar()

    }
    
    // Mark:- table view delegate and data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrPlansDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "PlanDetailCell"
        var cell:PlanDetailCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PlanDetailCell
        
        if (cell == nil)
        {
            let nib:Array = Bundle.main.loadNibNamed("PlanDetailCell", owner: nil, options: nil)! as [Any]
            
            cell = nib[0] as? PlanDetailCell
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = (UIColor.clear);
        }
        
        cell?.lblPlanDetails.text = "\(arrPlansDetails.object(at: indexPath.row))"
        
        return cell!
    }
    
    //MARK: - UIScrollView Delegates
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        if (scrollView is UICollectionView)
        {
            let value : CGFloat = scrollView.contentOffset.x / scrollView.frame.size.width
            
            pageControl.currentPage = Int(value)
        }
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
