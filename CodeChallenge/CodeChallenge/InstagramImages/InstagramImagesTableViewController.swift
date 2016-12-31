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
    var requestInProcess: Bool = false
    var lastResponse: [String: AnyObject]?
    let numberOfElementsBeforeReloading = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        let accessToken = "2253601763.1677ed0.d35015431cb744cd8e643bbdc3131c6d"
        let url = "https://api.instagram.com/v1/users/self/media/recent/?access_token=\(accessToken)"
        requestInstagramAPI(url: url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureView() {
        
        tableView.register(UINib.init(nibName: InstagramTableViewCellConstants.nibName,
                                      bundle: Bundle.main),
                           forCellReuseIdentifier: InstagramTableViewCellConstants.cellIdentifier)
    }
    
    /// Adding test function for InstagramAPI
    func requestInstagramAPI(url: String) {
        
        requestInProcess = true
        
        let url = URL(string: url)!
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            self?.requestInProcess = false
            
            guard let data = data,
                let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject],
                let list = dictionary?["data"] as? [AnyObject] else {
                    
                return
            }
            
            self?.lastResponse = dictionary
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                if let elements = self?.arrayElements {
                    
                    self?.arrayElements = elements + list
                } else {
                    
                    self?.arrayElements = list
                }
                
                self?.tableView.reloadData()
            })
        }

        task.resume()
    }
}

extension InstagramImagesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayElements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InstagramTableViewCellConstants.cellIdentifier) as? InstagramTableViewCell,
            let item = arrayElements[indexPath.row] as? NSDictionary,
            let url = item.value(forKeyPath: "images.standard_resolution.url") as? String else {
            
            return UITableViewCell()
        }
        
        cell.load(url: url)
        
        if requestInProcess == false && indexPath.row >= (arrayElements.count - numberOfElementsBeforeReloading) {
         
            guard let pagination = lastResponse?["pagination"] as? NSDictionary,
                let nextUrl = pagination["next_url"] as? String else {

                return cell
            }
            
            requestInstagramAPI(url: nextUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? InstagramTableViewCell,
            let item = arrayElements[indexPath.row] as? NSDictionary,
            let url = item.value(forKeyPath: "images.standard_resolution.url") as? String else {
            
            return
        }
        
        cell.cancel(url: url)
    }
    
}
