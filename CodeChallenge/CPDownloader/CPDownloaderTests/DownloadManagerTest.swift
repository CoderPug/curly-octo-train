//
//  DownloadManagerTest.swift
//  CPDownloader
//
//  Created by Jose Torres on 12/29/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import XCTest
@testable import CPDownloader

class DownloadManagerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //  MARK: Image support
    
    func testThatItDownloadsImageWithCorrectImageURL() {
        
        //  Given
        let url = "https://ifsstech.files.wordpress.com/2008/10/169.jpg"
        
        let completionExpectation = expectation(description: "DownloadDataManager performs async download task to get image")
        
        //  When
        DownloadDataManager.downloadImage(url: url) { result in
            
            switch result {
                
            case let .Success(data):
                //  Then
                XCTAssertNotNil(data)
                break
                
            default:
                XCTFail("testThatItDownloadsImageWithCorrectImageURL-error")
                break
            }
            
            completionExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { error in
            
            if let error = error {
                XCTFail("testThatItDownloadsImageWithCorrectImageURL error: \(error)")
            }
        }
    }
    
    func testThatItDownloadsImageWithCorrectAnyURL() {
        
        //  Given
        let url = "https://www.dropbox.com/s/eqtddw19ndjgmyn/Archive.zip?dl=0"
        
        let completionExpectation = expectation(description: "DownloadDataManager performs async download task to get image")
        
        //  When
        DownloadDataManager.downloadImage(url: url) { result in
            
            switch result {
                
            case let .Failure(error):
                //  Then
                XCTAssertNotNil(error)
                break
                
            default:
                XCTFail("testThatItDownloadsImageWithCorrectAnyURL-error")
                break
            }
            
            completionExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { error in
            
            if let error = error {
                XCTFail("testThatItDownloadsImageWithCorrectAnyURL error: \(error)")
            }
        }
    }
    
    func testThatItGetsErrorWithIncorrectImageURL() {
        
        //  Given
        let url = "https://ifsstech.files.wordpress.com/2008/10/x.jpg"
        
        let completionExpectation = expectation(description: "DownloadDataManager performs async download task to get image")
        
        //  When
        DownloadDataManager.downloadImage(url: url) { result in
            
            switch result {
                
            case let .Failure(error):
                //  Then
                XCTAssertNotNil(error)
                break
                
            default:
                XCTFail("testThatItGetsErrorWithIncorrectImageURL-error")
                break
            }
            
            completionExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { error in
            
            if let error = error {
                XCTFail("testThatItGetsErrorWithIncorrectImageURL error: \(error)")
            }
        }
    }
    
    func testThatItGetsImageErrorWithIncorrectURL() {
        
        //  Given
        let url = "https://ifsstech"
        
        let completionExpectation = expectation(description: "DownloadDataManager performs async download task to get image")
        
        //  When
        DownloadDataManager.downloadImage(url: url) { result in
            
            switch result {
                
            case let .Failure(error):
                //  Then
                XCTAssertNotNil(error)
                break
                
            default:
                XCTFail("testThatItGetsImageErrorWithIncorrectURL-error")
                break
            }
            
            completionExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { error in
            
            if let error = error {
                XCTFail("testThatItGetsImageErrorWithIncorrectURL error: \(error)")
            }
        }
    }
    
    //  MARK: JSON support
    
    func testThatItDownloadsJSONWithCorrectJSONURL() {
        
        //  Given
        let url = "https://jsonplaceholder.typicode.com/posts/1"
        
        let completionExpectation = expectation(description: "DownloadDataManager performs async download task to get json")
        
        //  When
        DownloadDataManager.downloadJSON(url: url) { result in
            
            switch result {
                
            case let .Success(data):
                //  Then
                XCTAssertNotNil(data)
                break
                
            default:
                XCTFail("testThatItDownloadsJSONWithCorrectJSONURL-error")
                break
            }
            
            completionExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { error in
            
            if let error = error {
                XCTFail("testThatItDownloadsJSONWithCorrectJSONURL error: \(error)")
            }
        }
    }
    
    func testThatItGetsErrorWithIncorrectJSONURL() {
        
        //  Given
        let url = "https://ifsstech.files.wordpress.com/2008/10/x.jpg"
        
        let completionExpectation = expectation(description: "DownloadDataManager performs async download task to get json")
        
        //  When
        DownloadDataManager.downloadJSON(url: url) { result in
            
            switch result {
                
            case let .Failure(error):
                //  Then
                XCTAssertNotNil(error)
                break
                
            default:
                XCTFail("testThatItGetsErrorWithIncorrectJSONURL-error")
                break
            }
            
            completionExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { error in
            
            if let error = error {
                XCTFail("testThatItGetsErrorWithIncorrectJSONURL error: \(error)")
            }
        }
    }
    
    func testThatItGetsJSONErrorWithIncorrectURL() {
        
        //  Given
        let url = "https://ifsstech"
        
        let completionExpectation = expectation(description: "DownloadDataManager performs async download task to get json")
        
        //  When
        DownloadDataManager.downloadJSON(url: url) { result in
            
            switch result {
                
            case let .Failure(error):
                //  Then
                XCTAssertNotNil(error)
                break
                
            default:
                XCTFail("testThatItGetsJSONErrorWithIncorrectURL-error")
                break
            }
            
            completionExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { error in
            
            if let error = error {
                XCTFail("testThatItGetsJSONErrorWithIncorrectURL error: \(error)")
            }
        }
    }

}
