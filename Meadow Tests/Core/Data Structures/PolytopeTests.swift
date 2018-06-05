//
//  PolytopeTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest
import SceneKit

class PolytopeTests: XCTestCase {
    
    func testPolytopeVertices() {
        
        let expect = expectation(description: "Polytope vertices are correctly calculated using world unit length")
        
        let reference = Polytope(x: 10, y: 10, z: 10)
        
        XCTAssertEqual(reference.vertices[0].x, (10.0 + -World.UnitXZ))
        XCTAssertEqual(reference.vertices[0].y, 10.0)
        XCTAssertEqual(reference.vertices[0].z, (10.0 + -World.UnitXZ))
        
        XCTAssertEqual(reference.vertices[1].x, (10.0 + World.UnitXZ))
        XCTAssertEqual(reference.vertices[1].y, 10.0)
        XCTAssertEqual(reference.vertices[1].z, (10.0 + -World.UnitXZ))
        
        XCTAssertEqual(reference.vertices[2].x, (10.0 + World.UnitXZ))
        XCTAssertEqual(reference.vertices[2].y, 10.0)
        XCTAssertEqual(reference.vertices[2].z, (10.0 + World.UnitXZ))
        
        XCTAssertEqual(reference.vertices[3].x, (10.0 + -World.UnitXZ))
        XCTAssertEqual(reference.vertices[3].y, 10.0)
        XCTAssertEqual(reference.vertices[3].z, (10.0 + World.UnitXZ))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testPolytopeEquality() {
        
        let expect = expectation(description: "Polytopes are considered equal when all x, y and z components are equal")
        
        let unit = Polytope(x: 0.0, y: 0.0, z: 0.0)
        
        let above = Polytope(x: 0.0, y: World.UnitY, z: 0.0)
        
        XCTAssertEqual(unit, unit)
        XCTAssertNotEqual(unit, above)
        
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
    
    func testPolytopePeakHeight() {
        
        let expect = expectation(description: "Polytopes peak height is determined by greatest y axis value")
        
        let reference = Polytope(vertices: [SCNVector3(x: -0.5, y: 2.0, z: 0.5),
                                            SCNVector3(x: 0.5, y: 1.0, z: 0.5),
                                            SCNVector3(x: 0.5, y: 0.0, z: -0.5),
                                            SCNVector3(x: -0.5, y: -1.0, z: -0.5)])
        
        XCTAssertEqual(reference.peak, 2.0)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testPolytopeBaseHeight() {
        
        let expect = expectation(description: "Polytopes peak height is determined by lowest y axis value")
        
        let reference = Polytope(vertices: [SCNVector3(x: -0.5, y: 2.0, z: 0.5),
                                            SCNVector3(x: 0.5, y: 1.0, z: 0.5),
                                            SCNVector3(x: 0.5, y: 0.0, z: -0.5),
                                            SCNVector3(x: -0.5, y: -1.0, z: -0.5)])
        
        XCTAssertEqual(reference.base, -1.0)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
