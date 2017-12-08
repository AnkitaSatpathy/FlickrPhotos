//
//  PhotoDetailViewController.swift
//  PhotosDemo
//
//  Created by Ankita Satpathy on 08/12/17.
//  Copyright © 2017 Ankita Satpathy. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var thumbnail: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     imageView.image = self.thumbnail
       
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
