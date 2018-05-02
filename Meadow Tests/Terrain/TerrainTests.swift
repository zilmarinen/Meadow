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

    var grid: Terrain!
    
    override func setUp() {
        
        super.setUp()
        
        let meadow = Meadow()
        
        grid = Terrain(delegate: meadow)
    }
    
    func testGridNodeAddition() {
        
        let expect = expectation(description: "Nodes can be added to a grid if the volume they define is not already occupied")
        
        let v0 = Volume(coordinate: Coordinate.Zero, size: TerrainTile.TileSize)
        let v1 = Volume(coordinate: Coordinate.Left, size: TerrainTile.TileSize)
        
        let n0 = grid.add(node: v0)
        let n1 = grid.add(node: v1)
        let n2 = grid.add(node: v0)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        XCTAssertNil(n2)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
