//
//  AutionCollectionCell.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class AutionCollectionCell: UICollectionViewCell {

    @IBOutlet weak var lblArtworkTitle: UILabel!

    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblTimeDate: UILabel!
    @IBOutlet weak var lblDays: UILabel!

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserAddress: UILabel!
    
    @IBOutlet weak var imgArtwork: UIImageView!
    
    @IBOutlet weak var btnPlaceBid: UIButton!
    
    var dateTimer : Timer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
