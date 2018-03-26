//
//  ReviewAndCommentListCell.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 07/02/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ReviewAndCommentListCell: UITableViewCell {

    @IBOutlet weak var rating: DXStarRatingView!
    
    @IBOutlet var lblDayTime: UILabel!
    @IBOutlet var imgUser: UIImageView!
    
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var lblSubject: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
