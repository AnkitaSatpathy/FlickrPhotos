//
//  PhotoCell.swift
//  PhotosDemo
//
//  Created by Ankita Satpathy on 04/12/17.
//  Copyright © 2017 Ankita Satpathy. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet weak var imageview: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
