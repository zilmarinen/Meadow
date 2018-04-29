//
//  PolytopeTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest
import SceneKit
@testable import Meadow

class PolytopeTests: XCTestCase {
    
    func testPolytopeEquality() {
        
        let expect = expectation(description: "Polytopes are considered equal when all x, y and z components are equal")
        
        let reference = Polytope.Unit
        
        let above = Polytope(x: 0.0, y: World.UnitY, z: 0.0)
        
        XCTAssertEqual(reference, reference)
        XCTAssertNotEqual(reference, above)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }

    func testPolytopeElevation() {
        
        let expect = expectation(description: "Elevation of polytope is correctly determined based on y axis vector equality")
        
        let reference = Polytope(x: 0.0, y: 0.0, z: 0.0)
        
        let above = Polytope(x: 0.0, y: World.UnitY, z: 0.0)
        
        let below = Polytope(x: 0.0, y: -World.UnitY, z: 0.0)
        
        let intersecting0 = Polytope(vertices: [SCNVector3(x: -0.5, y: 1.0, z: 0.5),
                                                SCNVector3(x: 0.5, y: 1.0, z: 0.5),
                                                SCNVector3(x: 0.5, y: -1.0, z: -0.5),
                                                SCNVector3(x: -0.5, y: -1.0, z: -0.5)])
        
        let intersecting1 = Polytope(vertices: [SCNVector3(x: -0.5, y: 1.0, z: 0.5),
                                                SCNVector3(x: 0.5, y: 1.0, z: 0.5),
                                                SCNVector3(x: 0.5, y: -1.0, z: -0.5),
                                                SCNVector3(x: -0.5, y: -1.0, z: -0.5)])
        
        XCTAssertEqual(reference.elevation(referencing: above), .below)
        XCTAssertEqual(reference.elevation(referencing: below), .above)
        
        XCTAssertEqual(reference.elevation(referencing: intersecting0), .intersecting)
        XCTAssertEqual(reference.elevation(referencing: intersecting1), .intersecting)
        
        XCTAssertEqual(reference.elevation(referencing: reference), .equal)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
