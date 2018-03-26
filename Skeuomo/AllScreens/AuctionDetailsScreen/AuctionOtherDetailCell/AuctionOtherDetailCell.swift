//
//  AuctionOtherDetailCell.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 27/10/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class AuctionOtherDetailCell: UITableViewCell
{
    @IBOutlet weak var lblSize: UILabel!

    @IBOutlet weak var lblSubject: UILabel!
    
    @IBOutlet weak var lblMood: UILabel!
    
    @IBOutlet weak var lblMedium: UILabel!
    
    @IBOutlet weak var lblGenre: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
