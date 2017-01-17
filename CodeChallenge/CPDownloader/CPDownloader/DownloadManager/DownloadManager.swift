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
public enum Result<T> {
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
    case file
}

/// Enum of possible DownloadManagerError-s
///
/// - unknown: unhandled error.
/// - requestFailed: request failed.
/// - couldNotReadResponse: request succeeded but response data can not be read.
/// - couldNotObtainImage: request succeeded but response data can not be converted to image.
/// - couldNotObtainJSON: request succeeded but response data can not be converted to json.
enum DownloadManagerError: Error {
    case unknown
    case custom(String?)
    case wrongURL
    case requestFailed(Error?)
    case couldNotReadResponse(Error?)
    case couldNotObtainImage
    case couldNotObtainJSON
    case couldNotObtainFile
}

//  MARK: DownloadDataManager

internal struct DownloadDataManager {
    
    fileprivate typealias downloadDataManagerResponseType = (data: Data?, type: SupportedTypes)
    fileprivate typealias downloadDataManagerHandler = (Result<downloadDataManagerResponseType>) -> Swift.Void
    
    fileprivate static let kDownloadDataManagerHeaderContentType = "Content-Type"
    fileprivate static let kDownloadDataManagerImageContentType = "image/"
    fileprivate static let kDownloadDataManagerJSONContentType = "application/json"
    
    /// Function responsible for performing request for data
    ///
    /// - Parameters:
    ///   - url: String url
    ///   - handler: Handler for response
    fileprivate static func download(url: String, handler: @escaping downloadDataManagerHandler) {
        
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
    fileprivate static func interprete(_ data: Data?, with type: String, handler: downloadDataManagerHandler) {
        
        switch type {

        case _ where type.contains(kDownloadDataManagerImageContentType):
            
            handler(.Success((data, .image)))
            break
            
        case _ where type.contains(kDownloadDataManagerJSONContentType):
            
            handler(.Success((data, .json)))
            break

        default:
            
            handler(.Success((data, .file)))
            break
        }
    }
}

//  MARK: DownloadDataManager+UIImage

extension DownloadDataManager {

    internal typealias downloadDataManagerImageHandler = (Result<UIImage>) -> Swift.Void
    
    internal static func downloadImage(url: String, handler: @escaping downloadDataManagerImageHandler) {
    
        download(url: url) { result in
        
            switch result {
                
            case let .Failure(error):
                
                handler(.Failure(error))
                break
                
            case let .Success(data, type):
                
                guard type == .image,
                    let data = data,
                    let image = UIImage(data: data) else {
                        
                        handler(.Failure(DownloadManagerError.couldNotObtainImage))
                        return
                }
                handler(.Success(image))
                break
            }
        }
    }
    
}

//  MARK: DownloadDataManager+JSON

extension DownloadDataManager {
    
    internal typealias downloadDataManagerJSONHandler = (Result<[String: AnyObject]>) -> Swift.Void
    
    internal static func downloadJSON(url: String, handler: @escaping downloadDataManagerJSONHandler) {
        
        download(url: url) { result in
            
            switch result {
                
            case let .Failure(error):
                
                handler(.Failure(error))
                break
                
            case let .Success(data, type):
                
                guard type == .json,
                    let data = data,
                    let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject],
                    let json = result else {
                        
                        handler(.Failure(DownloadManagerError.couldNotObtainJSON))
                        return
                }
                
                handler(.Success(json))
                break
            }
        }
    }
    
}

//  MARK: DownloadDataManager+File

extension DownloadDataManager {
    
    internal typealias downloadDataManagerFileHandler = (Result<URL>) -> Swift.Void
    
    internal static func downloadFile(url: String, handler: @escaping downloadDataManagerFileHandler) {
        
        download(url: url) { result in
            
            switch result {
                
            case let .Failure(error):
                
                handler(.Failure(error))
                break
                
            case let .Success(data, type):
                
                guard type == .file,
                    let data = data else {
                        
                        handler(.Failure(DownloadManagerError.couldNotObtainFile))
                        return
                }
                
                let fileManager = FileManager.default
                let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let tempURL = URL(string: url)
                let finalPath = directoryURL.appendingPathComponent(tempURL?.stringForDirectory() ?? "")
                
                do {
                    
                    try data.write(to: finalPath)
                    
                } catch {
                    
                    handler(.Failure(DownloadManagerError.custom("Could not save file data.")))
                    
                }
                
                handler(.Success(finalPath))
                break
            }
        }
    }
    
}
