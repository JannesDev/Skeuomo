//
//  ColorTimeDayTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ColorTimeDayTblCell: UITableViewCell {

    
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    
    @IBOutlet weak var lblHour: UILabel!
    
    
    var dateTimer : Timer!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
