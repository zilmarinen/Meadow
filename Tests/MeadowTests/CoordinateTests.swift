//
//  CoordinateTests.swift
//
//  Created by Zack Brown on 01/12/2020.
//

import XCTest
@testable import Meadow

final class CoordinateTests: XCTestCase {
    
    let chunkSize = 5
    
    func testCoordinateChunks() throws {
        
        XCTAssertEqual(Coordinate(x: 0, z: 0, size: chunkSize), Coordinate(x: 0, y: 0, z: 0))
        XCTAssertEqual(Coordinate(x: 1, z: 1, size: chunkSize), Coordinate(x: 0, y: 0, z: 0))
        XCTAssertEqual(Coordinate(x: 4, z: 4, size: chunkSize), Coordinate(x: 0, y: 0, z: 0))
        
        XCTAssertEqual(Coordinate(x: 5, z: 5, size: chunkSize), Coordinate(x: 5, y: 0, z: 5))
        XCTAssertEqual(Coordinate(x: 6, z: 6, size: chunkSize), Coordinate(x: 5, y: 0, z: 5))
        XCTAssertEqual(Coordinate(x: 9, z: 9, size: chunkSize), Coordinate(x: 5, y: 0, z: 5))
        
        XCTAssertEqual(Coordinate(x: 10, z: 10, size: chunkSize), Coordinate(x: 10, y: 0, z: 10))
        
        XCTAssertEqual(Coordinate(x: -1, z: -1, size: chunkSize), Coordinate(x: -5, y: 0, z: -5))
        XCTAssertEqual(Coordinate(x: -4, z: -4, size: chunkSize), Coordinate(x: -5, y: 0, z: -5))
        
        XCTAssertEqual(Coordinate(x: -5, z: -5, size: chunkSize), Coordinate(x: -10, y: 0, z: -10))
        XCTAssertEqual(Coordinate(x: -6, z: -6, size: chunkSize), Coordinate(x: -10, y: 0, z: -10))
        XCTAssertEqual(Coordinate(x: -9, z: -9, size: chunkSize), Coordinate(x: -10, y: 0, z: -10))
        
        XCTAssertEqual(Coordinate(x: -10, z: -10, size: chunkSize), Coordinate(x: -15, y: 0, z: -15))
    }

    static var allTests = [
        ("testCoordinateChunks", testCoordinateChunks)
    ]
}
