//
//  cellOrder.swift
//  Skeuomo
//
//  Created by usersmart on 8/21/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class cellOrder: UITableViewCell {
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDescription: UILabel!

    @IBOutlet var btnClose: UIButton!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet weak var imgOrderCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
