//
//  InstagramTableViewCell.swift
//  CodeChallenge
//
//  Created by Jose Torres on 12/30/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import UIKit

struct InstagramTableViewCellConstants {
    
    static let nibName = "InstagramTableViewCell"
    static let cellIdentifier = "InstagramTableViewCell"
}

class InstagramTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageMedia: UIImageView!
    var imageURL: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        custommize()
    }
    
    override func prepareForReuse() {
        
        imageMedia.image = nil
        
        if let imageURL = imageURL {
            imageMedia.cancel(url: imageURL)
        }
    }
    
    func custommize() {
        
    }
    
    func load(url: String) {

        imageURL = url
        imageMedia.getImage(url: url)
    }
    
    func cancel(url: String) {
        
        imageMedia.cancel(url: url)
    }
}
