//
//  MyCollectionDataCell.swift
//  Skeuomo
//
//  Created by by Jannes on 24/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class MyCollectionDataCell: UICollectionViewCell {

    @IBOutlet var imgMyCollection: UIImageView!
    @IBOutlet var imgUserPro: UIImageView!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblUserName: UILabel!
    
    @IBOutlet var btnSharing: UIButton!
    @IBOutlet var lblAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
