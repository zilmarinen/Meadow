//
//  TilesetTests.swift
//
//  Created by Zack Brown on 17/11/2020.
//

import XCTest
@testable import Meadow

final class TilesetTests: XCTestCase {
    
    func testSurfaceTileset() throws {
        
        let tileset = try SurfaceTileset(season: .spring)
        
        XCTAssertNotNil(tileset)
    }

    static var allTests = [
        ("testSurfaceTileset", testSurfaceTileset)
    ]
}
