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
        
        let s0 = Size.zero
        let s1 = Size.one
        let s2 = Size.zero
        
        XCTAssertEqual(s0, s0)
        XCTAssertEqual(s0, s2)
        XCTAssertNotEqual(s0, s1)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
