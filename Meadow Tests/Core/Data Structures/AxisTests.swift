//
//  AxisTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

class AxisTests: XCTestCase {
    
    func testAxisUnitY() {
        
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
