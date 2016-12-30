//
//  UIImageView+CPDownloader.swift
//  CPDownloader
//
//  Created by Jose Torres on 12/29/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public func getImage(url:String) {
        
        CPDownloader.sharedInstance.getImage(url: url) { result in
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                switch result {
    
                case let .Failure(error):
                    
                    dump(error)
                    break
                    
                case let .Success(image):
                    
                    self.image = image
                    break
                }
            })
        }
    }
    
}
