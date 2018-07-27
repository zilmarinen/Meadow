//
//  TerrainTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 02/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

class TerrainTests: XCTestCase {

    var meadow: Meadow!
    
    override func setUp() {
        
        super.setUp()
        
        meadow = Meadow()
    }
    
    func testTerrainNodeAddition() {
        
        let expect = expectation(description: "Nodes can be added to a grid if the volume they define is not already occupied")
        
        let coordinate = Coordinate(x: 13, y: 0, z: 37)
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        let n1 = meadow.terrain.add(node: coordinate + Coordinate.left)
        let n2 = meadow.terrain.add(node: coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        XCTAssertNil(n2)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
