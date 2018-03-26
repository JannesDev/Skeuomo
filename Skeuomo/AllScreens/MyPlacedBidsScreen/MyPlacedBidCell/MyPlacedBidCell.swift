//
//  MyPlacedBidCell.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 08/11/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class MyPlacedBidCell: UICollectionViewCell {

    @IBOutlet weak var imgArtwork: UIImageView!
    
    @IBOutlet weak var lblArtworkTitle: UILabel!
    
    @IBOutlet weak var lblBidPrice: UILabel!
    
    @IBOutlet weak var lblHighestBidder: UILabel!
    
    @IBOutlet weak var lblEndDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
