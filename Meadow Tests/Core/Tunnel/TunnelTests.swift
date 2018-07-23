//
//  TunnelTests.swift
//  Meadow-iOSTests
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

class TunnelTests: XCTestCase {
    
    var meadow: Meadow!
    
    override func setUp() {
        
        super.setUp()
        
        meadow = Meadow()
    }
    
    func testTunnelNodeAddition() {
        
        let expect = expectation(description: "Nodes can be added to a grid if the volume they define is not already occupied")
        
        let coordinate = Coordinate(x: 13, y: 0, z: 37)
        
        let n0 = meadow.tunnels.add(node: Coordinate(x: 13, y: 0, z: 37))
        let n1 = meadow.tunnels.add(node: coordinate + Coordinate.left)
        let n2 = meadow.tunnels.add(node: coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        XCTAssertNil(n2)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testNodeTypesAreLoaded() {
        
        let expect = expectation(description: "Tunnel types are loaded and can be found")
        
        let knownNodeType = meadow.tunnels.find(nodeType: "Concrete")
        let unknownNodeType = meadow.tunnels.find(nodeType: "unknown")
        
        XCTAssertNotNil(knownNodeType)
        XCTAssertNil(unknownNodeType)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
