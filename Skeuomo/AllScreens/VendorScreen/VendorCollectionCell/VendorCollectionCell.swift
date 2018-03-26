//
//  VendorCollectionCell.swift
//  Skeuomo
//
//  Created by by Jannes on 22/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class VendorCollectionCell: UICollectionViewCell {

    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var imgCollCell: UIImageView!
    
    
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblShopArtTitle: UILabel!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
