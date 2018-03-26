//
//  CartShowAmountsTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 21/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class CartShowAmountsTblCell: UITableViewCell
{

    @IBOutlet weak var btnContinueShopping: UIButton!
    
    @IBOutlet weak var btnUpdateCart: UIButton!
    
    @IBOutlet weak var lblSubTotalAmount: UILabel!
    
    @IBOutlet weak var lblDiscountAmount: UILabel!
    
    @IBOutlet weak var lblShipping: UILabel!
    
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    @IBOutlet weak var txtCouponCode: UITextField!
    
    @IBOutlet weak var lblCouponDes: UILabel!
    @IBOutlet weak var btnApply: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
