//
//  GridTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 29/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest
@testable import Meadow

class GridTests: XCTestCase {
    
    var grid: Grid<GridChunk<GridTile<GridNode>, GridNode>, GridTile<GridNode>, GridNode>!
    
    override func setUp() {
        
        super.setUp()
        
        let meadow = Meadow()
        
        grid = Grid(delegate: meadow)
    }

    func testGridNodeAddition() {
        
        let expect = expectation(description: "Nodes can be added to a grid if the volume they define is not already occupied")
        
        let v0 = Volume(coordinate: Coordinate.Zero, size: Size.One)
        let v1 = Volume(coordinate: Coordinate.Left, size: Size.One)
        
        let n0 = grid.add(node: v0)
        let n1 = grid.add(node: v1)
        let n2 = grid.add(node: v0)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        XCTAssertNil(n2)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridChunkRemoval() {
        
        let expect = expectation(description: "Nodes are removed from a grid when the appropriate chunk is removed")
        
        let volume = Volume(coordinate: Coordinate.Zero, size: Size.One)
        
        let n0 = grid.add(node: volume)
        
        let t0 = grid.find(tile: volume.coordinate)
        
        let c0 = grid.find(chunk: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(t0)
        XCTAssertNotNil(c0)
        
        grid.remove(chunk: c0!.volume.coordinate)
        
        let n1 = grid.find(node: n0!.volume.coordinate)
        let t1 = grid.find(tile: t0!.volume.coordinate)
        let c1 = grid.find(chunk: c0!.volume.coordinate)
        
        XCTAssertNil(n1)
        XCTAssertNil(t1)
        XCTAssertNil(c1)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridTileRemoval() {
        
        let expect = expectation(description: "Nodes are removed from a grid when the appropriate tile is removed")
        
        let volume = Volume(coordinate: Coordinate.Zero, size: Size.One)
        
        let n0 = grid.add(node: volume)
        
        let t0 = grid.find(tile: volume.coordinate)
        
        let c0 = grid.find(chunk: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(t0)
        XCTAssertNotNil(c0)
        
        grid.remove(tile: t0!.volume.coordinate)
        
        let n1 = grid.find(node: n0!.volume.coordinate)
        let t1 = grid.find(tile: t0!.volume.coordinate)
        let c1 = grid.find(chunk: c0!.volume.coordinate)
        
        XCTAssertNil(n1)
        XCTAssertNil(t1)
        XCTAssertNil(c1)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridNodeRemoval() {
        
        let expect = expectation(description: "Nodes can be found and removed from a grid, removing any related chunks and tiles")
        
        let volume = Volume(coordinate: Coordinate.Zero, size: Size.One)
        
        let n0 = grid.add(node: volume)
        
        let t0 = grid.find(tile: volume.coordinate)
        
        let c0 = grid.find(chunk: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(t0)
        XCTAssertNotNil(c0)
        
        grid.remove(node: n0!.volume.coordinate)
        
        let n1 = grid.find(node: n0!.volume.coordinate)
        let t1 = grid.find(tile: t0!.volume.coordinate)
        let c1 = grid.find(chunk: c0!.volume.coordinate)
        
        XCTAssertNil(n1)
        XCTAssertNil(t1)
        XCTAssertNil(c1)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridChunkLookup() {
        
        let expect = expectation(description: "Chunks can be found with the given coordinate should they exist")
        
        let volume = Volume(coordinate: Coordinate.Zero, size: Size.One)
        
        let n0 = grid.add(node: volume)
        
        let t0 = grid.find(tile: volume.coordinate)
        
        let c0 = grid.find(chunk: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(t0)
        XCTAssertNotNil(c0)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridTileLookup() {
        
        let expect = expectation(description: "Tiles can be found with the given coordinate should they exist")
        
        let volume = Volume(coordinate: Coordinate.Zero, size: Size.One)
        
        let n0 = grid.add(node: volume)
        
        let t0 = grid.find(tile: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(t0)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridNodeLookup() {
        
        let expect = expectation(description: "Nodes can be found with the given coordinate should they exist")
        
        let volume = Volume(coordinate: Coordinate.Zero, size: Size.One)
        
        let n0 = grid.add(node: volume)
        
        let n1 = grid.find(node: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
