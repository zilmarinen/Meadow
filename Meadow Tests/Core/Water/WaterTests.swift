//
//  WaterTests.swift
//  Meadow-iOSTests
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

class WaterTests: XCTestCase {
    
    var meadow: Meadow!
    
    override func setUp() {
        
        super.setUp()
        
        meadow = Meadow(observer: nil)
    }
    
    func testWaterNodeAddition() {
        
        let expect = expectation(description: "Nodes can be added to a grid if the volume they define is not already occupied")
        
        let coordinate = Coordinate(x: 13, y: 0, z: 37)
        
        let n0 = meadow.water.add(node: Coordinate(x: 13, y: 0, z: 37))
        let n1 = meadow.water.add(node: coordinate + Coordinate.left)
        let n2 = meadow.water.add(node: coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        XCTAssertNil(n2)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }

    func testWaterNodeNeighbourAddition() {
        
        let expect = expectation(description: "Nodes are connected together when added to the grid")
        
        let coordinate = Coordinate(x: 13, y: 0, z: 37)
        
        let n0 = meadow.water.add(node: Coordinate(x: 13, y: 0, z: 37))
        let n1 = meadow.water.add(node: coordinate + Coordinate.left)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        
        let n2 = n0?.find(neighbour: .north)
        let n3 = n0?.find(neighbour: .east)
        let n4 = n0?.find(neighbour: .south)
        let n5 = n0?.find(neighbour: .west)
        
        let n6 = n1?.find(neighbour: .north)
        let n7 = n1?.find(neighbour: .east)
        let n8 = n1?.find(neighbour: .south)
        let n9 = n1?.find(neighbour: .west)
        
        XCTAssertNil(n2)
        XCTAssertNil(n3)
        XCTAssertNil(n4)
        XCTAssertNotNil(n5)
        XCTAssertNotNil(n5?.node)
        XCTAssertEqual(n5?.node, n1)
        XCTAssertEqual(n5?.edge, .west)
        
        XCTAssertNil(n6)
        XCTAssertNotNil(n7)
        XCTAssertNil(n8)
        XCTAssertNil(n9)
        XCTAssertNotNil(n7?.node)
        XCTAssertEqual(n7?.node, n0)
        XCTAssertEqual(n7?.edge, .east)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
