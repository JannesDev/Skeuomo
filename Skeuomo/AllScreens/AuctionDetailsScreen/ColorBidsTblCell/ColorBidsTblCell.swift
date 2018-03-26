//
//  ColorBidsTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ColorBidsTblCell: UITableViewCell
{
    @IBOutlet weak var lblTotalBid: UILabel!
    @IBOutlet weak var lblHighestBid: UILabel!

    @IBOutlet weak var lblStartingPrice: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
