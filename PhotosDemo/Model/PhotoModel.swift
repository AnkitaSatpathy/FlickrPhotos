//
//  PhotoModel.swift
//  PhotosDemo
//
//  Created by Ankita Satpathy on 04/12/17.
//  Copyright © 2017 Ankita Satpathy. All rights reserved.
//

import Foundation
import UIKit

class PhotoModel {
    var thumbnail : UIImage?
    var largeImage : UIImage?
    let photoID : String
    let farm : Int
    let server : String
    let secret : String
    
    init(photoID:String,farm:Int, server:String, secret:String) {
        self.photoID = photoID
        self.farm = farm
        self.server = server
        self.secret = secret
  }

    func flickrImageURL(_ size:String = "m") -> URL? {
        if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg") {
            return url
        }
        return nil
    }
    
    func loadLargeImage(_ completion: @escaping (_ flickrPhoto:PhotoModel, _ error: NSError?) -> Void) {
        guard let loadURL = flickrImageURL("b") else {
            DispatchQueue.main.async {
                completion(self, nil)
            }
            return
        }
        
        let loadRequest = URLRequest(url:loadURL)
        
        URLSession.shared.dataTask(with: loadRequest, completionHandler: { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(self, error as NSError?)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(self, nil)
                }
                return
            }
            
            let returnedImage = UIImage(data: data)
            self.largeImage = returnedImage
            DispatchQueue.main.async {
                completion(self, nil)
            }
        }).resume()
    }
    
   
    
}


