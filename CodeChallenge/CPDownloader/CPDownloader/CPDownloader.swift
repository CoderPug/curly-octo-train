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
    
    fileprivate let cache = NSCache<NSString, UIImage>()
    
    /// Function for getting Image from URL
    ///
    /// - Parameters:
    ///   - url: String url
    ///   - handler: Handler block
    public func getImage(url: String, handler: @escaping getImageHandler) {
        
        let operation = DownloadImageOperation()
        operation.url = url
        
        if let cachedImage = cache.object(forKey: url as NSString) {
            
            print("showing cached image")
            handler(.Success(cachedImage))
            return
        }
        
        if var arrayHandlers = self.downloadOperations.downloadsInProgressHandlers[url] {
            
            arrayHandlers.append(handler)
            self.downloadOperations.downloadsInProgressHandlers[url] = arrayHandlers
        } else {
            
            self.downloadOperations.downloadsInProgressHandlers[url] = [handler]
            
            operation.completionBlock = { [weak self] in
                
                if operation.isCancelled {
                    
                    handler(.Failure(CPDownloaderError.operationCanceled))
                    return
                }
                
                _ = self?.downloadOperations.downloadsInProgress.removeValue(forKey: url)
                
                guard let arrayHandlers = self?.downloadOperations.downloadsInProgressHandlers[url],
                    let image = operation.image else {
                    
                    handler(.Failure(CPDownloaderError.couldNotObtainImage))
                    return
                }
                
                self?.cache.setObject(image, forKey: url as NSString)
                
                for handler in arrayHandlers {
                    
                    handler(.Success(image))
                }
            }
            
            downloadOperations.downloadsInProgress[url] = operation
            downloadOperations.downloadQueue.addOperation(operation)
        }
        
    }
}

