//
//  TilesetTests.swift
//
//  Created by Zack Brown on 17/11/2020.
//

import XCTest
@testable import Meadow

final class TilesetTests: XCTestCase {
    
    func testSpringTileset() {
        
        let tileset = Season.spring.tileset
        
        XCTAssertNotNil(tileset)
    }
    
    func testSummerTileset() {
        
        let tileset = Season.summer.tileset
        
        XCTAssertNotNil(tileset)
    }
    
    func testAutumnTileset() {
        
        let tileset = Season.autumn.tileset
        
        XCTAssertNotNil(tileset)
    }
    
    func testWinterTileset() {
        
        let tileset = Season.winter.tileset
        
        XCTAssertNotNil(tileset)
    }

    static var allTests = [
        ("testSpringTileset", testSpringTileset),
        ("testSummerTileset", testSummerTileset),
        ("testAutumnTileset", testAutumnTileset),
        ("testWinterTileset", testWinterTileset),
    ]
}
