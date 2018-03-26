//
//  ArtistsGalleriaTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 25/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ArtistsGalleriaTblCell: UICollectionViewCell {
    
    @IBOutlet weak var imgArtwork: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblArtworkTitle: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
