//
//  AllPlansTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 16/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class AllPlansTblCell: UITableViewCell {

    @IBOutlet var btnDropDown: UIButton!
    @IBOutlet var btnBuyNow: UIButton!
    @IBOutlet weak var lblAccountType: UILabel!
    @IBOutlet weak var lblLimitedTalent: UILabel!
    @IBOutlet weak var lblAmounts: UILabel!
    @IBOutlet weak var imgPlansBG: UIImageView!
    @IBOutlet weak var lblCadPlans: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
