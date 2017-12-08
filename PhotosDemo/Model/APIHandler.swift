//
//  APIHandler.swift
//  PhotosDemo
//
//  Created by Ankita Satpathy on 04/12/17.
//  Copyright © 2017 Ankita Satpathy. All rights reserved.
//

import Foundation
import  UIKit

let apiKey = "4e77e0dd6dbe915b5617eb07c0d48844"

class APIHandler {
    
     let processingQueue = OperationQueue()
    
    func searchFlickrWithTerm(_ searchTerm: String, completion: @escaping (_ results: PhotoResults?,_ error: NSError?) -> Void) {
        
        guard let searchUrl = flickrSearchURLForSearchTerm(searchTerm) else{
            let error = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
            completion(nil, error)
            return
        }
        let searchRequest = URLRequest(url: searchUrl)
        URLSession.shared.dataTask(with: searchRequest) { (data, response, error) in
            if let _ = error {
                let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                OperationQueue.main.addOperation({
                    completion(nil, APIError)
                })
                return
            }
            
            guard let _ = response as? HTTPURLResponse,
                let data = data else {
                    let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    return
            }
            
            do {
                guard let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String:AnyObject],
                    let stat = jsonDictionary["stat"] as? String else{
                        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                        OperationQueue.main.addOperation({
                            completion(nil, APIError)
                        })
                        return
                }
                switch (stat){
                case "ok":
                    print("OK")
                case "fail":
                    if let message = jsonDictionary["message"]{
                        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:message])
                        OperationQueue.main.addOperation({
                            completion(nil, APIError)
                        })
                    }
                    let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: nil)
                    
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    
                    return
                default:
                    let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    return
                }
                guard let photos = jsonDictionary["photos"] as? [String:AnyObject], let photo = photos["photo"] as? [[String:AnyObject]] else {
                    let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    return
                }
                var photoModels = [PhotoModel]()
                for eachPhoto in photo {
                    guard let photoID = eachPhoto["id"] as? String,
                          let farm = eachPhoto["farm"] as? Int,
                          let server = eachPhoto["server"] as? String,
                        let secret = eachPhoto["secret"] as? String else {
                            break
                    }
                    
                    let photoModel = PhotoModel(photoID: photoID, farm: farm, server: server, secret: secret)
                    guard let url = photoModel.flickrImageURL(), let imageData =  try? Data(contentsOf: url as URL) else {
                        break
                    }
                    
                    if let image = UIImage(data: imageData) {
                        photoModel.thumbnail = image
                        photoModels.append(photoModel)
                    }
                }
                OperationQueue.main.addOperation({
                    completion(PhotoResults(searchTerm: searchTerm, searchResults: photoModels), nil)
                })
                
            } catch {
                completion(nil, nil)
                return
            }
        }.resume()
    
        
    }
    
    func flickrSearchURLForSearchTerm(_ searchTerm:String) -> URL? {
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            return nil
        }
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1"
        
        guard let url = URL(string:URLString) else {
            return nil
        }
         return url
    }
}

