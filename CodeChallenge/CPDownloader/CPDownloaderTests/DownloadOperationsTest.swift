//
//  DownloadOperationsTest.swift
//  CPDownloader
//
//  Created by Jose Torres on 12/29/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import XCTest
@testable import CPDownloader

class DownloadOperationsTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItProperlyInitialize() {
        
        //  Given
        //  When
        let operations = DownloadOperations()
        
        //  Then
        XCTAssertNotNil(operations.downloadsInProgress)
        XCTAssertNotNil(operations.downloadQueue)
    }
    
    func testThatItDownloadImageOperationIsAsynchronous() {
        
        //  Given
        //  When
        let operation = DownloadOperation<UIImage>()
        XCTAssertTrue(operation.isAsynchronous)
    }

    func testThatItDownloadsImageWithCorrectImageURL() {
        
        //  Given
        let url = "https://ifsstech.files.wordpress.com/2008/10/169.jpg"

        let operationQueue = OperationQueue()
        
        let completionExpectation = expectation(description: "DownloadImageOperation performs async download task with correct URL")
        
        //  When
        let operation = DownloadOperation<UIImage>()
        operation.url = url
        
        operation.completionBlock = {
            
            //  Then
            XCTAssertNotNil(operation.object, "Image nil")
            
            completionExpectation.fulfill()
        }
        
        operationQueue.addOperation(operation)
        
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("testThatItDownloadsImageWithCorrectImageURL error: \(error)")
            }
        }
    }
    
    func testThatItGetsErrorWithoutURL() {
        
        //  Given
        let operationQueue = OperationQueue()
        
        let completionExpectation = expectation(description: "DownloadImageOperation performs async download task withour URL")
        
        //  When
        let operation = DownloadOperation<UIImage>()
        
        operation.completionBlock = {
            
            //  Then
            XCTAssertNil(operation.object, "Image not nil")
            
            completionExpectation.fulfill()
        }
        
        operationQueue.addOperation(operation)
        
        waitForExpectations(timeout: 5.0) { error in
            if let error = error {
                XCTFail("testThatItGetsErrorWithoutURL error: \(error)")
            }
        }
    }
}
