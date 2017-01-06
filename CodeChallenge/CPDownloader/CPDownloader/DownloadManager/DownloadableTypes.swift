//
//  DownloadableTypes.swift
//  CPDownloader
//
//  Created by Jose Torres on 5/1/17.
//  Copyright © 2017 coderpug. All rights reserved.
//

import Foundation

/// Protocol for object types CPDownloader support
protocol CPDownloadable {
    
    /// Function performed in the main() function of an Operation.
    ///
    /// - Parameters:
    ///   - operation: Operation object of current process.
    ///   - url: String url.
    static func downloadResourceOperation<T>(operation: DownloadOperation<T>, url: String)
}

//  MARK: +UIImage

extension UIImage : CPDownloadable {

    static func downloadResourceOperation<UIImage>(operation: DownloadOperation<UIImage>, url: String) {
        
        DownloadDataManager.downloadImage(url: url) { result in
            
            if operation.isCancelled == true {
                
                operation.state = .finished
            } else {
                
                switch result {
                    
                case .Failure(_):
                    
                    operation.state = .finished
                    break
                    
                case let .Success(image):
                    
                    operation.object = image as? UIImage
                    operation.state = .finished
                    break
                }
            }
        }
    }
}

//  MARK: +Dictionary

extension Dictionary : CPDownloadable {
    
    static func downloadResourceOperation<Dictionary>(operation: DownloadOperation<Dictionary>, url: String) {
        
        DownloadDataManager.downloadJSON(url: url) { result in
            
            if operation.isCancelled == true {
                
                operation.state = .finished
            } else {
                
                switch result {
                    
                case .Failure(_):
                    
                    operation.state = .finished
                    break
                    
                case let .Success(json):
                    
                    operation.object = json as? Dictionary
                    operation.state = .finished
                    break
                }
            }
        }
    }
}
