//
//  NotificationTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 22/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class NotificationTblCell: UITableViewCell {

    @IBOutlet weak var lblArtName: UILabel!
    @IBOutlet weak var imgArtName: UIImageView!
    @IBOutlet weak var lblArtDetls: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
