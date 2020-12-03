//
//  TerrainTests.swift
//
//  Created by Zack Brown on 01/12/2020.
//

import XCTest
@testable import Meadow

final class TerrainTests: XCTestCase {
    
    var scene: Scene!
    
    override func setUp() {
        
        super.setUp()
        
        scene = Scene()
        
        let coordinates = [Coordinate(x: -1, y: 0, z: -1),
                           Coordinate(x: 0, y: 0, z: -1),
                           Coordinate(x: 1, y: 0, z: -1),
                           
                           Coordinate(x: -1, y: 0, z: 0),
                           Coordinate(x: 0, y: 0, z: 0),
                           Coordinate(x: 1, y: 0, z: 0),
                           
                           Coordinate(x: -1, y: 0, z: 1),
                           Coordinate(x: 0, y: 0, z: 1),
                           Coordinate(x: 1, y: 0, z: 1)]
        
        for coordinate in coordinates {
            
            let _ = scene.meadow.terrain.add(tile: coordinate)
        }
    }
    
    func testCardinalNeighbours() throws {
        
        let tile = scene.meadow.terrain.find(tile: .zero)
        
        let north = tile?.find(neighbour: .north)
        let east = tile?.find(neighbour: .east)
        let south = tile?.find(neighbour: .south)
        let west = tile?.find(neighbour: .west)
        
        XCTAssertEqual(tile?.neighbours.count, 4)
        
        XCTAssertNotNil(tile)
        XCTAssertNotNil(north)
        XCTAssertNotNil(east)
        XCTAssertNotNil(south)
        XCTAssertNotNil(west)
        
        XCTAssertEqual(north?.coordinate, Coordinate(x: 0, y: 0, z: 1))
        XCTAssertEqual(east?.coordinate, Coordinate(x: -1, y: 0, z: 0))
        XCTAssertEqual(south?.coordinate, Coordinate(x: 0, y: 0, z: -1))
        XCTAssertEqual(west?.coordinate, Coordinate(x: 1, y: 0, z: 0))
    }
    
    func testOrdinalNeighbours() throws {
        
        let tile = scene.meadow.terrain.find(tile: .zero)
        
        let northWest = tile?.find(neighbour: .northWest)
        let northEast = tile?.find(neighbour: .northEast)
        let southEast = tile?.find(neighbour: .southEast)
        let southWest = tile?.find(neighbour: .southWest)
        
        XCTAssertEqual(tile?.neighbours.count, 4)
        
        XCTAssertNotNil(tile)
        XCTAssertNotNil(northWest)
        XCTAssertNotNil(northEast)
        XCTAssertNotNil(southEast)
        XCTAssertNotNil(southWest)
        
        XCTAssertEqual(northWest?.coordinate, Coordinate(x: 1, y: 0, z: 1))
        XCTAssertEqual(northEast?.coordinate, Coordinate(x: -1, y: 0, z: 1))
        XCTAssertEqual(southEast?.coordinate, Coordinate(x: -1, y: 0, z: -1))
        XCTAssertEqual(southWest?.coordinate, Coordinate(x: 1, y: 0, z: -1))
    }

    static var allTests = [
        ("testCardinalNeighbours", testCardinalNeighbours),
        ("testOrdinalNeighbours", testOrdinalNeighbours)
    ]
}
