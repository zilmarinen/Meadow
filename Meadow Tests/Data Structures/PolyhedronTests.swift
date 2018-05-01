//
//  PolyhedronTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest
@testable import Meadow

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
}
