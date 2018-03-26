//
//  MyBookedEventCell.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 01/12/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class MyBookedEventCell: UITableViewCell {

    @IBOutlet  var lblEventDate: UILabel!
    @IBOutlet  var lblEventAddress: UILabel!
    @IBOutlet  var lblEventTitle: UILabel!
    @IBOutlet  var viewBG: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
