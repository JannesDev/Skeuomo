//
//  MapEventCell.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 01/12/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

import MapKit

class MapEventCell: UITableViewCell {

    @IBOutlet weak var mapEvent: MKMapView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
