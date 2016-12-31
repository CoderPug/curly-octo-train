//
//  InstagramDetailTableViewCell.swift
//  CodeChallenge
//
//  Created by Jose Torres on 12/31/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import UIKit

struct InstagramDetailTableViewCellConstants {
    
    static let nibName = "InstagramDetailTableViewCell"
    static let cellIdentifier = "InstagramDetailTableViewCell"
}

class InstagramDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        custommize()
    }
    
    override func prepareForReuse() {
        
    }
    
    func custommize() {
        
    }

}
