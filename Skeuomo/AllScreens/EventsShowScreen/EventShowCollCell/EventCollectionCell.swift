//
//  EventCollectionCell.swift
//  Skeuomo
//
//  Created by by Jannes on 17/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class EventCollectionCell: UICollectionViewCell
{
    @IBOutlet weak var btnFavorite: UIButton!

    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet var imgEvent: UIImageView!
    
    @IBOutlet var lblPrice: UILabel!
    
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblEventStart: UILabel!
    @IBOutlet weak var lblEventEnd: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
