//
//  CellAddress.swift
//  Skeuomo
//
//  Created by Ashish IOS on 9/26/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class CellAddress: UITableViewCell {

    @IBOutlet var txtviewAddress : UITextView!
    @IBOutlet var lblTxtViewHeader : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
