//
//  MyAucDetailTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 21/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class MyAucDetailTblCell: UITableViewCell
{

    @IBOutlet weak var btnWinner: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var btnBidPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
