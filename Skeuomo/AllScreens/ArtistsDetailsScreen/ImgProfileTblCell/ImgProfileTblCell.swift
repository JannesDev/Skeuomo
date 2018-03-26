//
//  ImgProfileTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ImgProfileTblCell: UITableViewCell {

    @IBOutlet var imgUserProfile: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblTotalFollowing: UILabel!
    @IBOutlet var lblTotalFollowers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
