//
//  InstagramImagesDetailTableViewController.swift
//  CodeChallenge
//
//  Created by Jose Torres on 12/30/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import UIKit
import CPDownloader

class InstagramImagesDetailTableViewController: UITableViewController {
    
    var data = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureView() {
        
        title = NSLocalizedString("INSTAGRAMDETAILVC_TITLE", comment: "INSTAGRAMDETAILVC_TITLE")
        
        tableView.backgroundColor = Appearance.Colors.empty
        
        tableView.register(UINib.init(nibName: InstagramTableViewCellConstants.nibName,
                                      bundle: Bundle.main),
                           forCellReuseIdentifier: InstagramTableViewCellConstants.cellIdentifier)
        tableView.register(UINib.init(nibName: InstagramDetailTableViewCellConstants.nibName,
                                      bundle: Bundle.main),
                           forCellReuseIdentifier: InstagramDetailTableViewCellConstants.cellIdentifier)
    }
}

extension InstagramImagesDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InstagramTableViewCellConstants.cellIdentifier) as? InstagramTableViewCell else {
                
                return UITableViewCell()
            }
            
            cell.backgroundColor = UIColor.clear
            cell.load(url: "")
            
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InstagramDetailTableViewCellConstants.cellIdentifier) as? InstagramDetailTableViewCell else {
                
                return UITableViewCell()
            }
            
            cell.backgroundColor = UIColor.clear
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
}
