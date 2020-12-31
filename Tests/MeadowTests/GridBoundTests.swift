//
//  GridBoundTests.swift
//
//  Created by Zack Brown on 01/12/2020.
//

import XCTest
@testable import Meadow

final class GridBoundTests: XCTestCase {
    
    let chunkSize = 5
    
    func testAlignedGridBound() throws {
        
        let b0 = GridBounds(aligned: Coordinate(x: 0, y: 0, z: 0), size: chunkSize)
        let b1 = GridBounds(aligned: Coordinate(x: 2, y: 0, z: 2), size: chunkSize)
        let b2 = GridBounds(aligned: Coordinate(x: 4, y: 0, z: 4), size: chunkSize)
        let b3 = GridBounds(aligned: Coordinate(x: 5, y: 0, z: 5), size: chunkSize)
        
        XCTAssertEqual(b0.start, Coordinate(x: 0, y: 0, z: 0))
        XCTAssertEqual(b0.end, Coordinate(x: 4, y: 0, z: 4))
        
        XCTAssertEqual(b1.start, Coordinate(x: 0, y: 0, z: 0))
        XCTAssertEqual(b1.end, Coordinate(x: 4, y: 0, z: 4))
        
        XCTAssertEqual(b2.start, Coordinate(x: 0, y: 0, z: 0))
        XCTAssertEqual(b2.end, Coordinate(x: 4, y: 0, z: 4))
        
        XCTAssertEqual(b3.start, Coordinate(x: 5, y: 0, z: 5))
        XCTAssertEqual(b3.end, Coordinate(x: 9, y: 0, z: 9))
        
        
        let b4 = GridBounds(aligned: Coordinate(x: -1, y: 0, z: 0), size: chunkSize)
        let b5 = GridBounds(aligned: Coordinate(x: -3, y: 0, z: 2), size: chunkSize)
        let b6 = GridBounds(aligned: Coordinate(x: -5, y: 0, z: 4), size: chunkSize)
        let b7 = GridBounds(aligned: Coordinate(x: -6, y: 0, z: 5), size: chunkSize)
        
        XCTAssertEqual(b4.start, Coordinate(x: -5, y: 0, z: 0))
        XCTAssertEqual(b4.end, Coordinate(x: -1, y: 0, z: 4))
        
        XCTAssertEqual(b5.start, Coordinate(x: -5, y: 0, z: 0))
        XCTAssertEqual(b5.end, Coordinate(x: -1, y: 0, z: 4))
    
        XCTAssertEqual(b6.start, Coordinate(x: -5, y: 0, z: 0))
        XCTAssertEqual(b6.end, Coordinate(x: -1, y: 0, z: 4))
        
        XCTAssertEqual(b7.start, Coordinate(x: -10, y: 0, z: 5))
        XCTAssertEqual(b7.end, Coordinate(x: -6, y: 0, z: 9))
        
        let b8 = GridBounds(aligned: Coordinate(x: -1, y: 0, z: -1), size: chunkSize)
        let b9 = GridBounds(aligned: Coordinate(x: -3, y: 0, z: -3), size: chunkSize)
        let b10 = GridBounds(aligned: Coordinate(x: -5, y: 0, z: -5), size: chunkSize)
        let b11 = GridBounds(aligned: Coordinate(x: -6, y: 0, z: -6), size: chunkSize)
        
        XCTAssertEqual(b8.start, Coordinate(x: -5, y: 0, z: -5))
        XCTAssertEqual(b8.end, Coordinate(x: -1, y: 0, z: -1))
        
        XCTAssertEqual(b9.start, Coordinate(x: -5, y: 0, z: -5))
        XCTAssertEqual(b9.end, Coordinate(x: -1, y: 0, z: -1))
    
        XCTAssertEqual(b10.start, Coordinate(x: -5, y: 0, z: -5))
        XCTAssertEqual(b10.end, Coordinate(x: -1, y: 0, z: -1))
        
        XCTAssertEqual(b11.start, Coordinate(x: -10, y: 0, z: -10))
        XCTAssertEqual(b11.end, Coordinate(x: -6, y: 0, z: -6))
        
        let b12 = GridBounds(aligned: Coordinate(x: 0, y: 0, z: -1), size: chunkSize)
        let b13 = GridBounds(aligned: Coordinate(x: 2, y: 0, z: -3), size: chunkSize)
        let b14 = GridBounds(aligned: Coordinate(x: 4, y: 0, z: -5), size: chunkSize)
        let b15 = GridBounds(aligned: Coordinate(x: 5, y: 0, z: -6), size: chunkSize)
        
        XCTAssertEqual(b12.start, Coordinate(x: 0, y: 0, z: -5))
        XCTAssertEqual(b12.end, Coordinate(x: 4, y: 0, z: -1))
        
        XCTAssertEqual(b13.start, Coordinate(x: 0, y: 0, z: -5))
        XCTAssertEqual(b13.end, Coordinate(x: 4, y: 0, z: -1))
    
        XCTAssertEqual(b14.start, Coordinate(x: 0, y: 0, z: -5))
        XCTAssertEqual(b14.end, Coordinate(x: 4, y: 0, z: -1))
        
        XCTAssertEqual(b15.start, Coordinate(x: 5, y: 0, z: -10))
        XCTAssertEqual(b15.end, Coordinate(x: 9, y: 0, z: -6))
    }

    static var allTests = [
        ("testAlignedGridBound", testAlignedGridBound)
    ]
}
