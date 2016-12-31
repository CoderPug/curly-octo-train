//
//  OtherTypesTableViewController.swift
//  CodeChallenge
//
//  Created by Jose Torres on 12/31/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import UIKit

class OtherTypesTableViewController: UITableViewController {

    var otherTypeList = [["name" : ".json",
                          "url" : "https://api.instagram.com/v1/users/self/media/recent/?access_token=2253601763.1677ed0.d35015431cb744cd8e643bbdc3131c6d" ]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureView() {
        
        title = NSLocalizedString("OTHERTYPESLISTVC_TITLE", comment: "OTHERTYPESLISTVC_TITLE")
        
        tableView.backgroundColor = Appearance.Colors.empty
        
        tableView.register(UINib.init(nibName: InstagramDetailTableViewCellConstants.nibName,
                                      bundle: Bundle.main),
                           forCellReuseIdentifier: InstagramDetailTableViewCellConstants.cellIdentifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = InstagramDetailTableViewCellConstants.estimatedHeight
    }
}

extension OtherTypesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return otherTypeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = otherTypeList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InstagramDetailTableViewCellConstants.cellIdentifier) as? InstagramDetailTableViewCell,
            let title = item["name"],
            let detail = item["url"] else {
            
            return UITableViewCell()
        }
        
        cell.load(title: title, detail: detail)
        
        return cell
    }
    
}
