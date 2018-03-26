//
//  GenderLocationTblcell.swift
//  Skeuomo
//
//  Created by by Jannes on 23/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class GenderLocationTblcell: UITableViewCell {

    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
