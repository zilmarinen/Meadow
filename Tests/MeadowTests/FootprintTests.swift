//
//  FootprintTests.swift
//
//  Created by Zack Brown on 09/12/2020.
//

import XCTest
@testable import Meadow

final class FootprintTests: XCTestCase {
    
    func testFootprintIntersection() throws {
        
        let nodes = [FootprintNode(coordinate: Coordinate(x: 0, y: 0, z: 0), cardinals: [.north : false,
                                                                                         .east : false,
                                                                                         .south :false,
                                                                                         .west : false]),
                     FootprintNode(coordinate: Cardinal.north.coordinate, cardinals: [.east : false,
                                                                                      .south : false,
                                                                                      .west: false]),
                     FootprintNode(coordinate: Cardinal.east.coordinate, cardinals: [.west : false])]
        
        let f0 = Footprint(coordinate: .zero, rotation: .north, nodes: nodes)
        let f1 = Footprint(coordinate: Cardinal.east.coordinate, rotation: .north, nodes: nodes)
        let f2 = Footprint(coordinate: Cardinal.east.coordinate, rotation: .west, nodes: nodes)
        let f3 = Footprint(coordinate: Cardinal.north.coordinate + Cardinal.north.coordinate, rotation: .east, nodes: nodes)
        
        XCTAssertTrue(f0.intersects(footprint: f1))
        XCTAssertTrue(f0.intersects(footprint: f2))
        XCTAssertFalse(f0.intersects(footprint: f3))
    }

    static var allTests = [
        ("testFootprintIntersection", testFootprintIntersection)
    ]
}
