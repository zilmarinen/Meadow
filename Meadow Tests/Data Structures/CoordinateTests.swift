//
//  CoordinateTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest
@testable import Meadow

class CoordinateTests: XCTestCase {

    func testCoordinateConstants() {
        
        let expect = expectation(description: "Static values defined by Coordinate are correct")
        
        let zero = Coordinate.Zero
        let one = Coordinate.One
        let up = Coordinate.Up
        let down = Coordinate.Down
        let left = Coordinate.Left
        let right = Coordinate.Right
        let forward = Coordinate.Forward
        let backward = Coordinate.Backward
        
        XCTAssertEqual(0, zero.x)
        XCTAssertEqual(0, zero.y)
        XCTAssertEqual(0, zero.z)
        
        XCTAssertEqual(1, one.x)
        XCTAssertEqual(1, one.y)
        XCTAssertEqual(1, one.z)
        
        XCTAssertEqual(0, up.x)
        XCTAssertEqual(1, up.y)
        XCTAssertEqual(0, up.z)
        
        XCTAssertEqual(0, down.x)
        XCTAssertEqual(-1, down.y)
        XCTAssertEqual(0, down.z)
        
        XCTAssertEqual(-1, left.x)
        XCTAssertEqual(0, left.y)
        XCTAssertEqual(0, left.z)
        
        XCTAssertEqual(1, right.x)
        XCTAssertEqual(0, right.y)
        XCTAssertEqual(0, right.z)
        
        XCTAssertEqual(0, forward.x)
        XCTAssertEqual(0, forward.y)
        XCTAssertEqual(1, forward.z)
        
        XCTAssertEqual(0, backward.x)
        XCTAssertEqual(0, backward.y)
        XCTAssertEqual(-1, backward.z)
    
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testCoordinateAdjacency() {
        
    }
}
