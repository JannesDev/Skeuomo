//
//  ShopArtShippingEntryCell.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 25/12/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ShopArtShippingEntryCell: UITableViewCell {

    @IBOutlet weak var ViewTitleBG: UIView!
    
    @IBOutlet weak var btnRemove: UIButton!
    
    @IBOutlet weak var txtEntry: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
