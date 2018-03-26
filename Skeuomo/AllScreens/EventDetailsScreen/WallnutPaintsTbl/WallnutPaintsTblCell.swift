//
//  WallnutPaintsTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class WallnutPaintsTblCell: UITableViewCell {

    @IBOutlet weak var imgTblCell: UIImageView!
    @IBOutlet weak var lblPaintsType: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
