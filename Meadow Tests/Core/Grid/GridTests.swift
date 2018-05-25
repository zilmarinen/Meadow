//
//  GridTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 29/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

extension GridTests: GridDelegate {
    
    func didBecomeDirty(node: GridNode) {}
}

class GridTests: XCTestCase {
    
    var grid: Grid<GridChunk<GridTile<GridNode>, GridNode>, GridTile<GridNode>, GridNode>!
    
    override func setUp() {
        
        super.setUp()
        
        let meadow = Meadow(delegate: self)
        
        grid = Grid()
        
        grid.delegate = meadow
    }

    func testGridNodeAddition() {
        
        let expect = expectation(description: "Nodes can be added to a grid if the volume they define is not already occupied")
        
        let v0 = Volume(coordinate: Coordinate(x: 13, y: 0, z: 37), size: Size.One)
        let v1 = Volume(coordinate: Coordinate.Left, size: Size.One)
        
        let n0 = grid.add(node: v0)
        let n1 = grid.add(node: v1)
        let n2 = grid.add(node: v0)
        
        let t0 = grid.find(tile: v0.coordinate)
        
        let c0 = grid.find(chunk: v0.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        XCTAssertNil(n2)
        XCTAssertNotNil(t0)
        XCTAssertNotNil(c0)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridChunkRemoval() {
        
        let expect = expectation(description: "Nodes are removed from a grid when the appropriate chunk is removed")
        
        let volume = Volume(coordinate: Coordinate.Left, size: Size.One)
        
        let n0 = grid.add(node: volume)
        
        let t0 = grid.find(tile: volume.coordinate)
        
        let c0 = grid.find(chunk: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(t0)
        XCTAssertNotNil(c0)
        
        let result = grid.remove(chunk: c0!.volume.coordinate)
        
        let n1 = grid.find(node: n0!.volume.coordinate)
        let t1 = grid.find(tile: t0!.volume.coordinate)
        let c1 = grid.find(chunk: c0!.volume.coordinate)
        
        XCTAssertNil(n1)
        XCTAssertNil(t1)
        XCTAssertNil(c1)
        XCTAssertTrue(result)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridTileRemoval() {
        
        let expect = expectation(description: "Nodes are removed from a grid when the appropriate tile is removed")
        
        let volume = Volume(coordinate: Coordinate.Left, size: Size.One)
        
        let n0 = grid.add(node: volume)
        
        let t0 = grid.find(tile: volume.coordinate)
        
        let c0 = grid.find(chunk: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(t0)
        XCTAssertNotNil(c0)
        
        let result = grid.remove(tile: t0!.volume.coordinate)
        
        let n1 = grid.find(node: n0!.volume.coordinate)
        let t1 = grid.find(tile: t0!.volume.coordinate)
        let c1 = grid.find(chunk: c0!.volume.coordinate)
        
        XCTAssertNil(n1)
        XCTAssertNil(t1)
        XCTAssertNil(c1)
        XCTAssertTrue(result)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridNodeRemoval() {
        
        let expect = expectation(description: "Nodes can be found and removed from a grid, removing any related chunks and tiles")
        
        let volume = Volume(coordinate: Coordinate.Left, size: Size.One)
        
        let n0 = grid.add(node: volume)
        
        let t0 = grid.find(tile: volume.coordinate)
        
        let c0 = grid.find(chunk: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(t0)
        XCTAssertNotNil(c0)
        
        let result = grid.remove(node: n0!.volume.coordinate)
        
        let n1 = grid.find(node: n0!.volume.coordinate)
        let t1 = grid.find(tile: t0!.volume.coordinate)
        let c1 = grid.find(chunk: c0!.volume.coordinate)
        
        XCTAssertNil(n1)
        XCTAssertNil(t1)
        XCTAssertNil(c1)
        XCTAssertTrue(result)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridChunkLookup() {
        
        let expect = expectation(description: "Chunks can be found with the given coordinate should they exist")
        
        let volume = Volume(coordinate: Coordinate.Left, size: Size.One)
        
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
        
        let volume = Volume(coordinate: Coordinate.Left, size: Size.One)
        
        let n0 = grid.add(node: volume)
        
        let t0 = grid.find(tile: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(t0)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridNodeLookup() {
        
        let expect = expectation(description: "Nodes can be found with the given coordinate should they exist")
        
        let volume = Volume(coordinate: Coordinate.Left, size: Size.One)
        
        let n0 = grid.add(node: volume)
        
        let n1 = grid.find(node: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridChunkVolume() {
        
        let expect = expectation(description: "Chunk volume is correctly calculated when chunks are created")
        
        let v0 = Volume(coordinate: Coordinate.Left, size: Size.One)
        let v1 = Volume(coordinate: Coordinate(x: 13, y: 0, z: 37), size: Size.One)
        let v2 = Volume(coordinate: Coordinate(x: -13, y: 0, z: -37), size: Size.One)
        
        let n0 = grid.add(node: v0)
        let n1 = grid.add(node: v1)
        let n2 = grid.add(node: v2)
        
        let c0 = grid.find(chunk: v0.coordinate)
        let c1 = grid.find(chunk: v1.coordinate)
        let c2 = grid.find(chunk: v2.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        XCTAssertNotNil(n2)
        XCTAssertNotNil(c0)
        XCTAssertNotNil(c1)
        XCTAssertNotNil(c2)
        XCTAssertEqual(c0?.volume.coordinate.x, -World.ChunkSize)
        XCTAssertEqual(c0?.volume.coordinate.y, World.Floor)
        XCTAssertEqual(c0?.volume.coordinate.z, 0)
        XCTAssertEqual(c0?.volume.size.width, World.ChunkSize)
        XCTAssertEqual(c0?.volume.size.height, (World.Ceiling - World.Floor))
        XCTAssertEqual(c0?.volume.size.depth, World.ChunkSize)
        XCTAssertEqual(c1?.volume.coordinate.x, 10)
        XCTAssertEqual(c1?.volume.coordinate.y, World.Floor)
        XCTAssertEqual(c1?.volume.coordinate.z, 35)
        XCTAssertEqual(c2?.volume.coordinate.x, -15)
        XCTAssertEqual(c2?.volume.coordinate.y, World.Floor)
        XCTAssertEqual(c2?.volume.coordinate.z, -40)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridTileVolume() {
        
        let expect = expectation(description: "Tile volume is correctly calculated when chunks are created")
        
        let v0 = Volume(coordinate: Coordinate.Left, size: Size.One)
        let v1 = Volume(coordinate: Coordinate(x: 13, y: 0, z: 37), size: Size.One)
        let v2 = Volume(coordinate: Coordinate(x: -13, y: 0, z: -37), size: Size.One)
        
        let n0 = grid.add(node: v0)
        let n1 = grid.add(node: v1)
        let n2 = grid.add(node: v2)
        
        let t0 = grid.find(tile: v0.coordinate)
        let t1 = grid.find(tile: v1.coordinate)
        let t2 = grid.find(tile: v2.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        XCTAssertNotNil(n2)
        XCTAssertNotNil(t0)
        XCTAssertNotNil(t1)
        XCTAssertNotNil(t2)
        XCTAssertEqual(t0?.volume.coordinate.x, -World.TileSize)
        XCTAssertEqual(t0?.volume.coordinate.y, World.Floor)
        XCTAssertEqual(t0?.volume.coordinate.z, 0)
        XCTAssertEqual(t0?.volume.size.width, World.TileSize)
        XCTAssertEqual(t0?.volume.size.height, (World.Ceiling - World.Floor))
        XCTAssertEqual(t0?.volume.size.depth, World.TileSize)
        XCTAssertEqual(t1?.volume.coordinate.x, 13)
        XCTAssertEqual(t1?.volume.coordinate.y, World.Floor)
        XCTAssertEqual(t1?.volume.coordinate.z, 37)
        XCTAssertEqual(t2?.volume.coordinate.x, -13)
        XCTAssertEqual(t2?.volume.coordinate.y, World.Floor)
        XCTAssertEqual(t2?.volume.coordinate.z, -37)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
