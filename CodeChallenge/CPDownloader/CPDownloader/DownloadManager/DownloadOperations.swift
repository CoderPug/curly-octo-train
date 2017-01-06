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

class DownloadOperation<T: CPDownloadable>: Operation {
    
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
            
            T.downloadResourceOperation(operation: self, url: url)            
        }
    }
    
}
