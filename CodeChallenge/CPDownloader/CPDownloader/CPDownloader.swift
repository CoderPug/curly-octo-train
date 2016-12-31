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
    
    fileprivate let downloadCache = DownloadCache()
    
    /// Function for getting Image from URL
    ///
    /// - Parameters:
    ///   - url: String url
    ///   - handler: Handler block
    public func getImage(url: String, handler: @escaping getImageHandler) {
        
        let operation = DownloadImageOperation()
        operation.url = url
        
        if let cachedObject = DownloadCache.sharedInstance.getObject(key: url) {
            
            if let cachedImage = cachedObject as? UIImage {
                print("showing cached image")
                handler(.Success(cachedImage))
            }
            return
        }
        
        if var arrayHandlers = downloadOperations.downloadsInProgressHandlers[url] {
            
            arrayHandlers.append(handler)
            downloadOperations.downloadsInProgressHandlers[url] = arrayHandlers
        } else {
            
            downloadOperations.downloadsInProgressHandlers[url] = [handler]
            
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
                
                self?.downloadCache.setObject(object: image, key: url)
                
                for handler in arrayHandlers {
                    
                    handler(.Success(image))
                }
                
                self?.downloadOperations.downloadsInProgressHandlers[url] = nil
            }
            
            downloadOperations.downloadsInProgress[url] = operation
            downloadOperations.downloadQueue.addOperation(operation)
        }
        
    }
    
    public func cancel(url: String){
        
        downloadOperations.downloadsInProgressHandlers[url] = nil

        if let operation = downloadOperations.downloadsInProgress[url] {
            operation.cancel()
            _ = downloadOperations.downloadsInProgress.removeValue(forKey: url)
        }
        
    }
}

