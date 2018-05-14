//
//  TerrainTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 02/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

extension TerrainTests: GridDelegate {
    
    func didBecomeDirty(node: GridNode) {}
}

class TerrainTests: XCTestCase {

    var meadow: Meadow!
    
    override func setUp() {
        
        super.setUp()
        
        meadow = Meadow(delegate: self)
    }
    
    func testTerrainNodeAddition() {
        
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
        
        let n2 = n0!.find(neighbour: .north)
        let n3 = n0!.find(neighbour: .east)
        let n4 = n0!.find(neighbour: .south)
        let n5 = n0!.find(neighbour: .west)
        
        let n6 = n1!.find(neighbour: .north)
        let n7 = n1!.find(neighbour: .east)
        let n8 = n1!.find(neighbour: .south)
        let n9 = n1!.find(neighbour: .west)
        
        XCTAssertNil(n2)
        XCTAssertNil(n3)
        XCTAssertNil(n4)
        XCTAssertNotNil(n5)
        XCTAssertNotNil(n5!.node)
        XCTAssertEqual(n5!.node, n1)
        XCTAssertEqual(n5!.edge, .west)
        
        XCTAssertNil(n6)
        XCTAssertNotNil(n7)
        XCTAssertNil(n8)
        XCTAssertNil(n9)
        XCTAssertNotNil(n7!.node)
        XCTAssertEqual(n7!.node, n0)
        XCTAssertEqual(n7!.edge, .east)
        
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
        
        let n2 = n0!.find(neighbour: .north)
        let n3 = n0!.find(neighbour: .east)
        let n4 = n0!.find(neighbour: .south)
        let n5 = n0!.find(neighbour: .west)
        
        XCTAssertTrue(result)
        XCTAssertNil(n2)
        XCTAssertNil(n3)
        XCTAssertNil(n4)
        XCTAssertNil(n5)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainTypesAreLoaded() {
        
        let expect = expectation(description: "Terrain types are loaded and can be found")
        
        let BedrockTerrainType = meadow.terrain.find(terrainType: "Bedrock")
        let grassTerrainType = meadow.terrain.find(terrainType: "Grass")
        let unknownTerrainType = meadow.terrain.find(terrainType: "unknowm")
        
        XCTAssertNotNil(BedrockTerrainType)
        XCTAssertNotNil(grassTerrainType)
        XCTAssertNil(unknownTerrainType)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
