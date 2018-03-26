//
//  FilterPriceTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 16/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class FilterPriceTblCell: UITableViewCell
{

    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    
    @IBOutlet weak var txtMaxPrice: MDTextField!

    @IBOutlet weak var txtMinPrice: MDTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
