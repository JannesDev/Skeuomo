//
//  SettingsTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 22/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class SettingsTblCell: UITableViewCell {

    @IBOutlet var lblSettingsName: UILabel!
    @IBOutlet var switchNotification: UISwitch!
    @IBOutlet var btnAero: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
