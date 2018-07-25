//
//  GridTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 29/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation
import XCTest

class GridTests: XCTestCase {
    
    var grid: Grid<GridChunk<GridTile<GridNode>, GridNode>, GridTile<GridNode>, GridNode>!
    
    override func setUp() {
        
        super.setUp()
        
        self.grid = Grid()
    }

    func testGridNodeAddition() {
        
        let expect = expectation(description: "Nodes can be added to a grid if the volume they define is not already occupied")
        
        let v0 = Volume(coordinate: Coordinate(x: 13, y: 0, z: 37), size: Size.one)
        let v1 = Volume(coordinate: Coordinate.left, size: Size.one)
        
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
        
        let volume = Volume(coordinate: Coordinate.left, size: Size.one)
        
        let n0 = grid.add(node: volume)
        
        let t0 = grid.find(tile: volume.coordinate)
        
        let c0 = grid.find(chunk: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(t0)
        XCTAssertNotNil(c0)
        
        let result = grid.remove(chunk: c0!)
        
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
        
        let volume = Volume(coordinate: Coordinate.left, size: Size.one)
        
        let n0 = grid.add(node: volume)
        
        let t0 = grid.find(tile: volume.coordinate)
        
        let c0 = grid.find(chunk: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(t0)
        XCTAssertNotNil(c0)
        
        let result = grid.remove(tile: t0!)
        
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
        
        let volume = Volume(coordinate: Coordinate.left, size: Size.one)
        
        let n0 = grid.add(node: volume)
        
        let t0 = grid.find(tile: volume.coordinate)
        
        let c0 = grid.find(chunk: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(t0)
        XCTAssertNotNil(c0)
        
        let result = grid.remove(node: n0!)
        
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
        
        let volume = Volume(coordinate: Coordinate.left, size: Size.one)
        
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
        
        let volume = Volume(coordinate: Coordinate.left, size: Size.one)
        
        let n0 = grid.add(node: volume)
        
        let t0 = grid.find(tile: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(t0)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridNodeLookup() {
        
        let expect = expectation(description: "Nodes can be found with the given coordinate should they exist")
        
        let volume = Volume(coordinate: Coordinate.left, size: Size.one)
        
        let n0 = grid.add(node: volume)
        
        let n1 = grid.find(node: volume.coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridChunkVolume() {
        
        let expect = expectation(description: "Chunk volume is correctly calculated when chunks are created")
        
        let v0 = Volume(coordinate: Coordinate.left, size: Size.one)
        let v1 = Volume(coordinate: Coordinate(x: 13, y: 0, z: 37), size: Size.one)
        let v2 = Volume(coordinate: Coordinate(x: -13, y: 0, z: -37), size: Size.one)
        
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
        XCTAssertEqual(c0?.volume.coordinate.x, 0)
        XCTAssertEqual(c0?.volume.coordinate.y, World.floor)
        XCTAssertEqual(c0?.volume.coordinate.z, 0)
        XCTAssertEqual(c0?.volume.size.width, World.chunkSize)
        XCTAssertEqual(c0?.volume.size.height, (World.ceiling - World.floor))
        XCTAssertEqual(c0?.volume.size.depth, World.chunkSize)
        XCTAssertEqual(c1?.volume.coordinate.x, 10)
        XCTAssertEqual(c1?.volume.coordinate.y, World.floor)
        XCTAssertEqual(c1?.volume.coordinate.z, 35)
        XCTAssertEqual(c2?.volume.coordinate.x, -15)
        XCTAssertEqual(c2?.volume.coordinate.y, World.floor)
        XCTAssertEqual(c2?.volume.coordinate.z, -40)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridTileVolume() {
        
        let expect = expectation(description: "Tile volume is correctly calculated when chunks are created")
        
        let v0 = Volume(coordinate: Coordinate.left, size: Size.one)
        let v1 = Volume(coordinate: Coordinate(x: 13, y: 0, z: 37), size: Size.one)
        let v2 = Volume(coordinate: Coordinate(x: -13, y: 0, z: -37), size: Size.one)
        
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
        XCTAssertEqual(t0?.volume.coordinate.x, 1)
        XCTAssertEqual(t0?.volume.coordinate.y, World.floor)
        XCTAssertEqual(t0?.volume.coordinate.z, 0)
        XCTAssertEqual(t0?.volume.size.width, World.tileSize)
        XCTAssertEqual(t0?.volume.size.height, (World.ceiling - World.floor))
        XCTAssertEqual(t0?.volume.size.depth, World.tileSize)
        XCTAssertEqual(t1?.volume.coordinate.x, 13)
        XCTAssertEqual(t1?.volume.coordinate.y, World.floor)
        XCTAssertEqual(t1?.volume.coordinate.z, 37)
        XCTAssertEqual(t2?.volume.coordinate.x, -13)
        XCTAssertEqual(t2?.volume.coordinate.y, World.floor)
        XCTAssertEqual(t2?.volume.coordinate.z, -37)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridNodeVolume() {
        
        let expect = expectation(description: "Nodes can only be added to a grid if the volume they occupy is within the bounds of the World.Floor and World.Ceiling")
        
        let size = Size(width: 1, height: 4, depth: 1)
        
        let v0 = Volume(coordinate: Coordinate(x: 0, y: World.floor - 1, z: 0), size: size)
        let v1 = Volume(coordinate: Coordinate(x: 0, y: World.ceiling, z: 0), size: size)
        let v2 = Volume(coordinate: Coordinate(x: 0, y: World.ceiling - 2, z: 0), size: size)
        
        let n0 = grid.add(node: v0)
        let n1 = grid.add(node: v1)
        let n2 = grid.add(node: v2)
        
        XCTAssertNil(n0)
        XCTAssertNil(n1)
        XCTAssertNil(n2)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testGridNodeNeighbourAddition() {
        
        let expect = expectation(description: "Nodes are connected together when added to the grid")
        
        let coordinate = Coordinate(x: 13, y: 0, z: 37)
        
        let v0 = Volume(coordinate: coordinate, size: Size.one)
        let v1 = Volume(coordinate: coordinate + Coordinate.left, size: Size.one)
        
        let n0 = grid.add(node: v0)
        let n1 = grid.add(node: v1)
        
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
    
    func testGridNodeNeighbourRemoval() {
        
        let expect = expectation(description: "Nodes are disconnected when removed from the grid")
        
        let coordinate = Coordinate(x: 13, y: 0, z: 37)
        
        let v0 = Volume(coordinate: coordinate, size: Size.one)
        let v1 = Volume(coordinate: coordinate + Coordinate.left, size: Size.one)
        
        let n0 = grid.add(node: v0)
        let n1 = grid.add(node: v1)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        
        let result = grid.remove(node: n1!)
        
        let n2 = n0?.find(neighbour: .north)
        let n3 = n0?.find(neighbour: .east)
        let n4 = n0?.find(neighbour: .south)
        let n5 = n0?.find(neighbour: .west)
        
        XCTAssertTrue(result)
        XCTAssertNil(n2)
        XCTAssertNil(n3)
        XCTAssertNil(n4)
        XCTAssertNil(n5)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
