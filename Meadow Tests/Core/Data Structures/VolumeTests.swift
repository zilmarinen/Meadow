//
//  VolumeTests.swift
//  Meadow
//
//  Created by Zack Brown on 30/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

class VolumeTests: XCTestCase {
    
    func testVolumeEquality() {
        
        let expect = expectation(description: "Volumes are considered equal when both coordinates and sizes are equal")
        
        let v0 = Volume(coordinate: Coordinate.zero, size: Size.one)
        let v1 = Volume(coordinate: Coordinate.one, size: Size.one)
        let v2 = Volume(coordinate: Coordinate.zero, size: Size.one)
        
        XCTAssertEqual(v0, v0)
        XCTAssertEqual(v0, v2)
        XCTAssertNotEqual(v0, v1)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testCoordinateIntersection() {
        
        let expect = expectation(description: "Coordinate is considered intersecting when the coordinate is contained within the volume")
        
        let v0 = Volume(coordinate: Coordinate(x: 13, y: 0, z: 37), size: Size(width: 2, height: 2, depth: 2))
        let v1 = Volume(coordinate: Coordinate(x: 13, y: 0, z: 37), size: Size(width: 4, height: 4, depth: 4))
        let v2 = Volume(coordinate: Coordinate(x: 15, y: 0, z: 42), size: Size(width: 2, height: 2, depth: 2))
        
        XCTAssertTrue(v0.contains(coordinate: v0.coordinate))
        XCTAssertTrue(v0.contains(coordinate: v1.coordinate))
        XCTAssertTrue(v1.contains(coordinate: v0.coordinate))
        XCTAssertTrue(v1.contains(coordinate: v1.coordinate))
        XCTAssertTrue(v2.contains(coordinate: v2.coordinate))
        
        XCTAssertFalse(v0.contains(coordinate: v2.coordinate))
        XCTAssertFalse(v1.contains(coordinate: v2.coordinate))
        XCTAssertFalse(v2.contains(coordinate: v0.coordinate))
        XCTAssertFalse(v2.contains(coordinate: v1.coordinate))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
