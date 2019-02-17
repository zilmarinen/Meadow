//
//  TerrainLayerTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 07/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

class TerrainLayerTests: XCTestCase {

    var scene: Scene!
    
    override func setUp() {
        
        super.setUp()
        
        self.scene = Scene(observer: nil)
    }
    
    func testTerrainEdgeLayerCount() {
        
        let expect = expectation(description: "Terrain edge and layer counts should match the number of edges per node and layers per edge")
        
        let coordinate0 = Coordinate(x: 13, y: 0, z: 37)
        let coordinate1 = Coordinate(x: 31, y: 0, z: 13)
        let coordinate2 = Coordinate(x: 1, y: 0, z: 337)
        
        let layer0 = scene.world.terrain.add(layer: coordinate0, edge: .north, terrainType: TerrainType.bedrock)
        let layer1 = scene.world.terrain.add(layer: coordinate1, edge: .east, terrainType: TerrainType.bedrock)
        let layer2 = scene.world.terrain.add(layer: coordinate2, edge: .south, terrainType: TerrainType.bedrock)
        let layer3 = scene.world.terrain.add(layer: coordinate2, edge: .west, terrainType: TerrainType.bedrock)
        let layer4 = scene.world.terrain.add(layer: coordinate2, edge: .west, terrainType: TerrainType.bedrock)
        
        XCTAssertNotNil(layer0)
        XCTAssertNotNil(layer1)
        XCTAssertNotNil(layer2)
        XCTAssertNotNil(layer3)
        XCTAssertNotNil(layer4)
        
        let chunk0 = scene.world.terrain.find(chunk: coordinate0)
        let chunk1 = scene.world.terrain.find(chunk: coordinate1)
        let chunk2 = scene.world.terrain.find(chunk: coordinate2)
        
        XCTAssertNotNil(chunk0)
        XCTAssertNotNil(chunk1)
        XCTAssertNotNil(chunk2)
        
        let tile0 = scene.world.terrain.find(tile: coordinate0)
        let tile1 = scene.world.terrain.find(tile: coordinate1)
        let tile2 = scene.world.terrain.find(tile: coordinate2)
        
        XCTAssertNotNil(tile0)
        XCTAssertNotNil(tile1)
        XCTAssertNotNil(tile2)
        
        let node0 = scene.world.terrain.find(node: coordinate0)
        let node1 = scene.world.terrain.find(node: coordinate1)
        let node2 = scene.world.terrain.find(node: coordinate2)
        
        XCTAssertNotNil(node0)
        XCTAssertNotNil(node1)
        XCTAssertNotNil(node2)
        
        let edge0 = scene.world.terrain.find(edge: coordinate0, edge: .north)
        let edge1 = scene.world.terrain.find(edge: coordinate1, edge: .east)
        let edge2 = scene.world.terrain.find(edge: coordinate2, edge: .south)
        let edge3 = scene.world.terrain.find(edge: coordinate2, edge: .west)
        
        XCTAssertNotNil(edge0)
        XCTAssertNotNil(edge1)
        XCTAssertNotNil(edge2)
        XCTAssertNotNil(edge3)
        
        XCTAssertEqual(layer0?.edge, .north)
        XCTAssertEqual(layer1?.edge, .east)
        XCTAssertEqual(layer2?.edge, .south)
        XCTAssertEqual(layer3?.edge, .west)
        XCTAssertEqual(layer4?.edge, .west)
        
        XCTAssertEqual(edge0?.edge, .north)
        XCTAssertEqual(edge1?.edge, .east)
        XCTAssertEqual(edge2?.edge, .south)
        XCTAssertEqual(edge3?.edge, .west)
        
        XCTAssertEqual(scene.world.terrain.totalChildren, 3)
        XCTAssertEqual(chunk0?.totalChildren, 1)
        XCTAssertEqual(chunk1?.totalChildren, 1)
        XCTAssertEqual(chunk2?.totalChildren, 1)
        XCTAssertEqual(tile0?.totalChildren, 1)
        XCTAssertEqual(tile1?.totalChildren, 1)
        XCTAssertEqual(tile2?.totalChildren, 1)
        XCTAssertEqual(node0?.totalChildren, 1)
        XCTAssertEqual(node1?.totalChildren, 1)
        XCTAssertEqual(node2?.totalChildren, 2)
        XCTAssertEqual(edge0?.totalChildren, 1)
        XCTAssertEqual(edge1?.totalChildren, 1)
        XCTAssertEqual(edge2?.totalChildren, 1)
        XCTAssertEqual(edge3?.totalChildren, 2)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerAddition() {
        
        let expect = expectation(description: "Terrain layers can be added to a grid if the volume they define is not already occupied")
        
        let coordinate = Coordinate(x: 13, y: 0, z: 37)
        
        let edge = GridEdge.north
        
        let l0 = scene.world.terrain.add(layer: coordinate, edge: edge, terrainType: TerrainType.bedrock)
        let l1 = scene.world.terrain.add(layer: coordinate, edge: edge, terrainType: TerrainType.bedrock)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        
        let (c0, c1) = GridCorner.corners(edge: edge)
        
        l1?.set(corner: c0, height: World.ceiling)
        l1?.set(corner: c1, height: World.ceiling)
        l1?.set(center: World.ceiling)
        
        XCTAssertEqual(l1?.get(corner: c0), World.ceiling)
        XCTAssertEqual(l1?.get(corner: c1), World.ceiling)
        XCTAssertEqual(l1?.centre, World.ceiling)
        
        let l2 = scene.world.terrain.add(layer: coordinate, edge: edge, terrainType: TerrainType.bedrock)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNil(l2)
        XCTAssertNil(l0?.lower)
        XCTAssertEqual(l0?.upper, l1)
        XCTAssertEqual(l1?.lower, l0)
        XCTAssertNil(l1?.upper)
        
        let l3 = scene.world.terrain.add(layer: coordinate, edge: GridEdge.opposite(edge: edge), terrainType: TerrainType.bedrock)
        
        XCTAssertNotNil(l3)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerEquality() {
        
        let expect = expectation(description: "Terrain layers are considered equal when all x, y and z components, edges, corner heights and terrain types are equal")
        
        let edge = GridEdge.north
        let oppositeEdge = GridEdge.opposite(edge: edge)
        
        let l0 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        let l1 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        let l2 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: oppositeEdge, terrainType: TerrainType.bedrock)
        let l3 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: oppositeEdge, terrainType: TerrainType.sand)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        XCTAssertNotNil(l3)
        
        XCTAssertEqual(l0, l0)
        XCTAssertNotEqual(l0, l1)
        XCTAssertNotEqual(l0, l2)
        XCTAssertNotEqual(l0, l3)
        XCTAssertNotEqual(l1, l2)
        XCTAssertNotEqual(l1, l3)
        XCTAssertNotEqual(l2, l3)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerCornerHeights() {
        
        let expect = expectation(description: "Corner heights for layers are set to the height of the lower node +1 when created")
        
        let edge = GridEdge.north
        
        let l0 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        let l1 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        let l2 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        
        let (c0, c1) = GridCorner.corners(edge: edge)
        
        XCTAssertEqual(l0?.get(corner: c0), (World.floor + 1))
        XCTAssertEqual(l0?.get(corner: c1), (World.floor + 1))
        XCTAssertEqual(l0?.centre, (World.floor + 1))
        
        XCTAssertEqual(l1?.get(corner: c0), (World.floor + 2))
        XCTAssertEqual(l1?.get(corner: c1), (World.floor + 2))
        XCTAssertEqual(l1?.centre, (World.floor + 2))
        
        XCTAssertEqual(l2?.get(corner: c0), (World.floor + 3))
        XCTAssertEqual(l2?.get(corner: c1), (World.floor + 3))
        XCTAssertEqual(l2?.centre, (World.floor + 3))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerCornerHeightConstraints() {
        
        let expect = expectation(description: "Corner heights for layers are constrained to the grid")
        
        let edge = GridEdge.north
        
        let l0 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        
        XCTAssertNotNil(l0)
        
        let (c0, c1) = GridCorner.corners(edge: edge)
        
        l0?.set(corner: c0, height: (World.floor * 2))
        l0?.set(corner: c1, height: (World.floor * 2))
        l0?.set(center: (World.floor * 2))
        
        XCTAssertEqual(l0?.get(corner: c0), (World.floor + 1))
        XCTAssertEqual(l0?.get(corner: c1), (World.floor + 1))
        XCTAssertEqual(l0?.centre, (World.floor + 1))
        
        l0?.set(corner: c0, height: (World.ceiling * 2))
        l0?.set(corner: c1, height: (World.ceiling * 2))
        l0?.set(center: (World.ceiling * 2))
        
        XCTAssertEqual(l0?.get(corner: c0), World.ceiling)
        XCTAssertEqual(l0?.get(corner: c1), World.ceiling)
        XCTAssertEqual(l0?.centre, World.ceiling)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerCornerHierarchyHeightConstraints() {
        
        let expect = expectation(description: "Corner heights for layers are constrained by upper and lower nodes")
        
        let edge = GridEdge.north
        
        let l0 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        let l1 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        let l2 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        
        let (c0, c1) = GridCorner.corners(edge: edge)
        
        l1?.set(corner: c0, height: (World.floor * 2))
        l1?.set(corner: c1, height: (World.floor * 2))
        l1?.set(center: (World.floor * 2))
        
        XCTAssertEqual(l1?.get(corner: c0), (World.floor + 2))
        XCTAssertEqual(l1?.get(corner: c1), (World.floor + 2))
        XCTAssertEqual(l1?.centre, (World.floor + 2))
        
        l1?.set(corner: c0, height: (World.ceiling * 2))
        l1?.set(corner: c1, height: (World.ceiling * 2))
        l1?.set(center: (World.ceiling * 2))
        
        XCTAssertEqual(l1?.get(corner: c0), (World.floor + 3))
        XCTAssertEqual(l1?.get(corner: c1), (World.floor + 3))
        XCTAssertEqual(l1?.centre, (World.floor + 3))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerPolygons() {
        
        let expect = expectation(description: "Corner heights for layers are set to the height of the lower node +1 when created")
        
        let edge = GridEdge.north
        
        let l0 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        let l1 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        let l2 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        
        XCTAssertEqual(l0?.polyhedron.upperPolytope.vertices[0].y, Axis.Y(y: World.floor + 1))
        XCTAssertEqual(l0?.polyhedron.upperPolytope.vertices[1].y, Axis.Y(y: World.floor + 1))
        XCTAssertEqual(l0?.polyhedron.upperPolytope.vertices[2].y, Axis.Y(y: World.floor + 1))
        XCTAssertEqual(l0?.polyhedron.upperPolytope.vertices[3].y, Axis.Y(y: World.floor + 1))
        
        XCTAssertEqual(l0?.polyhedron.lowerPolytope.vertices[0].y, Axis.Y(y: World.floor))
        XCTAssertEqual(l0?.polyhedron.lowerPolytope.vertices[1].y, Axis.Y(y: World.floor))
        XCTAssertEqual(l0?.polyhedron.lowerPolytope.vertices[2].y, Axis.Y(y: World.floor))
        XCTAssertEqual(l0?.polyhedron.lowerPolytope.vertices[3].y, Axis.Y(y: World.floor))
        
        XCTAssertEqual(l1?.polyhedron.upperPolytope.vertices[0].y, Axis.Y(y: World.floor + 2))
        XCTAssertEqual(l1?.polyhedron.upperPolytope.vertices[1].y, Axis.Y(y: World.floor + 2))
        XCTAssertEqual(l1?.polyhedron.upperPolytope.vertices[2].y, Axis.Y(y: World.floor + 2))
        XCTAssertEqual(l1?.polyhedron.upperPolytope.vertices[3].y, Axis.Y(y: World.floor + 2))
        
        XCTAssertEqual(l1?.polyhedron.lowerPolytope.vertices[0].y, Axis.Y(y: World.floor + 1))
        XCTAssertEqual(l1?.polyhedron.lowerPolytope.vertices[1].y, Axis.Y(y: World.floor + 1))
        XCTAssertEqual(l1?.polyhedron.lowerPolytope.vertices[2].y, Axis.Y(y: World.floor + 1))
        XCTAssertEqual(l1?.polyhedron.lowerPolytope.vertices[3].y, Axis.Y(y: World.floor + 1))
        
        XCTAssertEqual(l2?.polyhedron.upperPolytope.vertices[0].y, Axis.Y(y: World.floor + 3))
        XCTAssertEqual(l2?.polyhedron.upperPolytope.vertices[1].y, Axis.Y(y: World.floor + 3))
        XCTAssertEqual(l2?.polyhedron.upperPolytope.vertices[2].y, Axis.Y(y: World.floor + 3))
        XCTAssertEqual(l2?.polyhedron.upperPolytope.vertices[3].y, Axis.Y(y: World.floor + 3))
        
        XCTAssertEqual(l2?.polyhedron.lowerPolytope.vertices[0].y, Axis.Y(y: World.floor + 2))
        XCTAssertEqual(l2?.polyhedron.lowerPolytope.vertices[1].y, Axis.Y(y: World.floor + 2))
        XCTAssertEqual(l2?.polyhedron.lowerPolytope.vertices[2].y, Axis.Y(y: World.floor + 2))
        XCTAssertEqual(l2?.polyhedron.lowerPolytope.vertices[3].y, Axis.Y(y: World.floor + 2))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerHierarchyAddition() {
        
        let expect = expectation(description: "Layers can be added to a grid node and are stacked correctly")
        
        let edge = GridEdge.north
        
        let l0 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        let l1 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        let l2 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        
        XCTAssertNil(l0?.lower)
        XCTAssertEqual(l0?.upper, l1)
        XCTAssertEqual(l1?.lower, l0)
        XCTAssertEqual(l1?.upper, l2)
        XCTAssertEqual(l2?.lower, l1)
        XCTAssertNil(l2?.upper)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerHierarchyRemoval() {
        
        let expect = expectation(description: "Layers can be removed from a grid node and are re-stacked correctly")
        
        let edge = GridEdge.north
        
        let l0 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        let l1 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        let l2 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        
        scene.world.terrain.remove(layer: l1!)
        
        XCTAssertNil(l0?.lower)
        XCTAssertEqual(l0?.upper, l2)
        XCTAssertEqual(l2?.lower, l0)
        XCTAssertNil(l2?.upper)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
