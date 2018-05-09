//
//  TerrainLayerTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 07/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest
@testable import Meadow

class TerrainLayerTests: XCTestCase {

    var meadow: Meadow!
    
    override func setUp() {
        
        super.setUp()
        
        meadow = Meadow()
    }
    
    func testTerrainLayerAddition() {
        
        let expect = expectation(description: "Terrain layers can be added to a grid if the volume they define is not already occupied")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        
        let terrainType = meadow.terrain.find(terrainType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0!.add(layer: terrainType!)
        let l1 = n0!.add(layer: terrainType!)
        
        l1!.set(height: World.Ceiling, corner: .northWest)
        l1!.set(height: World.Ceiling, corner: .northEast)
        l1!.set(height: World.Ceiling, corner: .southEast)
        l1!.set(height: World.Ceiling, corner: .southWest)
        
        let l2 = n0!.add(layer: terrainType!)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNil(l2)
        XCTAssertNil(l0!.hierarchy.lower)
        XCTAssertEqual(l0!.hierarchy.upper, l1)
        XCTAssertEqual(l1!.hierarchy.lower, l0)
        XCTAssertNil(l1!.hierarchy.upper)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerEquality() {
        
        let expect = expectation(description: "Terrain layers are considered equal when all x, y and z components are equal")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        
        let terrainType = meadow.terrain.find(terrainType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0!.add(layer: terrainType!)
        let l1 = n0!.add(layer: terrainType!)
        
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
        
        let terrainType = meadow.terrain.find(terrainType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0!.add(layer: terrainType!)
        let l1 = n0!.add(layer: terrainType!)
        let l2 = n0!.add(layer: terrainType!)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        
        XCTAssertEqual(l0!.get(height: .northWest), (World.Floor + 1))
        XCTAssertEqual(l0!.get(height: .northEast), (World.Floor + 1))
        XCTAssertEqual(l0!.get(height: .southEast), (World.Floor + 1))
        XCTAssertEqual(l0!.get(height: .southWest), (World.Floor + 1))
        
        XCTAssertEqual(l1!.get(height: .northWest), (World.Floor + 2))
        XCTAssertEqual(l1!.get(height: .northEast), (World.Floor + 2))
        XCTAssertEqual(l1!.get(height: .southEast), (World.Floor + 2))
        XCTAssertEqual(l1!.get(height: .southWest), (World.Floor + 2))
        
        XCTAssertEqual(l2!.get(height: .northWest), (World.Floor + 3))
        XCTAssertEqual(l2!.get(height: .northEast), (World.Floor + 3))
        XCTAssertEqual(l2!.get(height: .southEast), (World.Floor + 3))
        XCTAssertEqual(l2!.get(height: .southWest), (World.Floor + 3))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerCornerHeightConstraints() {
        
        let expect = expectation(description: "Corner heights for layers are constrained to the grid")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        
        let terrainType = meadow.terrain.find(terrainType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0!.add(layer: terrainType!)
        
        XCTAssertNotNil(l0)
        
        l0!.set(height: (World.Floor * 2), corner: .northWest)
        l0!.set(height: (World.Floor * 2), corner: .northEast)
        l0!.set(height: (World.Floor * 2), corner: .southEast)
        l0!.set(height: (World.Floor * 2), corner: .southWest)
        
        XCTAssertEqual(l0!.get(height: .northWest), World.Floor)
        XCTAssertEqual(l0!.get(height: .northEast), World.Floor)
        XCTAssertEqual(l0!.get(height: .southEast), World.Floor)
        XCTAssertEqual(l0!.get(height: .southWest), World.Floor)
        
        l0!.set(height: (World.Ceiling * 2), corner: .northWest)
        l0!.set(height: (World.Ceiling * 2), corner: .northEast)
        l0!.set(height: (World.Ceiling * 2), corner: .southEast)
        l0!.set(height: (World.Ceiling * 2), corner: .southWest)
        
        XCTAssertEqual(l0!.get(height: .northWest), World.Ceiling)
        XCTAssertEqual(l0!.get(height: .northEast), World.Ceiling)
        XCTAssertEqual(l0!.get(height: .southEast), World.Ceiling)
        XCTAssertEqual(l0!.get(height: .southWest), World.Ceiling)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerCornerHierarchyHeightConstraints() {
        
        let expect = expectation(description: "Corner heights for layers are constrained by upper and lower nodes")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        
        let terrainType = meadow.terrain.find(terrainType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0!.add(layer: terrainType!)
        let l1 = n0!.add(layer: terrainType!)
        let l2 = n0!.add(layer: terrainType!)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        
        l1!.set(height: (World.Floor * 2), corner: .northWest)
        l1!.set(height: (World.Floor * 2), corner: .northEast)
        l1!.set(height: (World.Floor * 2), corner: .southEast)
        l1!.set(height: (World.Floor * 2), corner: .southWest)
        
        XCTAssertEqual(l1!.get(height: .northWest), (World.Floor + 1))
        XCTAssertEqual(l1!.get(height: .northEast), (World.Floor + 1))
        XCTAssertEqual(l1!.get(height: .southEast), (World.Floor + 1))
        XCTAssertEqual(l1!.get(height: .southWest), (World.Floor + 1))
        
        l1!.set(height: (World.Ceiling * 2), corner: .northWest)
        l1!.set(height: (World.Ceiling * 2), corner: .northEast)
        l1!.set(height: (World.Ceiling * 2), corner: .southEast)
        l1!.set(height: (World.Ceiling * 2), corner: .southWest)
        
        XCTAssertEqual(l1!.get(height: .northWest), (World.Floor + 3))
        XCTAssertEqual(l1!.get(height: .northEast), (World.Floor + 3))
        XCTAssertEqual(l1!.get(height: .southEast), (World.Floor + 3))
        XCTAssertEqual(l1!.get(height: .southWest), (World.Floor + 3))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerPolygons() {
        
        let expect = expectation(description: "Corner heights for layers are set to the height of the lower node +1 when created")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        
        let terrainType = meadow.terrain.find(terrainType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0!.add(layer: terrainType!)
        let l1 = n0!.add(layer: terrainType!)
        let l2 = n0!.add(layer: terrainType!)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        
        XCTAssertEqual(l0!.polyhedron.upperPolytope.vertices[0].x, 12.5)
        XCTAssertEqual(l0!.polyhedron.upperPolytope.vertices[0].y, World.Y(y: World.Floor + 1))
        XCTAssertEqual(l0!.polyhedron.upperPolytope.vertices[0].z, 37.5)
        XCTAssertEqual(l0!.polyhedron.upperPolytope.vertices[1].x, 13.5)
        XCTAssertEqual(l0!.polyhedron.upperPolytope.vertices[1].y, World.Y(y: World.Floor + 1))
        XCTAssertEqual(l0!.polyhedron.upperPolytope.vertices[1].z, 37.5)
        XCTAssertEqual(l0!.polyhedron.upperPolytope.vertices[2].x, 13.5)
        XCTAssertEqual(l0!.polyhedron.upperPolytope.vertices[2].y, World.Y(y: World.Floor + 1))
        XCTAssertEqual(l0!.polyhedron.upperPolytope.vertices[2].z, 36.5)
        XCTAssertEqual(l0!.polyhedron.upperPolytope.vertices[3].x, 12.5)
        XCTAssertEqual(l0!.polyhedron.upperPolytope.vertices[3].y, World.Y(y: World.Floor + 1))
        XCTAssertEqual(l0!.polyhedron.upperPolytope.vertices[3].z, 36.5)
        
        XCTAssertEqual(l0!.polyhedron.lowerPolytope.vertices[0].x, 12.5)
        XCTAssertEqual(l0!.polyhedron.lowerPolytope.vertices[0].y, World.Y(y: World.Floor))
        XCTAssertEqual(l0!.polyhedron.lowerPolytope.vertices[0].z, 37.5)
        XCTAssertEqual(l0!.polyhedron.lowerPolytope.vertices[1].x, 13.5)
        XCTAssertEqual(l0!.polyhedron.lowerPolytope.vertices[1].y, World.Y(y: World.Floor))
        XCTAssertEqual(l0!.polyhedron.lowerPolytope.vertices[1].z, 37.5)
        XCTAssertEqual(l0!.polyhedron.lowerPolytope.vertices[2].x, 13.5)
        XCTAssertEqual(l0!.polyhedron.lowerPolytope.vertices[2].y, World.Y(y: World.Floor))
        XCTAssertEqual(l0!.polyhedron.lowerPolytope.vertices[2].z, 36.5)
        XCTAssertEqual(l0!.polyhedron.lowerPolytope.vertices[3].x, 12.5)
        XCTAssertEqual(l0!.polyhedron.lowerPolytope.vertices[3].y, World.Y(y: World.Floor))
        XCTAssertEqual(l0!.polyhedron.lowerPolytope.vertices[3].z, 36.5)
        
        XCTAssertEqual(l1!.polyhedron.upperPolytope.vertices[0].x, 12.5)
        XCTAssertEqual(l1!.polyhedron.upperPolytope.vertices[0].y, World.Y(y: World.Floor + 2))
        XCTAssertEqual(l1!.polyhedron.upperPolytope.vertices[0].z, 37.5)
        XCTAssertEqual(l1!.polyhedron.upperPolytope.vertices[1].x, 13.5)
        XCTAssertEqual(l1!.polyhedron.upperPolytope.vertices[1].y, World.Y(y: World.Floor + 2))
        XCTAssertEqual(l1!.polyhedron.upperPolytope.vertices[1].z, 37.5)
        XCTAssertEqual(l1!.polyhedron.upperPolytope.vertices[2].x, 13.5)
        XCTAssertEqual(l1!.polyhedron.upperPolytope.vertices[2].y, World.Y(y: World.Floor + 2))
        XCTAssertEqual(l1!.polyhedron.upperPolytope.vertices[2].z, 36.5)
        XCTAssertEqual(l1!.polyhedron.upperPolytope.vertices[3].x, 12.5)
        XCTAssertEqual(l1!.polyhedron.upperPolytope.vertices[3].y, World.Y(y: World.Floor + 2))
        XCTAssertEqual(l1!.polyhedron.upperPolytope.vertices[3].z, 36.5)
        
        XCTAssertEqual(l1!.polyhedron.lowerPolytope.vertices[0].x, 12.5)
        XCTAssertEqual(l1!.polyhedron.lowerPolytope.vertices[0].y, World.Y(y: World.Floor + 1))
        XCTAssertEqual(l1!.polyhedron.lowerPolytope.vertices[0].z, 37.5)
        XCTAssertEqual(l1!.polyhedron.lowerPolytope.vertices[1].x, 13.5)
        XCTAssertEqual(l1!.polyhedron.lowerPolytope.vertices[1].y, World.Y(y: World.Floor + 1))
        XCTAssertEqual(l1!.polyhedron.lowerPolytope.vertices[1].z, 37.5)
        XCTAssertEqual(l1!.polyhedron.lowerPolytope.vertices[2].x, 13.5)
        XCTAssertEqual(l1!.polyhedron.lowerPolytope.vertices[2].y, World.Y(y: World.Floor + 1))
        XCTAssertEqual(l1!.polyhedron.lowerPolytope.vertices[2].z, 36.5)
        XCTAssertEqual(l1!.polyhedron.lowerPolytope.vertices[3].x, 12.5)
        XCTAssertEqual(l1!.polyhedron.lowerPolytope.vertices[3].y, World.Y(y: World.Floor + 1))
        XCTAssertEqual(l1!.polyhedron.lowerPolytope.vertices[3].z, 36.5)
        
        XCTAssertEqual(l2!.polyhedron.upperPolytope.vertices[0].x, 12.5)
        XCTAssertEqual(l2!.polyhedron.upperPolytope.vertices[0].y, World.Y(y: World.Floor + 3))
        XCTAssertEqual(l2!.polyhedron.upperPolytope.vertices[0].z, 37.5)
        XCTAssertEqual(l2!.polyhedron.upperPolytope.vertices[1].x, 13.5)
        XCTAssertEqual(l2!.polyhedron.upperPolytope.vertices[1].y, World.Y(y: World.Floor + 3))
        XCTAssertEqual(l2!.polyhedron.upperPolytope.vertices[1].z, 37.5)
        XCTAssertEqual(l2!.polyhedron.upperPolytope.vertices[2].x, 13.5)
        XCTAssertEqual(l2!.polyhedron.upperPolytope.vertices[2].y, World.Y(y: World.Floor + 3))
        XCTAssertEqual(l2!.polyhedron.upperPolytope.vertices[2].z, 36.5)
        XCTAssertEqual(l2!.polyhedron.upperPolytope.vertices[3].x, 12.5)
        XCTAssertEqual(l2!.polyhedron.upperPolytope.vertices[3].y, World.Y(y: World.Floor + 3))
        XCTAssertEqual(l2!.polyhedron.upperPolytope.vertices[3].z, 36.5)
        
        XCTAssertEqual(l2!.polyhedron.lowerPolytope.vertices[0].x, 12.5)
        XCTAssertEqual(l2!.polyhedron.lowerPolytope.vertices[0].y, World.Y(y: World.Floor + 2))
        XCTAssertEqual(l2!.polyhedron.lowerPolytope.vertices[0].z, 37.5)
        XCTAssertEqual(l2!.polyhedron.lowerPolytope.vertices[1].x, 13.5)
        XCTAssertEqual(l2!.polyhedron.lowerPolytope.vertices[1].y, World.Y(y: World.Floor + 2))
        XCTAssertEqual(l2!.polyhedron.lowerPolytope.vertices[1].z, 37.5)
        XCTAssertEqual(l2!.polyhedron.lowerPolytope.vertices[2].x, 13.5)
        XCTAssertEqual(l2!.polyhedron.lowerPolytope.vertices[2].y, World.Y(y: World.Floor + 2))
        XCTAssertEqual(l2!.polyhedron.lowerPolytope.vertices[2].z, 36.5)
        XCTAssertEqual(l2!.polyhedron.lowerPolytope.vertices[3].x, 12.5)
        XCTAssertEqual(l2!.polyhedron.lowerPolytope.vertices[3].y, World.Y(y: World.Floor + 2))
        XCTAssertEqual(l2!.polyhedron.lowerPolytope.vertices[3].z, 36.5)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerHierarchyAddition() {
        
        let expect = expectation(description: "Layers can be added to a grid node and are stacked correctly")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        
        let terrainType = meadow.terrain.find(terrainType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0!.add(layer: terrainType!)
        let l1 = n0!.add(layer: terrainType!)
        let l2 = n0!.add(layer: terrainType!)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        XCTAssertNil(l0!.hierarchy.lower)
        XCTAssertEqual(l0!.hierarchy.upper, l1)
        XCTAssertEqual(l1!.hierarchy.lower, l0)
        XCTAssertEqual(l1!.hierarchy.upper, l2)
        XCTAssertEqual(l2!.hierarchy.lower, l1)
        XCTAssertNil(l2!.hierarchy.upper)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerHierarchyRemoval() {
        
        let expect = expectation(description: "Layers can be removed from a grid node and are re-stacked correctly")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        
        let terrainType = meadow.terrain.find(terrainType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0!.add(layer: terrainType!)
        let l1 = n0!.add(layer: terrainType!)
        let l2 = n0!.add(layer: terrainType!)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        
        n0!.remove(layer: l1!)
        
        XCTAssertNil(l0!.hierarchy.lower)
        XCTAssertEqual(l0!.hierarchy.upper, l2)
        XCTAssertEqual(l2!.hierarchy.lower, l0)
        XCTAssertNil(l2!.hierarchy.upper)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testTerrainLayerSmoothTerraforming() {
        
        let expect = expectation(description: "Adjacent tiles are correctly updated when the height of a layer is changed")
        
        let n0 = meadow.terrain.add(node: Coordinate(x: 13, y: 0, z: 37))
        let n1 = meadow.terrain.add(node: n0!.volume.coordinate + Coordinate.Forward)
        let n2 = meadow.terrain.add(node: n0!.volume.coordinate + Coordinate.Left)
        let n3 = meadow.terrain.add(node: n0!.volume.coordinate + Coordinate.Forward + Coordinate.Left)
        
        let terrainType = meadow.terrain.find(terrainType: "Bedrock")
        
        XCTAssertNotNil(n0)
        XCTAssertNotNil(n1)
        XCTAssertNotNil(n2)
        XCTAssertNotNil(n3)
        XCTAssertNotNil(terrainType)
        
        let l0 = n0!.add(layer: terrainType!)
        let l1 = n1!.add(layer: terrainType!)
        let l2 = n2!.add(layer: terrainType!)
        let l3 = n3!.add(layer: terrainType!)
        
        XCTAssertNotNil(l0)
        XCTAssertNotNil(l1)
        XCTAssertNotNil(l2)
        XCTAssertNotNil(l3)
    
        l0?.set(height: (World.Floor - 2), corner: .northWest)
        
        XCTAssertEqual(l1!.get(height: .northWest), (World.Floor + 1))
        XCTAssertEqual(l1!.get(height: .northEast), (World.Floor + 1))
        XCTAssertEqual(l1!.get(height: .southEast), (World.Floor + 1))
        XCTAssertEqual(l1!.get(height: .southWest), (World.Floor + 2))
        
        XCTAssertEqual(l2!.get(height: .northWest), (World.Floor + 1))
        XCTAssertEqual(l2!.get(height: .northEast), (World.Floor + 2))
        XCTAssertEqual(l2!.get(height: .southEast), (World.Floor + 1))
        XCTAssertEqual(l2!.get(height: .southWest), (World.Floor + 1))
        
        XCTAssertEqual(l3!.get(height: .northWest), (World.Floor + 1))
        XCTAssertEqual(l3!.get(height: .northEast), (World.Floor + 1))
        XCTAssertEqual(l3!.get(height: .southEast), (World.Floor + 2))
        XCTAssertEqual(l3!.get(height: .southWest), (World.Floor + 1))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
