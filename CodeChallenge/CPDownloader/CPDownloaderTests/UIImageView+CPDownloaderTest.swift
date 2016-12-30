//
//  UIImageView+CPDownloaderTest.swift
//  CPDownloader
//
//  Created by Jose Torres on 12/30/16.
//  Copyright © 2016 coderpug. All rights reserved.
//

import XCTest
@testable import CPDownloader

class UIImageView_CPDownloaderTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItDownloadsImageWithCorrectImageURL() {
        
        //  Given
        let url = "https://ifsstech.files.wordpress.com/2008/10/169.jpg"
        
        let completionExpectation = expectation(description: "UIImageView performs async download task to get image")
        
        let imageView = UIImageView()
        
        //  When
        imageView.getImage(url: url)
        
        keyValueObservingExpectation(for: imageView,
                                     keyPath: "image") { (_, _) -> Bool in
                                        
                                        //  Then
                                        XCTAssertNotNil(imageView.image)
                                        completionExpectation.fulfill()
                                        return true
        }
        
        waitForExpectations(timeout: 5.0) { error in
            
            if let error = error {
                XCTFail("testThatItDownloadsImageWithCorrectImageURL error: \(error)")
            }
        }
    }
    
}
