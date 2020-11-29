//
//  TilesetTests.swift
//
//  Created by Zack Brown on 17/11/2020.
//

import XCTest
@testable import Meadow

final class TilesetTests: XCTestCase {
    
    func testSpringTilemap() throws {
        
        let tilemap = try TerrainTilemap(season: .spring)
        
        XCTAssertNotNil(tilemap)
    }
    
    func testSummerTilemap() throws {
        
        let tilemap = try TerrainTilemap(season: .summer)
        
        XCTAssertNotNil(tilemap)
    }
    
    func testAutumnTilemap() throws {
        
        let tilemap = try TerrainTilemap(season: .autumn)
        
        XCTAssertNotNil(tilemap)
    }
    
    func testWinterTilemap() throws {
        
        let tilemap = try TerrainTilemap(season: .winter)
        
        XCTAssertNotNil(tilemap)
    }

    static var allTests = [
        ("testSpringTilemap", testSpringTilemap),
        ("testSummerTilemap", testSummerTilemap),
        ("testAutumnTilemap", testAutumnTilemap),
        ("testWinterTilemap", testWinterTilemap),
    ]
}
