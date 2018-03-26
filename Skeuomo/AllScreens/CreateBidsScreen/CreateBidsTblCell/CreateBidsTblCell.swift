//
//  CreateBidsTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 23/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class CreateBidsTblCell: UITableViewCell {

    @IBOutlet weak var txtCreateBid: MDTextField!
    @IBOutlet weak var lblCreateBids: UILabel!
    @IBOutlet weak var btnAero: UIButton!
    @IBOutlet var vieTitleBG : UIView!
    @IBOutlet var lblSeprator: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
