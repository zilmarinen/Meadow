//
//  GridPatternTests.swift
//
//  Created by Zack Brown on 20/09/2021.
//

import XCTest
@testable import Meadow

final class GridPatternTests: XCTestCase {
    
    func testPatternFromId() throws {
        
        let p0 = GridPattern<Bool>(id: 0)
        let p1 = GridPattern<Bool>(id: 15)
        let p2 = GridPattern<Bool>(id: 255)
        
        XCTAssertFalse(p0.north)
        XCTAssertFalse(p0.east)
        XCTAssertFalse(p0.south)
        XCTAssertFalse(p0.west)
        XCTAssertFalse(p0.northWest)
        XCTAssertFalse(p0.northEast)
        XCTAssertFalse(p0.southEast)
        XCTAssertFalse(p0.southWest)
        
        XCTAssertTrue(p1.north)
        XCTAssertTrue(p1.east)
        XCTAssertTrue(p1.south)
        XCTAssertTrue(p1.west)
        XCTAssertFalse(p1.northWest)
        XCTAssertFalse(p1.northEast)
        XCTAssertFalse(p1.southEast)
        XCTAssertFalse(p1.southWest)
        
        XCTAssertTrue(p2.north)
        XCTAssertTrue(p2.east)
        XCTAssertTrue(p2.south)
        XCTAssertTrue(p2.west)
        XCTAssertTrue(p2.northWest)
        XCTAssertTrue(p2.northEast)
        XCTAssertTrue(p2.southEast)
        XCTAssertTrue(p2.southWest)
    }
    
    func testIdOfGridPattern() {
        
        let p0 = GridPattern<Bool>(north: false, east: false, south: false, west: false, northWest: false, northEast: false, southEast: false, southWest: false)
        let p1 = GridPattern<Bool>(north: true, east: true, south: true, west: true, northWest: false, northEast: false, southEast: false, southWest: false)
        let p2 = GridPattern<Bool>(north: true, east: true, south: true, west: true, northWest: true, northEast: true, southEast: true, southWest: true)
        let p3 = GridPattern<Bool>(north: true, east: true, south: false, west: false, northWest: false, northEast: true, southEast: false, southWest: false)
        
        XCTAssertEqual(p0.id, 0)
        XCTAssertEqual(p1.id, 15)
        XCTAssertEqual(p2.id, 255)
    }

    static var allTests = [
        ("testPatternFromId", testPatternFromId),
        ("testIdOfGridPattern", testIdOfGridPattern)
    ]
}
