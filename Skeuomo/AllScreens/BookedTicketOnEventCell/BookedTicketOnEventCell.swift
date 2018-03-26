//
//  BookedTicketOnEventCell.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 30/11/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class BookedTicketOnEventCell: UITableViewCell {

    
    @IBOutlet weak var imgUser: UIImageView!

    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblNoOfTicket: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
