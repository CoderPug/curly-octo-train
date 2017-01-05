//
//  DownloadCache.swift
//  CPDownloader
//
//  Created by Jose Torres on 12/30/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import Foundation

class DownloadCache {
    
    static let sharedInstance = DownloadCache()
    
    fileprivate let cache = NSCache<NSString, AnyObject>()

    public func setMaximunCost(maximun: Int) {
        
        cache.totalCostLimit = maximun
    }
    
    public func maximunCost() -> Int {
        
        return cache.totalCostLimit
    }
    
    public func setObject(object: AnyObject, key: String) {
        
        let key = key as NSString
        let cost = costForObject(object: object)
        cache.setObject(object, forKey: key, cost: cost)
    }
    
    public func getObject(key: String) -> AnyObject? {
        
        let key = key as NSString
        return cache.object(forKey: key)
    }
    
    //  MARK: -
    
    /// Function for getting estimated memory cost of AnyObject. Currently supports Image.
    ///
    /// - Parameter object: Object to measure.
    /// - Returns: Int value of object cost in memory.
    fileprivate func costForObject(object: AnyObject) -> Int {
        
        guard object is UIImage,
            let object = object as? UIImage else {
                
                return 0
        }
        
        return Int(object.size.height) * Int(object.size.width) * Int(object.scale) * Int(object.scale);
    }
    
}
