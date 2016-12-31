//
//  OtherTypesTableViewController.swift
//  CodeChallenge
//
//  Created by Jose Torres on 12/31/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import UIKit

class OtherTypesTableViewController: UITableViewController {

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
    }
}
