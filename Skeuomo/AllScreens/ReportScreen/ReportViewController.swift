//
//  ReportViewController.swift
//  Skeuomo
//
//  Created by by Jannes on 22/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, LineChartDelegate {
    
    @IBOutlet weak var tblReportShow: UITableView!
    
    @IBOutlet weak var imgThemeBG: UIImageView!
    
    var isClick: Int!
    var arrReportSlt = NSMutableArray()
    
    var arrTotalReport : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrTotalReport = ["Sold Item","Total Revenue", "Sale Graph"]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    // MARK: - ButtonsMethod
    @IBAction func btnBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
 
    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if arrReportSlt.contains(section)
        {
            if section == 0
            {
                return 5
            }
            else if section == 1
            {
                return 2
            }
            else if section == 2
            {
                return 2
            }
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                return 58
            }
            else
            {
                return 80
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                return 58
            }
            else
            {
                return 170
            }
        }
        else if indexPath.section == 2
        {
            if indexPath.row == 0
            {
                return 58
            }
            else
            {
                return 270
            }
        }
        else
        {
            return 58
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cellIdentifier:String = "ReportHeadingTblCell"
            var cell:ReportHeadingTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ReportHeadingTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("ReportHeadingTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? ReportHeadingTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            //ForIncraseSeparatorSize
            cell?.preservesSuperviewLayoutMargins = false
            cell?.separatorInset = UIEdgeInsets.zero
            cell?.layoutMargins = UIEdgeInsets.zero
            
            cell?.btnPlusMinus.tag = indexPath.section
            cell?.btnPlusMinus.addTarget(self,action: #selector(btnSetPlusMinus),for: UIControlEvents.touchUpInside)
            
            cell?.lblReportItems.text = arrTotalReport.object(at: indexPath.section) as? String
            
            if arrReportSlt.contains(indexPath.section)
            {
                cell?.btnPlusMinus.isSelected = true
            }
            else
            {
                cell?.btnPlusMinus.isSelected = false
            }
            return cell!
        }
            
        else
        {
            if indexPath.section == 1
            {
                let cellIdentifier:String = "TotalRevenueTblCell"
                var cell:TotalRevenueTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? TotalRevenueTblCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("TotalRevenueTblCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? TotalRevenueTblCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                
                cell?.vieRevenueDrop.layer.borderWidth = 1.0
                cell?.vieRevenueDrop.layer.borderColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
                cell?.vieFirstCell.layer.borderWidth = 1.0
                cell?.vieFirstCell.layer.borderColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
                cell?.vieSecondCell.layer.borderWidth = 1.0
                cell?.vieSecondCell.layer.borderColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
                cell?.vieThirdCell.layer.borderWidth = 1.0
                cell?.vieThirdCell.layer.borderColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
                
                return cell!

            }
            else if indexPath.section == 2
            {
                let cellIdentifier:String = "SaleGraphTblCell"
                var cell:SaleGraphTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SaleGraphTblCell
                
                if (cell == nil)
                {
                    let nib:Array = Bundle.main.loadNibNamed("SaleGraphTblCell", owner: nil, options: nil)! as [Any]
                    
                    cell = nib[0] as? SaleGraphTblCell
                    cell!.selectionStyle = UITableViewCellSelectionStyle.none
                    cell?.backgroundColor = (UIColor.clear);
                }
                let data: [CGFloat] = [80, 60, 0, 20, 80, 40]
                //let data2: [CGFloat] = [1, 3, 5, 13, 17, 20]
                
                // simple line with custom x axis labels
                let xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
                
                cell?.vieLineChart.animation.enabled = true
                cell?.vieLineChart.area = true
                cell?.vieLineChart.x.labels.visible = true
                cell?.vieLineChart.x.grid.count = 20
                cell?.vieLineChart.y.grid.count = 20
                cell?.vieLineChart.x.labels.values = xLabels
                cell?.vieLineChart.y.labels.visible = true
                cell?.vieLineChart.addLine(data)
                cell?.vieLineChart.translatesAutoresizingMaskIntoConstraints = false
                cell?.vieLineChart.delegate = self
                
                cell?.vieSetTime.layer.borderWidth = 1.0
                
                cell?.vieSetTime.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
                
                return cell!
                
            }
            else
            {
            let cellIdentifier:String = "SubHeadingTblCell"
            var cell:SubHeadingTblCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SubHeadingTblCell
            
            if (cell == nil)
            {
                let nib:Array = Bundle.main.loadNibNamed("SubHeadingTblCell", owner: nil, options: nil)! as [Any]
                
                cell = nib[0] as? SubHeadingTblCell
                cell!.selectionStyle = UITableViewCellSelectionStyle.none
                cell?.backgroundColor = (UIColor.clear);
            }
            cell?.vieBGCell.layer.cornerRadius = 4.0
            cell?.vieBGCell.layer.borderWidth = 1.0
            cell?.vieBGCell.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
            return cell!
            }
        }
        
    }
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>)
    {
        //label.text = "x: \(x)     y: \(yValues)"
    }
    
    
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
//        if let chart = lineChart {
//            chart.setNeedsDisplay()
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    func btnSetPlusMinus(sender:UIButton)
    {
        if arrReportSlt.contains(sender.tag)
        {
            arrReportSlt.remove(sender.tag)
        }
        else
        {
            arrReportSlt.add(sender.tag)
        }
        tblReportShow.reloadData()
    }
    
    
}
