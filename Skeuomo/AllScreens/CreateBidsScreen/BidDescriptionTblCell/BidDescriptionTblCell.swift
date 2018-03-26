//
//  BidDescriptionTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 23/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class BidDescriptionTblCell: UITableViewCell
{

    @IBOutlet weak var lblDesLength: UILabel!
    @IBOutlet var vieDescriptionBG: UIView!
    @IBOutlet weak var txtViewDescription: SZTextView!
    @IBOutlet weak var lblTitle : UILabel!
    
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
