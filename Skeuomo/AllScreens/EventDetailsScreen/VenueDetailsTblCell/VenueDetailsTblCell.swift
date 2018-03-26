//
//  VenueDetailsTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class VenueDetailsTblCell: UITableViewCell
{
    @IBOutlet weak var lblEventAddress  : UILabel!
    @IBOutlet weak var lblEventStart    : UILabel!
    @IBOutlet weak var lblEventEnd     : UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
