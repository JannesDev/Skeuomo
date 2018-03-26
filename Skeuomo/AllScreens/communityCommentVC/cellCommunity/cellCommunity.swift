//
//  cellCommunity.swift
//  Skeuomo
//
//  Created by usersmart on 8/21/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class cellCommunity: UITableViewCell {

    @IBOutlet var lblDayTime: UILabel!
    @IBOutlet var imgUser: UIImageView!
    
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
