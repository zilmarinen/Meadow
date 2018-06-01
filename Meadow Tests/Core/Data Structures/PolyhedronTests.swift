//
//  PolyhedronTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest
import SceneKit

class PolyhedronTests: XCTestCase {
    
    func testPolyhedronEquality() {
        
        let expect = expectation(description: "Polygons areconsider equal when both upper and lower polytopes are equal")
        
        let p0 = Polytope(x: 0.0, y: World.Y(y: 4), z: 0.0)
        let p1 = Polytope(x: 0.0, y: World.Y(y: 2), z: 0.0)
        let p2 = Polytope(x: 0.0, y: World.Y(y: 0), z: 0.0)
        let p3 = Polytope(x: 0.0, y: World.Y(y: -1), z: 0.0)
        let p4 = Polytope(x: 0.0, y: World.Y(y: -3), z: 0.0)
        
        let reference = Polyhedron(upperPolytope: p1, lowerPolytope: p2)
        
        let above = Polyhedron(upperPolytope: p0, lowerPolytope: p1)
        
        let below = Polyhedron(upperPolytope: p3, lowerPolytope: p4)
        
        XCTAssertEqual(reference, reference)
        
        XCTAssertNotEqual(reference, above)
        XCTAssertNotEqual(reference, below)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }

    func testPolyhedronElevation() {
        
        let expect = expectation(description: "Elevation of polygon is correctly determined based on polytope elevation")
        
        let p0 = Polytope(x: 0.0, y: World.Y(y: 4), z: 0.0)
        let p1 = Polytope(x: 0.0, y: World.Y(y: 2), z: 0.0)
        let p2 = Polytope(x: 0.0, y: World.Y(y: 1), z: 0.0)
        let p3 = Polytope(x: 0.0, y: World.Y(y: 0), z: 0.0)
        let p4 = Polytope(x: 0.0, y: World.Y(y: -1), z: 0.0)
        let p5 = Polytope(x: 0.0, y: World.Y(y: -3), z: 0.0)
        
        let reference = Polyhedron(upperPolytope: p1, lowerPolytope: p3)
        
        let above = Polyhedron(upperPolytope: p0, lowerPolytope: p1)
        
        let below = Polyhedron(upperPolytope: p4, lowerPolytope: p5)
        
        let intersecting0 = Polyhedron(upperPolytope: p0, lowerPolytope: p3)
        let intersecting1 = Polyhedron(upperPolytope: p2, lowerPolytope: p5)
        let intersecting2 = Polyhedron(upperPolytope: p2, lowerPolytope: p3)
        
        XCTAssertEqual(reference.elevation(referencing: above), .below)
        XCTAssertEqual(reference.elevation(referencing: below), .above)
        
        XCTAssertEqual(reference.elevation(referencing: intersecting0), .intersecting)
        XCTAssertEqual(reference.elevation(referencing: intersecting1), .intersecting)
        XCTAssertEqual(reference.elevation(referencing: intersecting2), .intersecting)
        
        XCTAssertEqual(reference.elevation(referencing: reference), .equal)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testPolyhedronSubtraction() {
        
        let expect = expectation(description: "Subtracting Polyhedrons from each other results in an array of the remaining volumes")
        
        let unit = Polytope.Unit
        
        let v0 = unit.vertices[0]
        let v1 = unit.vertices[1]
        let v2 = unit.vertices[2]
        let v3 = unit.vertices[3]
        
        let p0 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 5), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 4), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 4), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 5), z: v3.z)])
        let p1 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 1), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 2), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 2), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 1), z: v3.z)])
        
        let p2 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 5), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 5), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 5), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 5), z: v3.z)])
        let p3 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 4), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 4), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 4), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 4), z: v3.z)])
        
        let p4 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 2), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 2), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 2), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 2), z: v3.z)])
        let p5 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 1), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 1), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 1), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 1), z: v3.z)])
        
        let p6 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 3), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 3), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 3), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 3), z: v3.z)])
        let p7 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 2), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 2), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 2), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 2), z: v3.z)])
        
        let p8 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 7), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 7), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 7), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 7), z: v3.z)])
        let p9 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 6), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 6), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 6), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 6), z: v3.z)])
        
        let p10 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: -1), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: -1), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: -1), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: -1), z: v3.z)])
        let p11 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: -2), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: -2), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: -2), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: -2), z: v3.z)])
        
        let p12 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 3), z: v0.z),
                                      SCNVector3(x: v1.x, y: World.Y(y: 3), z: v1.z),
                                      SCNVector3(x: v2.x, y: World.Y(y: 3), z: v2.z),
                                      SCNVector3(x: v3.x, y: World.Y(y: 3), z: v3.z)])
        let p13 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 1), z: v0.z),
                                      SCNVector3(x: v1.x, y: World.Y(y: 2), z: v1.z),
                                      SCNVector3(x: v2.x, y: World.Y(y: 2), z: v2.z),
                                      SCNVector3(x: v3.x, y: World.Y(y: 1), z: v3.z)])
        
        let reference = Polyhedron(upperPolytope: p0, lowerPolytope: p1)
        
        let upper = Polyhedron(upperPolytope: p2, lowerPolytope: p3)
        
        let lower = Polyhedron(upperPolytope: p4, lowerPolytope: p5)
        
        let intersecting0 = Polyhedron(upperPolytope: p6, lowerPolytope: p7)
        let intersecting1 = Polyhedron(upperPolytope: p12, lowerPolytope: p13)
        
        let above = Polyhedron(upperPolytope: p8, lowerPolytope: p9)
        
        let below = Polyhedron(upperPolytope: p10, lowerPolytope: p11)
        
        let r0 = Polyhedron.Subtract(polyhedron: upper, from: reference)
        
        XCTAssertNotNil(r0)
        XCTAssertEqual(r0?.count, 1)
        XCTAssertEqual(r0?.first?.upperPolytope, upper.lowerPolytope)
        XCTAssertEqual(r0?.first?.lowerPolytope, reference.lowerPolytope)
        
        let r1 = Polyhedron.Subtract(polyhedron: lower, from: reference)
        
        XCTAssertNotNil(r1)
        XCTAssertEqual(r1?.count, 1)
        XCTAssertEqual(r1?.first?.upperPolytope, reference.upperPolytope)
        XCTAssertEqual(r1?.first?.lowerPolytope, lower.upperPolytope)
        
        let r2 = Polyhedron.Subtract(polyhedron: intersecting0, from: reference)
        
        XCTAssertNotNil(r2)
        XCTAssertEqual(r2?.count, 2)
        XCTAssertEqual(r2?[0].upperPolytope, reference.upperPolytope)
        XCTAssertEqual(r2?[0].lowerPolytope, intersecting0.upperPolytope)
        XCTAssertEqual(r2?[1].upperPolytope, intersecting0.lowerPolytope)
        XCTAssertEqual(r2?[1].lowerPolytope, reference.lowerPolytope)
        
        let r3 = Polyhedron.Subtract(polyhedron: intersecting1, from: reference)
        
        XCTAssertNotNil(r3)
        XCTAssertEqual(r3?.count, 1)
        XCTAssertEqual(r3?.first?.upperPolytope, reference.upperPolytope)
        XCTAssertEqual(r3?.first?.lowerPolytope, intersecting1.upperPolytope)
        
        let r4 = Polyhedron.Subtract(polyhedron: above, from: reference)
        
        XCTAssertNil(r4)
        
        let r5 = Polyhedron.Subtract(polyhedron: below, from: reference)
        
        XCTAssertNil(r5)
        
        let r6 = Polyhedron.Subtract(polyhedron: reference, from: reference)
        
        XCTAssertNil(r6)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
    
    func testPolyhedronSubdivision() {
        
        let expect = expectation(description: "Subtracting Polyhedrons from each other results in an array of the remaining volumes")
        
        let unit = Polytope.Unit
        
        let v0 = unit.vertices[0]
        let v1 = unit.vertices[1]
        let v2 = unit.vertices[2]
        let v3 = unit.vertices[3]
        
        let p0 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 5), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 4), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 4), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 5), z: v3.z)])
        let p1 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 0), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 1), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 1), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 0), z: v3.z)])
        
        let p2 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 4), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 4), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 4), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 4), z: v3.z)])
        let p3 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 3), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 3), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 3), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 3), z: v3.z)])
        
        let p4 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 2), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 2), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 2), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 2), z: v3.z)])
        let p5 = Polytope(vertices: [SCNVector3(x: v0.x, y: World.Y(y: 1), z: v0.z),
                                     SCNVector3(x: v1.x, y: World.Y(y: 1), z: v1.z),
                                     SCNVector3(x: v2.x, y: World.Y(y: 1), z: v2.z),
                                     SCNVector3(x: v3.x, y: World.Y(y: 1), z: v3.z)])
        
        let reference = Polyhedron(upperPolytope: p0, lowerPolytope: p1)
        
        let upper = Polyhedron(upperPolytope: p2, lowerPolytope: p3)
        
        let lower = Polyhedron(upperPolytope: p4, lowerPolytope: p5)
        
        let result = Polyhedron.Subtract(polyhedrons: [upper, lower], from: reference)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0].upperPolytope, reference.upperPolytope)
        XCTAssertEqual(result[0].lowerPolytope, upper.upperPolytope)
        XCTAssertEqual(result[1].upperPolytope, upper.lowerPolytope)
        XCTAssertEqual(result[1].lowerPolytope, lower.upperPolytope)
        XCTAssertEqual(result[2].upperPolytope, lower.lowerPolytope)
        XCTAssertEqual(result[2].lowerPolytope, reference.lowerPolytope)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
