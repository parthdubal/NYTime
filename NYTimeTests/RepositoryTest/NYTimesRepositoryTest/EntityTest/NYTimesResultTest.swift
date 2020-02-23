//
//  NYTimesResultTest.swift
//  NYTimeTests
//
//  Created by Parth Dubal on 23/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import Foundation

@testable import NYTime
import XCTest

class NYTimesResultTest: XCTestCase {
    
    var result: NYTimesResult?
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        result = Bundle.helperBundle.mockNews.objectFromPath(object: NYTimesResult.self)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        result = nil
    }
    
    func testObject() {
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.result.count, 10)
        
        let description = "Federal prosecutors say a Russian government official recruited a Mexican citizen to photograph a U.S. government source’s vehicle."
        let headline = "Mexican Citizen Is Accused of Spying for Russians in the U.S."
        let imageUrl = "images/2020/02/19/multimedia/19xp-spy/merlin_168923481_b9f549a6-0620-404f-b136-5f4c91943247-articleLarge.jpg"
        let webUrl = "https://www.nytimes.com/2020/02/19/us/hector-alejandro-cabrera-fuentes-spying-russia.html"
        
        let firstObject = result?.result.first
        XCTAssertNotNil(firstObject)
        XCTAssertEqual(firstObject?.description, description)
        XCTAssertEqual(firstObject?.headline, headline)
        XCTAssertEqual(firstObject?.webURL, webUrl)
        XCTAssertEqual(firstObject?.imageURL, imageUrl)
    }
}
