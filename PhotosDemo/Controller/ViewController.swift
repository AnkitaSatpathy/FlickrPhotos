//
//  ViewController.swift
//  PhotosDemo
//
//  Created by Ankita Satpathy on 04/12/17.
//  Copyright © 2017 Ankita Satpathy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableview: UITableView!
    var searches = [PhotoResults]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
    }

    

}

extension  ViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return searches.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searches[section].searchTerm
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        //let photo = searches[indexPath.row]
        cell.imageview.image = searches[indexPath.section].searchResults[indexPath.row].thumbnail
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "photoSegue", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoSegue"{
            let controller = (segue.destination as!  UINavigationController).topViewController as! PhotoDetailViewController
            let selectedIndex = tableview.indexPathForSelectedRow
            controller.thumbnail = searches[(selectedIndex?.section)!].searchResults[(selectedIndex?.row)!].thumbnail
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        APIHandler().searchFlickrWithTerm(textField.text!) { (results, error) in
            activityIndicator.removeFromSuperview()
            if let error = error {
                print("Error searching : \(error)")
                return
            }
            
            if let results = results{
               print("found \(results.searchResults.count) matching, \(results.searchTerm)")
                self.searches.insert(results, at: 0)
                self.tableview.reloadData()
            }
        }
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}
