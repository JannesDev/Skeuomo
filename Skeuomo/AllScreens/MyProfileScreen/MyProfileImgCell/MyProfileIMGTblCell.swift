//
//  MyProfileIMGTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 23/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class MyProfileIMGTblCell: UITableViewCell {

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var btnCamera: UIButton!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    
    @IBOutlet var lblFollowers: UILabel!
    
    @IBOutlet var lblFollowing: UILabel!
    
    @IBOutlet var btnAddress: UIButton!
    
    @IBOutlet var imgBgProfile: UIImageView!
    @IBOutlet var btnBgCamera: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
