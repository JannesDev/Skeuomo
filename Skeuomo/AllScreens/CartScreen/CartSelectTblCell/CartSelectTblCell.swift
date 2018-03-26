//
//  CartSelectTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 21/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class CartSelectTblCell: UITableViewCell
{
    
    @IBOutlet weak var imgShopArt: UIImageView!
    
    @IBOutlet weak var lblShopArtName: UILabel!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var lblUnitPrice: UILabel!
    
    @IBOutlet weak var txtQty: UITextField!
    
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    @IBOutlet weak var btnRemoveFromCart: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
