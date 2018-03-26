//
//  MyEventManageCell.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 22/11/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class MyEventManageCell: UICollectionViewCell {

    @IBOutlet weak var btnCancelBooking: UIButton!

    @IBOutlet weak var btnBooking: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imgEvent: UIImageView!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblEventTitle: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
