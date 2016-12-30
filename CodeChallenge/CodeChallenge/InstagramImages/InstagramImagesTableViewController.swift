//
//  InstagramImagesTableViewController.swift
//  CodeChallenge
//
//  Created by Jose Torres on 12/29/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import UIKit
import CPDownloader

class InstagramImagesTableViewController: UITableViewController {

    var arrayElements = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestInstagramAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Adding test function for InstagramAPI
    func requestInstagramAPI() {
        
        let accessToken = "2253601763.1677ed0.d35015431cb744cd8e643bbdc3131c6d"
        let url = URL(string:"https://api.instagram.com/v1/users/self/media/recent/?access_token=\(accessToken)")!
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
        
            guard let data = data,
                let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject],
                let list = dictionary?["data"] as? [AnyObject] else {
                return
            }
            
            self?.arrayElements = list

            self?.tableView.reloadData()
        }

        task.resume()
    }
}

extension InstagramImagesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayElements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = arrayElements[indexPath.row] as? NSDictionary
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = item?.value(forKeyPath: "images.standard_resolution.url") as? String
        
        return cell
    }
    
}
