//
//  DownloadManager.swift
//  CPDownloader
//
//  Created by Jose Torres on 12/29/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import Foundation

/// Generic Result<T> for handling responses
///
/// - Failure: In case response is a failure. It contains the descriptive failure error.
/// - Success: In case response is a success. It contains <T>.
enum Result<T> {
    case Failure(Error)
    case Success(T)
}

/// SupportedTypes for DownloadManager
///
/// - unknown: unsupported response data.
/// - image: image response data.
/// - json: json response.
enum SupportedTypes {
    case unknown
    case image
    case json
}

/// Enum of possible DownloadManagerError-s
///
/// - unknown: unhandled error.
/// - requestFailed: request failed.
/// - couldNotReadResponse: request succeeded but response data can not be read.
enum DownloadManagerError: Error {
    case unknown
    case wrongURL
    case requestFailed(Error?)
    case couldNotReadResponse(Error?)
}

struct DownloadDataManager {
    
    fileprivate typealias downloadDataManagerResponseType = (data: Data?, type: SupportedTypes)
    fileprivate typealias downloadDataManagerHadler = (Result<downloadDataManagerResponseType>) -> Swift.Void
    
    fileprivate static let kDownloadDataManagerHeaderContentType = "Content-Type"
    fileprivate static let kDownloadDataManagerImageContentType = "image/"
    fileprivate static let kDownloadDataManagerJSONContentType = "application/json"
    
    /// Function responsible for performing request for data
    ///
    /// - Parameters:
    ///   - url: String url
    ///   - handler: Handler for response
    fileprivate static func download(url: String, handler: @escaping downloadDataManagerHadler) {
        
        guard let url = URL(string: url) else {
            
            handler(.Failure(DownloadManagerError.wrongURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url,
                                              completionHandler: { (data, response, error) -> Void in
                                                
                                                guard error == nil, let data = data else {
                                                    
                                                    if error != nil {
                                                        dump(error)
                                                        handler(.Failure(DownloadManagerError.requestFailed(error)))
                                                    }
                                                    return
                                                }
                                                
                                                guard let response = response as? HTTPURLResponse,
                                                    let type = response.allHeaderFields[kDownloadDataManagerHeaderContentType] as? String else {
                                                        
                                                        handler(.Failure(DownloadManagerError.couldNotReadResponse(error)))
                                                        return
                                                }
                                                
                                                interprete(data, with: type, handler: handler)
        })
        
        task.resume()
    }
    
    /// Function resposible for interpreting plain response data.
    ///
    /// - Parameters:
    ///   - data: Data of response's data
    ///   - type: String containing response's Content-Type
    ///   - handler: Handler for response
    fileprivate static func interprete(_ data: Data?, with type: String, handler: downloadDataManagerHadler) {
        
        switch type {

        case _ where type.contains(kDownloadDataManagerImageContentType):
            handler(.Success((data, .image)))
            break
            
        case _ where type.contains(kDownloadDataManagerJSONContentType):
            handler(.Success((data, .json)))
            
        default:
            handler(.Success((data, .unknown)))
            break
        }
    }
}
