//
//  MyLibraryCollCell.swift
//  Skeuomo
//
//  Created by by Jannes on 24/08/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class MyLibraryCollCell: UICollectionViewCell
{

    @IBOutlet var btnPrivate: UIButton!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var imgArtwork: UIImageView!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblArtworkTitle: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

}
