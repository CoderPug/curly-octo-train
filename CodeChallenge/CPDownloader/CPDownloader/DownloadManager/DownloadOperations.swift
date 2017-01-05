//
//  DownloadOperations.swift
//  CPDownloader
//
//  Created by Jose Torres on 12/29/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import Foundation

enum State: String {
    
    case ready, executing, finished
    var keyPath: String {
        return "is" + self.rawValue.capitalized
    }
}

//  DownloadOperations

class DownloadOperations {
    
    var downloadsInProgressHandlers = [String: Array<(Result<AnyObject>)->()>]()
    var downloadsInProgress = [String: Operation]()
    var downloadQueue: OperationQueue = {
        
        var queue = OperationQueue()
        queue.name = "DownloadOperations.downloadQueue"
        return queue
    }()
    
}

//  DownloadImageOperation

class DownloadOperation<T>: Operation {
    
    var url: String?
    var object: T?
    
    var state = State.ready {
        
        willSet {
            
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        
        didSet {
            
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        
        return true
    }
    
    override var isExecuting: Bool {
        
        return state == .executing
    }
    
    override var isFinished: Bool {
        
        return state == .finished
    }
    
    override func start() {
        
        if isCancelled {
            
            state = .finished
        } else {
            
            state = .ready
            main()
        }
    }
    
    override func main() {
        
        if isCancelled {
            
            state = .finished
        } else {
            
            state = .executing
            
            guard let url = url else {
                
                state = .finished
                return
            }
            
            if T.self is UIImage.Type {
                
                DownloadDataManager.downloadImage(url: url) { [weak self] result in
                    
                    if self?.isCancelled == true {
                        
                        self?.state = .finished
                    } else {
                        
                        switch result {
                            
                        case .Failure(_):
                            
                            self?.state = .finished
                            break
                            
                        case let .Success(image):
                            
                            self?.object = image as? T
                            self?.state = .finished
                            break
                        }
                    }
                }
                
            } else if T.self is [String: AnyObject].Type {
                
                DownloadDataManager.downloadJSON(url: url) { [weak self] result in
                    
                    if self?.isCancelled == true {
                        
                        self?.state = .finished
                    } else {
                        
                        switch result {
                            
                        case .Failure(_):
                            
                            self?.state = .finished
                            break
                            
                        case let .Success(json):
                            
                            self?.object = json as? T
                            self?.state = .finished
                            break
                        }
                    }
                }
                
            } else {
                
            }
            
        }
    }
}
