//
//  UploadVideoTblCell.swift
//  Skeuomo
//
//  Created by by Jannes on 23/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class UploadVideoTblCell: UITableViewCell
{

    @IBOutlet weak var btnPlayAudio: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnUploadVideo: UIButton!
    @IBOutlet weak var btnUploadAudio: UIButton!
    @IBOutlet weak var imgThumb: UIImageView!
    
    @IBOutlet weak var progressAudio: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
