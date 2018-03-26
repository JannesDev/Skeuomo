//
//  DateTimeTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 23/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class DateTimeTblCell: UITableViewCell {
    @IBOutlet var vieFrom : UIView!
    @IBOutlet var vieTo : UIView!
     @IBOutlet var txtStartDate : UITextField!
     @IBOutlet var txtEndDate : UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
