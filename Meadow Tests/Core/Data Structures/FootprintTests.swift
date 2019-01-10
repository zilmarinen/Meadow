//
//  FootprintTests.swift
//  Meadow-iOSTests
//
//  Created by Zack Brown on 10/01/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import XCTest

class FootprintTests: XCTestCase {

    func testFootprintIntersection() {
        
        let expect = expectation(description: "Intersecting footprints are correctly determined for any given rotation of both footprints")
        
        let c0 = Coordinate.zero
        let c1 = Coordinate.forward
        let c2 = Coordinate.left
        let c3 = Coordinate.forward + Coordinate.forward
        
        let n0 = FootprintNode(coordinate: c0, edges: [.north, .east, .south, .west])
        let n1 = FootprintNode(coordinate: c1, edges: [.east, .south, .west])
        let n2 = FootprintNode(coordinate: c0, edges: [.north, .east, .south, .west])
        let n3 = FootprintNode(coordinate: c1, edges: [.south])
        
        let f0 = Footprint(coordinate: c0, rotation: .north, nodes: [n0, n1])
        let f1 = Footprint(coordinate: c0, rotation: .north, nodes: [n2, n3])
        let f2 = Footprint(coordinate: c1, rotation: .north, nodes: [n2, n3])
        let f3 = Footprint(coordinate: c2, rotation: .north, nodes: [n2, n3])
        let f4 = Footprint(coordinate: c3, rotation: .south, nodes: [n2, n3])
        let f5 = Footprint(coordinate: c2, rotation: .east, nodes: [n2, n3])
        
        XCTAssertTrue(f0.intersects(footprint: f1))
        XCTAssertTrue(f0.intersects(footprint: f2))
        XCTAssertFalse(f0.intersects(footprint: f3))
        XCTAssertFalse(f0.intersects(footprint: f4))
        XCTAssertTrue(f0.intersects(footprint: f5))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
