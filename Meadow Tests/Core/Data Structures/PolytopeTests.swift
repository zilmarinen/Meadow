//
//  PolytopeTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest
import SceneKit

extension Polytope {
    
    public init(x: MDWFloat, y: Int, z: MDWFloat) {
        
        self.init(x: x, y0: y, y1: y, y2: y, y3: y, z: z)
    }
}

class PolytopeTests: XCTestCase {
    
    func testPolytopeVertices() {
        
        let expect = expectation(description: "Polytope vertices are correctly calculated using world unit length")
        
        let reference = Polytope(x: 10, y: 10, z: 10)
        
        XCTAssertEqual(reference.vertices[0].x, (10.0 + Axis.halfUnitXZ))
        XCTAssertEqual(reference.vertices[0].y, Axis.Y(y: 10))
        XCTAssertEqual(reference.vertices[0].z, (10.0 + Axis.halfUnitXZ))
        
        XCTAssertEqual(reference.vertices[1].x, (10.0 + -Axis.halfUnitXZ))
        XCTAssertEqual(reference.vertices[1].y, Axis.Y(y: 10))
        XCTAssertEqual(reference.vertices[1].z, (10.0 + Axis.halfUnitXZ))
        
        XCTAssertEqual(reference.vertices[2].x, (10.0 + -Axis.halfUnitXZ))
        XCTAssertEqual(reference.vertices[2].y, Axis.Y(y: 10))
        XCTAssertEqual(reference.vertices[2].z, (10.0 + -Axis.halfUnitXZ))
        
        XCTAssertEqual(reference.vertices[3].x, (10.0 + Axis.halfUnitXZ))
        XCTAssertEqual(reference.vertices[3].y, Axis.Y(y: 10))
        XCTAssertEqual(reference.vertices[3].z, (10.0 + -Axis.halfUnitXZ))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testPolytopeEquality() {
        
        let expect = expectation(description: "Polytopes are considered equal when all x, y and z components are equal")
        
        let unit = Polytope(x: 0.0, y: 0, z: 0.0)
        
        let above = Polytope(x: 0.0, y: 1, z: 0.0)
        
        XCTAssertEqual(unit, unit)
        XCTAssertNotEqual(unit, above)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }

    func testPolytopeElevation() {
        
        let expect = expectation(description: "Elevation of polytope is correctly determined based on y axis vector equality")
        
        let reference = Polytope(x: 0.0, y: 0, z: 0.0)
        
        let above = Polytope(x: 0.0, y: 1, z: 0.0)
        
        let below = Polytope(x: 0.0, y: -1, z: 0.0)
        
        let intersecting0 = Polytope(v0: SCNVector3(x: -0.5, y: 1.0, z: 0.5),
                                     v1: SCNVector3(x: 0.5, y: 1.0, z: 0.5),
                                     v2: SCNVector3(x: 0.5, y: -1.0, z: -0.5),
                                     v3: SCNVector3(x: -0.5, y: -1.0, z: -0.5))
        
        let intersecting1 = Polytope(v0: SCNVector3(x: -0.5, y: 1.0, z: 0.5),
                                     v1: SCNVector3(x: 0.5, y: 1.0, z: 0.5),
                                     v2: SCNVector3(x: 0.5, y: -1.0, z: -0.5),
                                     v3: SCNVector3(x: -0.5, y: -1.0, z: -0.5))
        
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
        
        let reference = Polytope(v0: SCNVector3(x: -0.5, y: 2.0, z: 0.5),
                                 v1: SCNVector3(x: 0.5, y: 1.0, z: 0.5),
                                 v2: SCNVector3(x: 0.5, y: 0.0, z: -0.5),
                                 v3: SCNVector3(x: -0.5, y: -1.0, z: -0.5))
        
        XCTAssertEqual(reference.peak, 2.0)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testPolytopeBaseHeight() {
        
        let expect = expectation(description: "Polytopes peak height is determined by lowest y axis value")
        
        let reference = Polytope(v0: SCNVector3(x: -0.5, y: 2.0, z: 0.5),
                                 v1: SCNVector3(x: 0.5, y: 1.0, z: 0.5),
                                 v2: SCNVector3(x: 0.5, y: 0.0, z: -0.5),
                                 v3: SCNVector3(x: -0.5, y: -1.0, z: -0.5))
        
        XCTAssertEqual(reference.base, -1.0)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testPolytopeInset() {
        
        let expect = expectation(description: "Insetting a Polytope will offset the appropriate vertices along a given GridEdge by the specified translation")
        
        let reference = Polytope(x: 10, y: -10, z: 10)
        
        let t0 = Polytope.inset(polytope: reference, edge: .north, inset: WaterNode.tension)
        let t1 = Polytope.inset(polytope: reference, edge: .west, inset: WaterNode.tension)
        
        XCTAssertEqual(t0.vertices[0].x, (10.0 + Axis.halfUnitXZ))
        XCTAssertEqual(t0.vertices[0].y, Axis.Y(y: -10))
        XCTAssertEqual(t0.vertices[0].z, (10.0 + Axis.halfUnitXZ) - WaterNode.tension, accuracy: WaterNode.tension)
        
        XCTAssertEqual(t0.vertices[1].x, (10.0 + -Axis.halfUnitXZ))
        XCTAssertEqual(t0.vertices[1].y, Axis.Y(y: -10))
        XCTAssertEqual(t0.vertices[1].z, (10.0 + Axis.halfUnitXZ) - WaterNode.tension, accuracy: WaterNode.tension)
        
        XCTAssertEqual(t0.vertices[2].x, (10.0 + -Axis.halfUnitXZ))
        XCTAssertEqual(t0.vertices[2].y, Axis.Y(y: -10))
        XCTAssertEqual(t0.vertices[2].z, (10.0 + -Axis.halfUnitXZ))
        
        XCTAssertEqual(t0.vertices[3].x, (10.0 + Axis.halfUnitXZ))
        XCTAssertEqual(t0.vertices[3].y, Axis.Y(y: -10))
        XCTAssertEqual(t0.vertices[3].z, (10.0 + -Axis.halfUnitXZ))
        
        XCTAssertEqual(t1.vertices[0].x, (10.0 + Axis.halfUnitXZ) - WaterNode.tension, accuracy: WaterNode.tension)
        XCTAssertEqual(t1.vertices[0].y, Axis.Y(y: -10))
        XCTAssertEqual(t1.vertices[0].z, (10.0 + Axis.halfUnitXZ))
        
        XCTAssertEqual(t1.vertices[1].x, (10.0 + -Axis.halfUnitXZ))
        XCTAssertEqual(t1.vertices[1].y, Axis.Y(y: -10))
        XCTAssertEqual(t1.vertices[1].z, (10.0 + Axis.halfUnitXZ))
        
        XCTAssertEqual(t1.vertices[2].x, (10.0 + -Axis.halfUnitXZ))
        XCTAssertEqual(t1.vertices[2].y, Axis.Y(y: -10))
        XCTAssertEqual(t1.vertices[2].z, (10.0 + -Axis.halfUnitXZ))
        
        XCTAssertEqual(t1.vertices[3].x, (10.0 + Axis.halfUnitXZ) - WaterNode.tension, accuracy: WaterNode.tension)
        XCTAssertEqual(t1.vertices[3].y, Axis.Y(y: -10))
        XCTAssertEqual(t1.vertices[3].z, (10.0 + -Axis.halfUnitXZ))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testPolytopeInversion() {
        
        let expect = expectation(description: "Inverting a Polytope will invert the appropriate vertices along a given GridEdge")
        
        let reference = Polytope(x: 10, y: -10, z: 10)
        
        let t0 = Polytope.invert(polytope: reference, edge: .north)
        let t1 = Polytope.invert(polytope: reference, edge: .west)
        
        XCTAssertEqual(t0.vertices[0].x, (10.0 + Axis.halfUnitXZ))
        XCTAssertEqual(t0.vertices[0].y, Axis.Y(y: -10))
        XCTAssertEqual(t0.vertices[0].z, (10.0 + -Axis.halfUnitXZ))
        
        XCTAssertEqual(t0.vertices[1].x, (10.0 + -Axis.halfUnitXZ))
        XCTAssertEqual(t0.vertices[1].y, Axis.Y(y: -10))
        XCTAssertEqual(t0.vertices[1].z, (10.0 + -Axis.halfUnitXZ))
        
        XCTAssertEqual(t0.vertices[2].x, (10.0 + -Axis.halfUnitXZ))
        XCTAssertEqual(t0.vertices[2].y, Axis.Y(y: -10))
        XCTAssertEqual(t0.vertices[2].z, (10.0 + Axis.halfUnitXZ))
        
        XCTAssertEqual(t0.vertices[3].x, (10.0 + Axis.halfUnitXZ))
        XCTAssertEqual(t0.vertices[3].y, Axis.Y(y: -10))
        XCTAssertEqual(t0.vertices[3].z, (10.0 + Axis.halfUnitXZ))
        
        XCTAssertEqual(t1.vertices[0].x, (10.0 + -Axis.halfUnitXZ))
        XCTAssertEqual(t1.vertices[0].y, Axis.Y(y: -10))
        XCTAssertEqual(t1.vertices[0].z, (10.0 + Axis.halfUnitXZ))
        
        XCTAssertEqual(t1.vertices[1].x, (10.0 + Axis.halfUnitXZ))
        XCTAssertEqual(t1.vertices[1].y, Axis.Y(y: -10))
        XCTAssertEqual(t1.vertices[1].z, (10.0 + Axis.halfUnitXZ))
        
        XCTAssertEqual(t1.vertices[2].x, (10.0 + Axis.halfUnitXZ))
        XCTAssertEqual(t1.vertices[2].y, Axis.Y(y: -10))
        XCTAssertEqual(t1.vertices[2].z, (10.0 + -Axis.halfUnitXZ))
        
        XCTAssertEqual(t1.vertices[3].x, (10.0 + -Axis.halfUnitXZ))
        XCTAssertEqual(t1.vertices[3].y, Axis.Y(y: -10))
        XCTAssertEqual(t1.vertices[3].z, (10.0 + -Axis.halfUnitXZ))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
