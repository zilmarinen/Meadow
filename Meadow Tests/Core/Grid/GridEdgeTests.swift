//
//  GridEdgeTests.swift
//  Meadow
//
//  Created by Zack Brown on 10/01/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import XCTest

class GridEdgeTests: XCTestCase {

    func testGridEdgeRotation() {
        
        let expect = expectation(description: "Rotating a grid edge correctly returns the rotated grid edge")
        
        XCTAssertEqual(GridEdge.rotate(edge: .north, rotation: .north), .north)
        XCTAssertEqual(GridEdge.rotate(edge: .north, rotation: .east), .east)
        XCTAssertEqual(GridEdge.rotate(edge: .north, rotation: .south), .south)
        XCTAssertEqual(GridEdge.rotate(edge: .north, rotation: .west), .west)
        
        XCTAssertEqual(GridEdge.rotate(edge: .east, rotation: .north), .east)
        XCTAssertEqual(GridEdge.rotate(edge: .east, rotation: .east), .south)
        XCTAssertEqual(GridEdge.rotate(edge: .east, rotation: .south), .west)
        XCTAssertEqual(GridEdge.rotate(edge: .east, rotation: .west), .north)
        
        XCTAssertEqual(GridEdge.rotate(edge: .south, rotation: .north), .south)
        XCTAssertEqual(GridEdge.rotate(edge: .south, rotation: .east), .west)
        XCTAssertEqual(GridEdge.rotate(edge: .south, rotation: .south), .north)
        XCTAssertEqual(GridEdge.rotate(edge: .south, rotation: .west), .east)
        
        XCTAssertEqual(GridEdge.rotate(edge: .west, rotation: .north), .west)
        XCTAssertEqual(GridEdge.rotate(edge: .west, rotation: .east), .north)
        XCTAssertEqual(GridEdge.rotate(edge: .west, rotation: .south), .east)
        XCTAssertEqual(GridEdge.rotate(edge: .west, rotation: .west), .south)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
