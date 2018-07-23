//
//  TerrainLayerTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 07/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

class TerrainLayerTests: XCTestCase {

    var meadow: Meadow!
    
    override func setUp() {
        
        super.setUp()
        
        meadow = Meadow()
    }
    
    func testTerrainLayerAddition() {
        
        let expect = expectation(description: "Terrain layers can be added to a grid if the volume they define is not already occupied")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        
        let terrainType = meadow.terrain.find(nodeType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0?.add(layer: terrainType!)
        let l1 = n0?.add(layer: terrainType!)
        
        l1?.set(height: World.ceiling, corner: .northWest)
        l1?.set(height: World.ceiling, corner: .northEast)
        l1?.set(height: World.ceiling, corner: .southEast)
        l1?.set(height: World.ceiling, corner: .southWest)
        
        XCTAssertEqual(l1?.get(height: .northWest), World.ceiling)
        XCTAssertEqual(l1?.get(height: .northEast), World.ceiling)
        XCTAssertEqual(l1?.get(height: .southEast), World.ceiling)
        XCTAssertEqual(l1?.get(height: .southWest), World.ceiling)
        
        let l2 = n0?.add(layer: terrainType!)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNil(l2)
        XCTAssertNil(l0?.hierarchy.lower)
        XCTAssertEqual(l0?.hierarchy.upper, l1)
        XCTAssertEqual(l1?.hierarchy.lower, l0)
        XCTAssertNil(l1?.hierarchy.upper)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerEquality() {
        
        let expect = expectation(description: "Terrain layers are considered equal when all x, y and z components are equal")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        
        let terrainType = meadow.terrain.find(nodeType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0?.add(layer: terrainType!)
        let l1 = n0?.add(layer: terrainType!)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertEqual(l0, l0)
        XCTAssertNotEqual(l0, l1)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerCornerHeights() {
        
        let expect = expectation(description: "Corner heights for layers are set to the height of the lower node +1 when created")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        
        let terrainType = meadow.terrain.find(nodeType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0?.add(layer: terrainType!)
        let l1 = n0?.add(layer: terrainType!)
        let l2 = n0?.add(layer: terrainType!)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        
        XCTAssertEqual(l0?.get(height: .northWest), (World.floor + 1))
        XCTAssertEqual(l0?.get(height: .northEast), (World.floor + 1))
        XCTAssertEqual(l0?.get(height: .southEast), (World.floor + 1))
        XCTAssertEqual(l0?.get(height: .southWest), (World.floor + 1))
        
        XCTAssertEqual(l1?.get(height: .northWest), (World.floor + 2))
        XCTAssertEqual(l1?.get(height: .northEast), (World.floor + 2))
        XCTAssertEqual(l1?.get(height: .southEast), (World.floor + 2))
        XCTAssertEqual(l1?.get(height: .southWest), (World.floor + 2))
        
        XCTAssertEqual(l2?.get(height: .northWest), (World.floor + 3))
        XCTAssertEqual(l2?.get(height: .northEast), (World.floor + 3))
        XCTAssertEqual(l2?.get(height: .southEast), (World.floor + 3))
        XCTAssertEqual(l2?.get(height: .southWest), (World.floor + 3))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerCornerHeightConstraints() {
        
        let expect = expectation(description: "Corner heights for layers are constrained to the grid")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        
        let terrainType = meadow.terrain.find(nodeType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0?.add(layer: terrainType!)
        
        XCTAssertNotNil(l0)
        
        l0?.set(height: (World.floor * 2), corner: .northWest)
        l0?.set(height: (World.floor * 2), corner: .northEast)
        l0?.set(height: (World.floor * 2), corner: .southEast)
        l0?.set(height: (World.floor * 2), corner: .southWest)
        
        XCTAssertEqual(l0?.get(height: .northWest), (World.floor + 1))
        XCTAssertEqual(l0?.get(height: .northEast), (World.floor + 1))
        XCTAssertEqual(l0?.get(height: .southEast), (World.floor + 1))
        XCTAssertEqual(l0?.get(height: .southWest), (World.floor + 1))
        
        l0?.set(height: (World.ceiling * 2), corner: .northWest)
        l0?.set(height: (World.ceiling * 2), corner: .northEast)
        l0?.set(height: (World.ceiling * 2), corner: .southEast)
        l0?.set(height: (World.ceiling * 2), corner: .southWest)
        
        XCTAssertEqual(l0?.get(height: .northWest), World.ceiling)
        XCTAssertEqual(l0?.get(height: .northEast), World.ceiling)
        XCTAssertEqual(l0?.get(height: .southEast), World.ceiling)
        XCTAssertEqual(l0?.get(height: .southWest), World.ceiling)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerCornerHierarchyHeightConstraints() {
        
        let expect = expectation(description: "Corner heights for layers are constrained by upper and lower nodes")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        
        let terrainType = meadow.terrain.find(nodeType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0?.add(layer: terrainType!)
        let l1 = n0?.add(layer: terrainType!)
        let l2 = n0?.add(layer: terrainType!)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        
        l1?.set(height: (World.floor * 2), corner: .northWest)
        l1?.set(height: (World.floor * 2), corner: .northEast)
        l1?.set(height: (World.floor * 2), corner: .southEast)
        l1?.set(height: (World.floor * 2), corner: .southWest)
        
        XCTAssertEqual(l1?.get(height: .northWest), (World.floor + 1))
        XCTAssertEqual(l1?.get(height: .northEast), (World.floor + 1))
        XCTAssertEqual(l1?.get(height: .southEast), (World.floor + 1))
        XCTAssertEqual(l1?.get(height: .southWest), (World.floor + 1))
        
        l1?.set(height: (World.ceiling * 2), corner: .northWest)
        l1?.set(height: (World.ceiling * 2), corner: .northEast)
        l1?.set(height: (World.ceiling * 2), corner: .southEast)
        l1?.set(height: (World.ceiling * 2), corner: .southWest)
        
        XCTAssertEqual(l1?.get(height: .northWest), (World.floor + 3))
        XCTAssertEqual(l1?.get(height: .northEast), (World.floor + 3))
        XCTAssertEqual(l1?.get(height: .southEast), (World.floor + 3))
        XCTAssertEqual(l1?.get(height: .southWest), (World.floor + 3))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerPolygons() {
        
        let expect = expectation(description: "Corner heights for layers are set to the height of the lower node +1 when created")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        
        let terrainType = meadow.terrain.find(nodeType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0?.add(layer: terrainType!)
        let l1 = n0?.add(layer: terrainType!)
        let l2 = n0?.add(layer: terrainType!)
        
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
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        
        let terrainType = meadow.terrain.find(nodeType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0?.add(layer: terrainType!)
        let l1 = n0?.add(layer: terrainType!)
        let l2 = n0?.add(layer: terrainType!)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        XCTAssertNil(l0?.hierarchy.lower)
        XCTAssertEqual(l0?.hierarchy.upper, l1)
        XCTAssertEqual(l1?.hierarchy.lower, l0)
        XCTAssertEqual(l1?.hierarchy.upper, l2)
        XCTAssertEqual(l2?.hierarchy.lower, l1)
        XCTAssertNil(l2?.hierarchy.upper)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerHierarchyRemoval() {
        
        let expect = expectation(description: "Layers can be removed from a grid node and are re-stacked correctly")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        
        let terrainType = meadow.terrain.find(nodeType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0?.add(layer: terrainType!)
        let l1 = n0?.add(layer: terrainType!)
        let l2 = n0?.add(layer: terrainType!)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        
        let _ = n0?.remove(layer: l1!)
        
        XCTAssertNil(l0?.hierarchy.lower)
        XCTAssertEqual(l0?.hierarchy.upper, l2)
        XCTAssertEqual(l2?.hierarchy.lower, l0)
        XCTAssertNil(l2?.hierarchy.upper)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
