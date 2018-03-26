//
//  VendorDetailOverviewCell.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 27/12/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class VendorDetailOverviewCell: UITableViewCell {

    @IBOutlet weak var lblMaterial: UILabel!
    
    @IBOutlet weak var lblFeedBack: UILabel!
    
    @IBOutlet weak var lblSeePolicy: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
