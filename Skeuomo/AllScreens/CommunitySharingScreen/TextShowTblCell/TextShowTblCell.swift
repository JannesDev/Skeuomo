//
//  TextShowTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 24/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class TextShowTblCell: UITableViewCell
{
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var btnSharing: UIButton!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!

    
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
