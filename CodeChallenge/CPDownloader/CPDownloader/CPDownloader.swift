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
    case couldNotObtainObject
}

/// CPDownloader handles data download.
public class CPDownloader {
    
    public typealias generalHandler = (Result<AnyObject>) -> Swift.Void
    
    public static let sharedInstance = CPDownloader()
    
    fileprivate let downloadOperations = DownloadOperations()
    
    /// Generic function for getting resource from a given URL
    ///
    /// - Parameters:
    ///   - object: Generic parameter type
    ///   - url: String url
    ///   - handler: Handler closure
    fileprivate func getResource<T>(_ object: T.Type,
                                 url: String,
                                 handler: @escaping (Result<AnyObject>) -> Swift.Void) {
        
        let operation = DownloadOperation<T>()
        operation.url = url
        
        if let cachedObject = DownloadCache.sharedInstance.getObject(key: url) {
            
            print("showing cached data")
            handler(.Success(cachedObject))
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
                    let object = operation.object else {
                        
                        handler(.Failure(CPDownloaderError.couldNotObtainObject))
                        return
                }
                
                DownloadCache.sharedInstance.setObject(object: object as AnyObject, key: url)
                
                for handler in arrayHandlers {
                    
                    handler(.Success(object as AnyObject))
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

//  MARK: +UIImage

extension CPDownloader {
    
    /// Function for getting Image from URL
    ///
    /// - Parameters:
    ///   - url: String url
    ///   - handler: Handler closure
    public func getImage(url: String, handler: @escaping generalHandler) {
        
        getResource(UIImage.self, url: url, handler: handler)
    }

}

//  MARK: +JSON

extension CPDownloader {
    
    /// Function for getting JSON data from URL
    ///
    /// - Parameters:
    ///   - url: String url
    ///   - handler: Handler closure
    public func getJSON(url: String, handler: @escaping generalHandler) {
        
        getResource([String: AnyObject].self, url: url, handler: handler)
    }

}
