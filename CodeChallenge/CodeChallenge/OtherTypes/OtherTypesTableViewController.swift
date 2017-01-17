//
//  OtherTypesTableViewController.swift
//  CodeChallenge
//
//  Created by Jose Torres on 12/31/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import UIKit
import QuickLook
import CPDownloader

enum OtherTypes {
    case json
    case image
    case file
}

class OtherTypesTableViewController: UITableViewController {
    
    var previewController = QLPreviewController()
    var currentIndexPath: IndexPath?
    var otherTypeList = [
        ["name" : ".zip", "url" : "https://www.dropbox.com/s/u5kogq6538b959i/Archive2.zip?dl=1", "type": OtherTypes.file ],
        ["name" : ".zip", "url" : "https://www.dropbox.com/s/eqtddw19ndjgmyn/Archive.zip?dl=1", "type": OtherTypes.file ],
        ["name" : ".pdf", "url" : "https://www.dropbox.com/s/eqz3pwu90qwsd9e/boarding_pass.pdf?dl=1", "type": OtherTypes.file ],
        ["name" : ".zip", "url" : "https://www.dropbox.com/s/u5kogq6538b959i/Archive2.zip?dl=1", "type": OtherTypes.file ],
        ["name" : ".zip", "url" : "https://www.dropbox.com/s/eqtddw19ndjgmyn/Archive.zip?dl=1", "type": OtherTypes.file ],
        ["name" : ".txt", "url" : "https://www.dropbox.com/s/0h181iwaefwsdw8/sample.txt?dl=1", "type": OtherTypes.file ],
        ["name" : ".md", "url" : "https://www.dropbox.com/s/vvzbuujjz6l84yq/sample.md?dl=1", "type": OtherTypes.file ],
        ["name" : ".mp3", "url" : "https://www.dropbox.com/s/6e5obcu71tua8gr/sample.mp3?dl=1", "type": OtherTypes.file ],
        ["name" : ".numbers", "url" : "https://www.dropbox.com/s/eke6mx38voaw0yi/sample.numbers?dl=1", "type": OtherTypes.file ],
        ["name" : ".json",
         "url" : "https://api.instagram.com/v1/users/self/media/recent/?access_token=2253601763.1677ed0.d35015431cb744cd8e643bbdc3131c6d",
         "type": OtherTypes.json ],
        ["name" : ".json",
         "url" : "https://api.instagram.com/v1/users/self/media/recent/?access_token=2253601763.1677ed0.d35015431cb744cd8e643bbdc3131c6d",
         "type": OtherTypes.json ],
        ["name" : ".json",
         "url" : "https://api.instagram.com/v1/users/self/media/recent/?access_token=2253601763.1677ed0.d35015431cb744cd8e643bbdc3131c6d",
         "type": OtherTypes.json ],
        ["name" : ".pdf", "url" : "https://www.dropbox.com/s/eqz3pwu90qwsd9e/boarding_pass.pdf?dl=1", "type": OtherTypes.file ],
        ["name" : ".zip", "url" : "https://www.dropbox.com/s/u5kogq6538b959i/Archive2.zip?dl=1", "type": OtherTypes.file ],
        ["name" : ".zip", "url" : "https://www.dropbox.com/s/eqtddw19ndjgmyn/Archive.zip?dl=1", "type": OtherTypes.file ],
        ["name" : ".txt", "url" : "https://www.dropbox.com/s/0h181iwaefwsdw8/sample.txt?dl=1", "type": OtherTypes.file ],
        ["name" : ".zip", "url" : "https://www.dropbox.com/s/eqtddw19ndjgmyn/Archive.zip?dl=1", "type": OtherTypes.file ]
    ]
    
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
        
        previewController.dataSource = self
    }
}

extension OtherTypesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return otherTypeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = otherTypeList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InstagramDetailTableViewCellConstants.cellIdentifier) as? InstagramDetailTableViewCell,
            let title = item["name"] as? String,
            let detail = item["url"] as? String,
            let type = item["type"] as? OtherTypes else {
            
            return UITableViewCell()
        }
        
        if type == .file {
            
            cell.loadFile(title: title, detail: detail)
        } else {
            
            cell.loadJSON(title: title, detail: detail)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = otherTypeList[indexPath.row]
        guard let type = item["type"] as? OtherTypes,
            type == .file else {
            return
        }
        
        currentIndexPath = indexPath
        previewController.currentPreviewItemIndex = 0
        previewController.reloadData()
        
        present(previewController, animated: true, completion: nil)
    }
}

extension OtherTypesTableViewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
        
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        
        guard let indexPath = currentIndexPath,
            let itemURL = otherTypeList[indexPath.row]["url"] as? String,
            let _ = CPDownloader.sharedInstance.getFilePath(for: itemURL) else {
                return 0
        }
        
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        guard let indexPath = currentIndexPath,
            let itemURL = otherTypeList[indexPath.row]["url"] as? String,
            let finalPath = CPDownloader.sharedInstance.getFilePath(for: itemURL) else {
            return NSURL(string: "http://")!
        }
        
        return finalPath as NSURL
    }
}
