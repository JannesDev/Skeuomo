//
//  NewsFromBlogTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 16/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class NewsFromBlogTblCell: UITableViewCell {

    @IBOutlet var imgTblCell: UIImageView!
    @IBOutlet  var txtViewDetails: UITextView!
    @IBOutlet  var btnReadMore: UIButton!
    @IBOutlet  var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
