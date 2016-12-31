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
        
        labelAuthor.text = ""
        labelDate.text = ""
        labelDescription.text = ""
    }
    
    func custommize() {
        
        backgroundColor = UIColor.clear
        
        if #available(iOS 8.2, *) {
            labelAuthor.font = Appearance.Fonts.h4
            labelDate.font = Appearance.Fonts.text
            labelDescription.font = Appearance.Fonts.text
        }
        
        labelAuthor.textColor = Appearance.Colors.third
        labelDate.textColor = Appearance.Colors.third
        labelDescription.textColor = Appearance.Colors.third
        
        labelAuthor.text = ""
        labelDate.text = ""
        labelDescription.text = ""
    }
    
    func load(data: [String: AnyObject]) {
        
        guard let author = (data as NSDictionary).value(forKeyPath: "caption.from.full_name") as? String,
            let description = (data as NSDictionary).value(forKeyPath: "caption.text") as? String,
            let date = (data as NSDictionary).value(forKeyPath: "caption.created_time") as? String else {
            
            return
        }
        
        labelAuthor.text = author
        labelDate.text = date
        labelDescription.text = description
    }
    
    func load(title: String, detail: String) {
        
        labelAuthor.text = title
        labelDate.text = ""
        labelDescription.text = detail
    }

}
