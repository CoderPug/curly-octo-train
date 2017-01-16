//
//  Extensions+CPDownloader.swift
//  CPDownloader
//
//  Created by Jose Torres on 12/29/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public func getImage(url: String) {
        
        CPDownloader.sharedInstance.getImage(url: url) { [weak self] result in
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                switch result {
    
                case let .Failure(error):
                    
                    dump(error)
                    break
                    
                case let .Success(image):
                    
                    guard let image = image as? UIImage else {
                        return
                    }
                    
                    self?.image = image
                    
                    break
                }
            })
        }
    }
    
    public func cancel(url:String) {
    
        CPDownloader.sharedInstance.cancel(url: url)
    }
    
}

extension UILabel {
    
    public func getJSON(url: String) {
        
        CPDownloader.sharedInstance.getJSON(url: url) { [weak self] result in
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                switch result {
                    
                case let .Failure(error):
                    
                    dump(error)
                    break
                    
                case let .Success(json):
                    
                    guard let json = json as? [String: AnyObject] else {
                        return
                    }
                    
                    let trimmedString = json.description.replacingOccurrences(of: " ", with: "")
                    self?.text = trimmedString
                    break
                }
            })
        }
    }
}
