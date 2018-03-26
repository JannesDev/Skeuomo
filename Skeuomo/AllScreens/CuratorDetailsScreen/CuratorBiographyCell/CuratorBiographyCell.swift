//
//  CuratorBiographyCell.swift
//  Skeuomo
//
//  Created by Satish ios on 22/09/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class CuratorBiographyCell: UITableViewCell
{
    @IBOutlet var lblDescription        : UILabel!
    @IBOutlet var imgVideoeThumb        : UIImageView!
    @IBOutlet var viewVideo             : UIView!
    @IBOutlet var btnVideoPlay          : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
