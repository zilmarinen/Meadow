//
//  VolumeTests.swift
//  Meadow
//
//  Created by Zack Brown on 30/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest
@testable import Meadow

class VolumeTests: XCTestCase {
    
    func testVolumeEquality() {
        
        let expect = expectation(description: "Volumes are considered equal when both coordinates and sizes are equal")
        
        let v0 = Volume(coordinate: Coordinate.Zero, size: Size.One)
        let v1 = Volume(coordinate: Coordinate.One, size: Size.One)
        let v2 = Volume(coordinate: Coordinate.Zero, size: Size.One)
        
        XCTAssertEqual(v0, v0)
        XCTAssertEqual(v0, v2)
        XCTAssertNotEqual(v0, v1)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testCoordinateIntersection() {
        
        let expect = expectation(description: "Coordinate is considered intersecting when the coordinate is contained within the volume")
        
        let v0 = Volume(coordinate: Coordinate.Zero, size: Size(width: 2, height: 2, depth: 2))
        let v1 = Volume(coordinate: Coordinate.Zero, size: Size(width: 4, height: 4, depth: 4))
        let v2 = Volume(coordinate: Coordinate(x: 2, y: 0, z: 5), size: Size(width: 2, height: 2, depth: 2))
        
        XCTAssertTrue(v0.contains(coordinate: Coordinate.Zero))
        XCTAssertTrue(v0.contains(coordinate: Coordinate.One))
        XCTAssertTrue(v1.contains(coordinate: Coordinate.Zero))
        XCTAssertTrue(v1.contains(coordinate: Coordinate.One))
        XCTAssertTrue(v2.contains(coordinate: Coordinate(x: 3, y: 0, z: 6)))
        XCTAssertFalse(v0.contains(coordinate: Coordinate(x: 0, y: 0, z: 2)))
        XCTAssertFalse(v1.contains(coordinate: Coordinate(x: 0, y: 0, z: 6)))
        XCTAssertFalse(v2.contains(coordinate: Coordinate(x: 0, y: 0, z: 6)))
        XCTAssertFalse(v0.contains(coordinate: Coordinate(x: 0, y: 2, z: 0)))
        XCTAssertFalse(v1.contains(coordinate: Coordinate(x: 0, y: 4, z: 0)))
        XCTAssertFalse(v2.contains(coordinate: Coordinate(x: 3, y: 2, z: 6)))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
