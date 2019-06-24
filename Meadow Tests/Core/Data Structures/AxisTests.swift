//
//  AxisTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

class AxisTests: XCTestCase {
    
    func testAxisUnitYFloat() {
        
        let expect = expectation(description: "Converting from Axis coordinates float y value to yeilds correct y value as an integer")
        
        XCTAssertEqual(Axis.Y(y: 0.0), 0)
        XCTAssertEqual(Axis.Y(y: 0.25), 1)
        XCTAssertEqual(Axis.Y(y: -0.25), -1)
        XCTAssertEqual(Axis.Y(y: 1.25), 5)
        XCTAssertEqual(Axis.Y(y: -1.25), -5)
        XCTAssertEqual(Axis.Y(y: 2.5), 10)
        XCTAssertEqual(Axis.Y(y: -2.5), -10)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testAxisUnitYInt() {
        
        let expect = expectation(description: "Converting from integer y value to Axis coordinates yeilds correct y value as a float")
        
        XCTAssertEqual(Axis.Y(y: 0), 0.0)
        XCTAssertEqual(Axis.Y(y: 1), 0.25)
        XCTAssertEqual(Axis.Y(y: -1), -0.25)
        XCTAssertEqual(Axis.Y(y: 5), 1.25)
        XCTAssertEqual(Axis.Y(y: -5), -1.25)
        XCTAssertEqual(Axis.Y(y: 10), 2.5)
        XCTAssertEqual(Axis.Y(y: -10), -2.5)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
