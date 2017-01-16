//
//  Extensions.swift
//  CPDownloader
//
//  Created by Jose Torres on 16/1/17.
//  Copyright © 2017 coderpug. All rights reserved.
//

import Foundation

extension URL {
    
    func stringForDirectory() -> String {
        
        let relativePath = self.relativePath
        let result = relativePath.replacingOccurrences(of: "/", with: "-")
        return result
    }
    
}
