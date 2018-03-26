//
//  ColorImgTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ColorImgTblCell: UITableViewCell
{

    @IBOutlet weak var imgCollCell: UIImageView!
    
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var btnContact: UIButton!
    
    @IBOutlet weak var lblViewCount: UILabel!
    
    @IBOutlet weak var lblLikeCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
