//
//  ColorsHairTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ColorsHairTblCell: UITableViewCell {

    @IBOutlet weak var imgTblCell: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var btnPlayAudio: UIButton!
    @IBOutlet weak var progressAudio: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
