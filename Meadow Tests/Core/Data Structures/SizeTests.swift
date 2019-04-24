//
//  SizeTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 30/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

class SizeTests: XCTestCase {

    func testSizeEquality() {
        
        let expect = expectation(description: "Sizes are considered equal when all width, height and depth components are equal")
        
        let s0 = Size<Int>.zero
        let s1 = Size<Int>.one
        let s2 = Size<Int>.zero
        let s3 = Size<MDWFloat>.zero
        let s4 = Size<MDWFloat>.one
        let s5 = Size<MDWFloat>.zero
        
        XCTAssertEqual(s0, s0)
        XCTAssertEqual(s0, s2)
        XCTAssertNotEqual(s0, s1)
        XCTAssertEqual(s3, s3)
        XCTAssertEqual(s3, s5)
        XCTAssertNotEqual(s3, s4)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
