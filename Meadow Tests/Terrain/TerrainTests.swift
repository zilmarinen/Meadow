//
//  TerrainTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 02/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest
@testable import Meadow

class TerrainTests: XCTestCase {

    var meadow: Meadow!
    
    override func setUp() {
        
        super.setUp()
        
        meadow = Meadow()
    }
    
    func testGridNodeAddition() {
        
        let expect = expectation(description: "Nodes can be added to a grid if the volume they define is not already occupied")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        let n1 = meadow.terrain.add(node: n0!.volume.coordinate + Coordinate.Left)
        let n2 = meadow.terrain.add(node: n0!.volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        XCTAssertNil(n2)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridNodeNeighbourAddition() {
        
        let expect = expectation(description: "Nodes are connected together when added to the grid")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        let n1 = meadow.terrain.add(node: n0!.volume.coordinate + Coordinate.Left)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        
        let n2 = n0!.find(neighbour: .west)
        let n3 = n1!.find(neighbour: .east)
        
        XCTAssertNotNil(n2)
        XCTAssertNotNil(n2!.node)
        XCTAssertEqual(n2!.node, n1)
        XCTAssertEqual(n2!.edge, .west)
        XCTAssertNotNil(n3)
        XCTAssertNotNil(n3!.node)
        XCTAssertEqual(n3!.node, n0)
        XCTAssertEqual(n3!.edge, .east)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridNodeNeighbourRemoval() {
        
        let expect = expectation(description: "Nodes are disconnected when removed from the grid")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        let n1 = meadow.terrain.add(node: n0!.volume.coordinate + Coordinate.Left)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        
        let result = meadow.terrain.remove(node: n1!)
        
        let n2 = n0!.find(neighbour: .west)
        
        XCTAssertTrue(result)
        XCTAssertNil(n2)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
