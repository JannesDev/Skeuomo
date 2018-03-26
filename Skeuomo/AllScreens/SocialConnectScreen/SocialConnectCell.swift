//
//  SocialConnectCell.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 19/02/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class SocialConnectCell: UITableViewCell {

    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var switchSocial: UISwitch!
    @IBOutlet var imgSocial: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
