//
//  CoordinateTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

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
        
        XCTAssertEqual(1, left.x)
        XCTAssertEqual(0, left.y)
        XCTAssertEqual(0, left.z)
        
        XCTAssertEqual(-1, right.x)
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
    
    func testCoordinateAddition() {
        
        let expect = expectation(description: "Coordinate components are added together correctly when using the + operator")
        
        let c0 = Coordinate(x: 10, y: 0, z: 5)
        let c1 = Coordinate(x: 0, y: 10, z: 5)
        let c2 = c0 + c1
        
        XCTAssertEqual(10, c2.x)
        XCTAssertEqual(10, c2.y)
        XCTAssertEqual(10, c2.z)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testCoordinateSubtraction() {
        
        let expect = expectation(description: "Coordinate components are subtracted from each other correctly when using the - operator")
        
        let c0 = Coordinate(x: 10, y: 0, z: 5)
        let c1 = Coordinate(x: 0, y: 10, z: 5)
        let c2 = c0 - c1
        
        XCTAssertEqual(10, c2.x)
        XCTAssertEqual(-10, c2.y)
        XCTAssertEqual(0, c2.z)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testCoordinateEquality() {
    
        let expect = expectation(description: "Coordinates are considered equal when all x, y and z components are equal")
        
        let c0 = Coordinate.Zero
        let c1 = Coordinate.One
        let c2 = Coordinate.Zero
        
        XCTAssertEqual(c0, c0)
        XCTAssertEqual(c0, c2)
        XCTAssertNotEqual(c0, c1)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testCoordinateAdjacency() {
        
        let expect = expectation(description: "Coordinate adjacency along the x and z axis can be determined for both diagonal and adjacent coordinates.")
        
        let reference = Coordinate(x: 13, y: 0, z: 37)
        let up = reference + Coordinate.Up
        let down = reference + Coordinate.Down
        let left = reference + Coordinate.Left
        let right = reference + Coordinate.Right
        let forward = reference + Coordinate.Forward
        let backward = reference + Coordinate.Backward
        let d0 = reference + Coordinate(x: -1, y: 0, z: 1)
        let d1 = reference + Coordinate(x: 1, y: 1, z: 1)
        let d2 = reference + Coordinate(x: 1, y: 2, z: -1)
        let d3 = reference + Coordinate(x: -1, y: 3, z: -1)
        let detached = reference + Coordinate(x: 7, y: 0, z: 7)
        let upperLeft = reference + Coordinate(x: -1, y: 1, z: 0)
        let lowerRight = reference + Coordinate(x: 1, y: -1, z: 0)
        let upperForward = reference + Coordinate(x: 0, y: 1, z: 1)
        let lowerBackward = reference + Coordinate(x: 0, y: -1, z: -1)
        
        XCTAssertEqual(left.adjacency(to: reference), .adjacent)
        XCTAssertEqual(right.adjacency(to: reference), .adjacent)
        XCTAssertEqual(forward.adjacency(to: reference), .adjacent)
        XCTAssertEqual(backward.adjacency(to: reference), .adjacent)
        
        XCTAssertEqual(d0.adjacency(to: reference), .diagonal)
        XCTAssertEqual(d1.adjacency(to: reference), .diagonal)
        XCTAssertEqual(d2.adjacency(to: reference), .diagonal)
        XCTAssertEqual(d3.adjacency(to: reference), .diagonal)
        
        XCTAssertEqual(upperLeft.adjacency(to: reference), .adjacent)
        XCTAssertEqual(lowerRight.adjacency(to: reference), .adjacent)
        XCTAssertEqual(upperForward.adjacency(to: reference), .adjacent)
        XCTAssertEqual(lowerBackward.adjacency(to: reference), .adjacent)
        
        XCTAssertEqual(detached.adjacency(to: reference), .detached)
        XCTAssertEqual(reference.adjacency(to: reference), .equal)
        XCTAssertEqual(up.adjacency(to: reference), .equal)
        XCTAssertEqual(down.adjacency(to: reference), .equal)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
