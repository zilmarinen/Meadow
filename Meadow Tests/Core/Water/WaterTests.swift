//
//  WaterTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

class WaterTests: XCTestCase {
    
    var scene: SceneKitScene!
    
    override func setUp() {
        
        super.setUp()
        
        self.scene = SceneKitScene(observer: nil)
    }
    
    func testWaterEdgeLayerCount() {
        
        let expect = expectation(description: "Water edge counts should match the number of edges per node")
        
        let coordinate0 = Coordinate(x: 13, y: 0, z: 37)
        let coordinate1 = Coordinate(x: 31, y: 0, z: 13)
        let coordinate2 = Coordinate(x: 1, y: 0, z: 337)
        
        let edge0 = scene.world.water.add(edge: coordinate0, edge: .north, waterType: WaterType.water)
        let edge1 = scene.world.water.add(edge: coordinate1, edge: .east, waterType: WaterType.water)
        let edge2 = scene.world.water.add(edge: coordinate2, edge: .south, waterType: WaterType.water)
        let edge3 = scene.world.water.add(edge: coordinate2, edge: .west, waterType: WaterType.water)
        let edge4 = scene.world.water.add(edge: coordinate2, edge: .west, waterType: WaterType.water)
        
        XCTAssertNotNil(edge0)
        XCTAssertNotNil(edge1)
        XCTAssertNotNil(edge2)
        XCTAssertNotNil(edge3)
        XCTAssertNotNil(edge4)
        
        let chunk0 = scene.world.water.find(chunk: coordinate0)
        let chunk1 = scene.world.water.find(chunk: coordinate1)
        let chunk2 = scene.world.water.find(chunk: coordinate2)
        
        XCTAssertNotNil(chunk0)
        XCTAssertNotNil(chunk1)
        XCTAssertNotNil(chunk2)
        
        let tile0 = scene.world.water.find(tile: coordinate0)
        let tile1 = scene.world.water.find(tile: coordinate1)
        let tile2 = scene.world.water.find(tile: coordinate2)
        
        XCTAssertNotNil(tile0)
        XCTAssertNotNil(tile1)
        XCTAssertNotNil(tile2)
        
        let node0 = scene.world.water.find(node: coordinate0)
        let node1 = scene.world.water.find(node: coordinate1)
        let node2 = scene.world.water.find(node: coordinate2)
        
        XCTAssertNotNil(node0)
        XCTAssertNotNil(node1)
        XCTAssertNotNil(node2)
        
        XCTAssertEqual(edge0?.edge, .north)
        XCTAssertEqual(edge1?.edge, .east)
        XCTAssertEqual(edge2?.edge, .south)
        XCTAssertEqual(edge3?.edge, .west)
        XCTAssertEqual(edge4?.edge, .west)
        
        XCTAssertEqual(scene.world.water.totalChildren, 3)
        XCTAssertEqual(chunk0?.totalChildren, 1)
        XCTAssertEqual(chunk1?.totalChildren, 1)
        XCTAssertEqual(chunk2?.totalChildren, 1)
        XCTAssertEqual(tile0?.totalChildren, 1)
        XCTAssertEqual(tile1?.totalChildren, 1)
        XCTAssertEqual(tile2?.totalChildren, 1)
        XCTAssertEqual(node0?.totalChildren, 1)
        XCTAssertEqual(node1?.totalChildren, 1)
        XCTAssertEqual(node2?.totalChildren, 2)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testWaterLayerAddition() {
        
        let expect = expectation(description: "Water node edges can be added to a grid if the volume they define is not already occupied")
        
        let coordinate = Coordinate(x: 13, y: 0, z: 37)
        
        let edge = GridEdge.north
        let oppositeEdge = GridEdge.opposite(edge: edge)
        
        let e0 = scene.world.water.add(edge: coordinate, edge: edge, waterType: WaterType.water)
        let e1 = scene.world.water.add(edge: coordinate, edge: oppositeEdge, waterType: WaterType.water)
        let e2 = scene.world.water.add(edge: coordinate, edge: edge, waterType: WaterType.water)
        
        XCTAssertNotNil(e0)
        XCTAssertNotNil(e1)
        XCTAssertNotNil(e2)
        
        XCTAssertEqual(e0, e2)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testWaterLayerEquality() {
        
        let expect = expectation(description: "Water node edges are considered equal when all x, y and z components, edges, water levels and water types are equal")
        
        let edge = GridEdge.north
        let oppositeEdge = GridEdge.opposite(edge: edge)
        
        let e0 = scene.world.water.add(edge: Coordinate(x: 13, y: 0, z: 37), edge: edge, waterType: WaterType.water)
        let e1 = scene.world.water.add(edge: Coordinate(x: 13, y: 0, z: 37), edge: edge, waterType: WaterType.water)
        let e2 = scene.world.water.add(edge: Coordinate(x: 13, y: 0, z: 37), edge: oppositeEdge, waterType: WaterType.water)
        let e3 = scene.world.water.add(edge: Coordinate(x: 13, y: 0, z: 37), edge: oppositeEdge, waterType: WaterType.lava)
        
        XCTAssertNotNil(e0)
        XCTAssertNotNil(e1)
        XCTAssertNotNil(e2)
        XCTAssertNotNil(e3)
        
        XCTAssertEqual(e0, e0)
        XCTAssertEqual(e0, e1)
        XCTAssertNotEqual(e0, e2)
        XCTAssertNotEqual(e0, e3)
        XCTAssertNotEqual(e1, e2)
        XCTAssertNotEqual(e1, e3)
        XCTAssertEqual(e2, e3)
        
        XCTAssertEqual(e0?.waterType, WaterType.water)
        XCTAssertEqual(e1?.waterType, WaterType.water)
        XCTAssertEqual(e2?.waterType, WaterType.water)
        XCTAssertEqual(e3?.waterType, WaterType.water)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testWaterNodeAddition() {
        
        let expect = expectation(description: "Nodes can be added to a grid if the volume they define is not already occupied")
        
        let coordinate = Coordinate(x: 13, y: 0, z: 37)
        
        let n0 = scene.world.water.add(node: Coordinate(x: 13, y: 0, z: 37))
        let n1 = scene.world.water.add(node: coordinate + Coordinate.left)
        let n2 = scene.world.water.add(node: coordinate)
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        XCTAssertNil(n2)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }

    func testWaterNodeNeighbourAddition() {
        
        let expect = expectation(description: "Nodes are connected together when added to the grid")
        
        let coordinate = Coordinate(x: 13, y: 0, z: 37)
        
        let n0 = scene.world.water.add(node: Coordinate(x: 13, y: 0, z: 37))
        let n1 = scene.world.water.add(node: coordinate + Coordinate.left)
        
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
