//
//  TilesetTests.swift
//
//  Created by Zack Brown on 17/11/2020.
//

import XCTest
@testable import Meadow

final class TilesetTests: XCTestCase {
    
    func testTilemaps() throws {
        
        let tilemap = try Tilemaps()
        
        XCTAssertNotNil(tilemap)
    }

    static var allTests = [
        ("testTilemaps", testTilemaps)
    ]
}
