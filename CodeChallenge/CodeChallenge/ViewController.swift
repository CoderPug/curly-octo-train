//
//  ViewController.swift
//  CodeChallenge
//
//  Created by Santex on 12/29/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import UIKit
import CPDownloader

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let _ = DownloadDataManager.downloadImage(url: "https://ifsstech.files.wordpress.com/2008/10/169.jpg") { result in
            
            dump(result)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

