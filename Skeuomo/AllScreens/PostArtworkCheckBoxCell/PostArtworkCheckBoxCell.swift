//
//  PostArtworkCheckBoxCell.swift
//  Skeuomo
//
//  Created by Madhusudan-iOS on 12/10/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class PostArtworkCheckBoxCell: UITableViewCell
{

    @IBOutlet weak var btnAddToGallery: UIButton!
    @IBOutlet weak var btnShareOnSocialMedia: UIButton!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
