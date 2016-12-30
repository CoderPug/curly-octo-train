//
//  CPDownloaderTest.swift
//  CPDownloader
//
//  Created by Jose Torres on 12/29/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import XCTest
@testable import CPDownloader

class CPDownloaderTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItDownloadsImageWithCorrectImageURL() {
        
        //  Given
        let url = "https://ifsstech.files.wordpress.com/2008/10/169.jpg"
        
        let completionExpectation = expectation(description: "CPDownloader performs async download task to get image")
        
        //  When
        CPDownloader.sharedInstance.getImage(url: url) { result in
            
            switch result {
                
            case let .Success(image):
                
                //  Then
                XCTAssertNotNil(image)
                XCTAssert(image.isKind(of: UIImage.self))
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
    
    func testThatItGetsErrorWithIncorrectImageURL() {
        
        //  Given
        let url = "https://ifsstech.files.wordpress.com/2008/10/x.jpg"
        
        let completionExpectation = expectation(description: "CPDownloader performs async download task to get image")
        
        //  When
        CPDownloader.sharedInstance.getImage(url: url) { result in
            
            switch result {
                
            case let .Failure(error):
                //  Then
                XCTAssertNotNil(error)
                XCTAssert(error as? CPDownloaderError == CPDownloaderError.couldNotObtainImage)
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
    
    func testThatItGetsErrorWithIncorrectURL() {
        
        //  Given
        let url = "https://ifsstech"
        
        let completionExpectation = expectation(description: "CPDownloader performs async download task to get image")
        
        //  When
        CPDownloader.sharedInstance.getImage(url: url) { result in
            
            switch result {
                
            case let .Failure(error):
                //  Then
                XCTAssertNotNil(error)
                XCTAssert(error as? CPDownloaderError == CPDownloaderError.couldNotObtainImage)
                break
                
            default:
                XCTFail("testThatItGetsErrorWithIncorrectURL-error")
                break
            }
            
            completionExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { error in
            
            if let error = error {
                XCTFail("testThatItGetsErrorWithIncorrectURL error: \(error)")
            }
        }
    }
    
}
