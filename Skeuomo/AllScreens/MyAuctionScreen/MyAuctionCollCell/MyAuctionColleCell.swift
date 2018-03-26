//
//  MyAuctionColleCell.swift
//  Skeuomo
//
//  Created by by Jannes on 22/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class MyAuctionColleCell: UICollectionViewCell {

    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    
    @IBOutlet var imgArtwork: UIImageView!
    @IBOutlet var lblArtworkTitle: UILabel!
    
    var dateTimer : Timer!
    
    @IBOutlet weak var lblDays: UILabel!
    
    @IBOutlet weak var lblHour: UILabel!
    
    @IBOutlet weak var lblMin: UILabel!
    
    @IBOutlet weak var lblSec: UILabel!
    
    @IBOutlet weak var btnTotalBid: UIButton!
    
    @IBOutlet weak var lblHighestPrice: UILabel!
    
    @IBOutlet weak var lblStartingPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
