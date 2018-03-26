//
//  PlansPriviewCell.swift
//  Skeuomo
//
//  Created by Satish ios on 21/09/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class PlansPriviewCell: UICollectionViewCell
{
    @IBOutlet var viewBack      : UIView!
    @IBOutlet var imgPlane      : UIImageView!
    @IBOutlet var tblPlans      : UITableView!
    @IBOutlet var lblSubScribe  : UILabel!
    @IBOutlet var lblLine       : UILabel!
    @IBOutlet var lblTitle      : UILabel!
    @IBOutlet var lblCad        : UILabel!
    @IBOutlet var lblAmount     : UILabel!
    @IBOutlet var lblPerYear    : UILabel!
    @IBOutlet var scrlPage      : UIScrollView!
    
    @IBOutlet var btnSuscribe   : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
