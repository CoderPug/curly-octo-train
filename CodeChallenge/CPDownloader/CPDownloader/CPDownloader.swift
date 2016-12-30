//
//  CPDownloader.swift
//  CPDownloader
//
//  Created by Jose Torres on 12/29/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import Foundation

/// Enum of possible CPDownloaderError-s
///
/// - unknown: unhandled error.
/// - operationCanceled: operation was canceled.
/// - couldNotObtainImage: request succeeded but response data can not be converted to image.
enum CPDownloaderError: Error {
    case unknown
    case operationCanceled
    case couldNotObtainImage
}

/// CPDownloader handles data download.
public class CPDownloader {
    
    public typealias getImageHandler = (Result<UIImage>) -> Swift.Void
    
    public static let sharedInstance = CPDownloader()
    
    fileprivate let downloadOperations = DownloadOperations()
    
    /// Function for getting Image from URL
    ///
    /// - Parameters:
    ///   - url: String url
    ///   - handler: Handler block
    public func getImage(url: String, handler: @escaping getImageHandler) {
        
        let operation = DownloadImageOperation()
        operation.url = url
        
        operation.completionBlock = { [weak self] in
            
            if operation.isCancelled {
                
                handler(.Failure(CPDownloaderError.operationCanceled))
                return
            }
            
            _ = self?.downloadOperations.downloadsInProgress.removeValue(forKey: url)
            
            guard let image = operation.image else {
                
                handler(.Failure(CPDownloaderError.couldNotObtainImage))
                return
            }
            
            handler(.Success(image))
        }
        
        downloadOperations.downloadsInProgress[url] = operation
        downloadOperations.downloadQueue.addOperation(operation)
    }
}

