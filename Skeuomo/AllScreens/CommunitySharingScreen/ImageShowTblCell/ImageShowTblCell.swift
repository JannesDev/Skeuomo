//
//  ImageShowTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 24/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ImageShowTblCell: UITableViewCell
{
    @IBOutlet weak var txtWrite: UITextView!
    
    @IBOutlet weak var viewMedia: UIView!
    
    @IBOutlet weak var viewImage: UIView!

    
    @IBOutlet weak var imgPost: UIImageView!
    
    @IBOutlet weak var viewBottomBar: UIView!
    
    @IBOutlet weak var btnAddPhoto: UIButton!
    
    @IBOutlet weak var btnAddVideo: UIButton!
    
    @IBOutlet weak var btnPost: UIButton!
    
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
