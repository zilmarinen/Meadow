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
    
    func testTerrainLayerAddition() {
        
        let expect = expectation(description: "Terrain layers can be added to a grid if the volume they define is not already occupied")
        
        let edge = GridEdge.north
        
        let l0 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        let l1 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        
        let (c0, c1) = GridCorner.corners(edge: edge)
        
        l1?.set(corner: c0, height: World.ceiling)
        l1?.set(corner: c1, height: World.ceiling)
        l1?.set(center: World.ceiling)
        
        XCTAssertEqual(l1?.get(corner: c0), World.ceiling)
        XCTAssertEqual(l1?.get(corner: c1), World.ceiling)
        XCTAssertEqual(l1?.centre, World.ceiling)
        
        let l2 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: .north, terrainType: TerrainType.bedrock)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNil(l2)
        XCTAssertNil(l0?.lower)
        XCTAssertEqual(l0?.upper, l1)
        XCTAssertEqual(l1?.lower, l0)
        XCTAssertNil(l1?.upper)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerEquality() {
        
        let expect = expectation(description: "Terrain layers are considered equal when all x, y and z components, edges and corner heights are equal")
        
        let edge = GridEdge.north
        
        let l0 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        let l1 = scene.world.terrain.add(layer: Coordinate(x: 13, y: 0, z: 37), edge: edge, terrainType: TerrainType.bedrock)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertEqual(l0, l0)
        XCTAssertNotEqual(l0, l1)
        
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
