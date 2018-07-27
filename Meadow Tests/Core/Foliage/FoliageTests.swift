//
//  FoliageTests.swift
//  Meadow-iOSTests
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

class FoliageTests: XCTestCase {
    
    var meadow: Meadow!
    
    override func setUp() {
        
        super.setUp()
        
        meadow = Meadow()
    }
    
    func testFoliageNodeAddition() {
        
        let expect = expectation(description: "Nodes can be added to a grid if the volume they define is not already occupied")
        
        let coordinate = Coordinate(x: 13, y: 0, z: 37)
        
        let n0 = meadow.foliage.add(node: Coordinate(x: 13, y: 0, z: 37))
        let n1 = meadow.foliage.add(node: coordinate + Coordinate.left)
        let n2 = meadow.foliage.add(node: coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        XCTAssertNil(n2)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }

}
