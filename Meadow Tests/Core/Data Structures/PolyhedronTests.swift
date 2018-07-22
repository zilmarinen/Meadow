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
        
        let p0 = Polytope(x: 0.0, y: Axis.Y(y: 4), z: 0.0)!
        let p1 = Polytope(x: 0.0, y: Axis.Y(y: 2), z: 0.0)!
        let p2 = Polytope(x: 0.0, y: Axis.Y(y: 0), z: 0.0)!
        let p3 = Polytope(x: 0.0, y: Axis.Y(y: -1), z: 0.0)!
        let p4 = Polytope(x: 0.0, y: Axis.Y(y: -3), z: 0.0)!
        
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
        
        let p0 = Polytope(x: 0.0, y: Axis.Y(y: 4), z: 0.0)!
        let p1 = Polytope(x: 0.0, y: Axis.Y(y: 2), z: 0.0)!
        let p2 = Polytope(x: 0.0, y: Axis.Y(y: 1), z: 0.0)!
        let p3 = Polytope(x: 0.0, y: Axis.Y(y: 0), z: 0.0)!
        let p4 = Polytope(x: 0.0, y: Axis.Y(y: -1), z: 0.0)!
        let p5 = Polytope(x: 0.0, y: Axis.Y(y: -3), z: 0.0)!
        
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
        
        let p0 = Polytope(x: 0, corners: [5, 4, 4, 5], z: 0)!
        let p1 = Polytope(x: 0, corners: [1, 2, 2, 1], z: 0)!
        let p2 = Polytope(x: 0, corners: [5, 5, 5, 5], z: 0)!
        let p3 = Polytope(x: 0, corners: [4, 4, 4, 4], z: 0)!
        let p4 = Polytope(x: 0, corners: [2, 2, 2, 2], z: 0)!
        let p5 = Polytope(x: 0, corners: [1, 1, 1, 1], z: 0)!
        let p6 = Polytope(x: 0, corners: [3, 3, 3, 3], z: 0)!
        let p7 = Polytope(x: 0, corners: [2, 2, 2, 2], z: 0)!
        let p8 = Polytope(x: 0, corners: [7, 7, 7, 7], z: 0)!
        let p9 = Polytope(x: 0, corners: [6, 6, 6, 6], z: 0)!
        let p10 = Polytope(x: 0, corners: [-1, -1, -1, -1], z: 0)!
        let p11 = Polytope(x: 0, corners: [-2, -2, -2, -2], z: 0)!
        let p12 = Polytope(x: 0, corners: [3, 3, 3, 3], z: 0)!
        let p13 = Polytope(x: 0, corners: [1, 2, 2, 1], z: 0)!
        
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
        
        let p0 = Polytope(x: 0, corners: [5, 4, 4, 5], z: 0)!
        let p1 = Polytope(x: 0, corners: [0, 1, 1, 0], z: 0)!
        let p2 = Polytope(x: 0, corners: [4, 4, 4, 4], z: 0)!
        let p3 = Polytope(x: 0, corners: [3, 3, 3, 3], z: 0)!
        let p4 = Polytope(x: 0, corners: [2, 2, 2, 2], z: 0)!
        let p5 = Polytope(x: 0, corners: [1, 1, 1, 1], z: 0)!
        
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
    
    func testPolyhedronStencil() {
        
        let expect = expectation(description: "Subtracting inverted Polyhedrons from each other along a specified edge results in an array of the remaining volumes")
        
        let p0 = Polytope(x: 0, corners: [-10, -10, -10, -10], z: 0)!
        let p1 = Polytope(x: 0, corners: [-6, -6, -6, -6], z: 0)!
        
        let p2 = Polytope(x: MDWFloat(Coordinate.Forward.x), corners: [-10, -10, -10, -10], z: MDWFloat(Coordinate.Forward.z))!
        let p3 = Polytope(x: MDWFloat(Coordinate.Forward.x), corners: [-7, -8, -8, -7], z: MDWFloat(Coordinate.Forward.z))!
        
        let p4 = Polytope(x: MDWFloat(Coordinate.Right.x), corners: [-7, -7, -7, -7], z: MDWFloat(Coordinate.Right.x))!
        let p5 = Polytope(x: MDWFloat(Coordinate.Right.x), corners: [-6, -6, -6, -6], z: MDWFloat(Coordinate.Right.x))!
        
        let p6 = Polytope(x: MDWFloat(Coordinate.Right.x), corners: [-10, -10, -10, -10], z: MDWFloat(Coordinate.Right.x))!
        let p7 = Polytope(x: MDWFloat(Coordinate.Right.x), corners: [-9, -9, -9, -9], z: MDWFloat(Coordinate.Right.x))!
        
        let p8 = Polytope(x: MDWFloat(Coordinate.Backward.x), corners: [-10, -10, -10, -10], z: MDWFloat(Coordinate.Backward.x))!
        let p9 = Polytope(x: MDWFloat(Coordinate.Backward.x), corners: [-6, -7, -8, -7], z: MDWFloat(Coordinate.Backward.x))!
        
        let p10 = Polytope(x: MDWFloat(Coordinate.Left.x), corners: [-9, -9, -9, -9], z: MDWFloat(Coordinate.Left.x))!
        let p11 = Polytope(x: MDWFloat(Coordinate.Left.x), corners: [-6, -6, -7, -7], z: MDWFloat(Coordinate.Left.x))!
        
        let reference = Polyhedron(upperPolytope: p1, lowerPolytope: p0)
        
        let northPolyhedron = Polyhedron(upperPolytope: p3, lowerPolytope: p2)
        
        let eastPolyhedronLower = Polyhedron(upperPolytope: p7, lowerPolytope: p6)
        let eastPolyhedronUpper = Polyhedron(upperPolytope: p5, lowerPolytope: p4)
        
        let southPolyhedron = Polyhedron(upperPolytope: p9, lowerPolytope: p8)
        
        let westPolyhedron = Polyhedron(upperPolytope: p11, lowerPolytope: p10)
        
        let northInverted = Polyhedron.Stencil(polyhedrons: [northPolyhedron], against: reference, edge: .north)
        let eastInverted = Polyhedron.Stencil(polyhedrons: [eastPolyhedronLower, eastPolyhedronUpper], against: reference, edge: .east)
        let southInverted = Polyhedron.Stencil(polyhedrons: [southPolyhedron], against: reference, edge: .south)
        let westInverted = Polyhedron.Stencil(polyhedrons: [westPolyhedron], against: reference, edge: .west)
        
        XCTAssertNotNil(northInverted)
        XCTAssertEqual(northInverted.count, 1)
        XCTAssertEqual(northInverted.first!.upperPolytope.vertices[0].y, Axis.Y(y: -6))
        XCTAssertEqual(northInverted.first!.upperPolytope.vertices[1].y, Axis.Y(y: -6))
        XCTAssertEqual(northInverted.first!.upperPolytope.vertices[2].y, Axis.Y(y: -6))
        XCTAssertEqual(northInverted.first!.upperPolytope.vertices[3].y, Axis.Y(y: -6))
        XCTAssertEqual(northInverted.first!.lowerPolytope.vertices[0].y, Axis.Y(y: -7))
        XCTAssertEqual(northInverted.first!.lowerPolytope.vertices[1].y, Axis.Y(y: -8))
        XCTAssertEqual(northInverted.first!.lowerPolytope.vertices[2].y, Axis.Y(y: -8))
        XCTAssertEqual(northInverted.first!.lowerPolytope.vertices[3].y, Axis.Y(y: -7))
        
        XCTAssertNotNil(eastInverted)
        XCTAssertEqual(eastInverted.count, 1)
        XCTAssertEqual(eastInverted.first!.upperPolytope.vertices[0].y, Axis.Y(y: -7))
        XCTAssertEqual(eastInverted.first!.upperPolytope.vertices[1].y, Axis.Y(y: -7))
        XCTAssertEqual(eastInverted.first!.upperPolytope.vertices[2].y, Axis.Y(y: -7))
        XCTAssertEqual(eastInverted.first!.upperPolytope.vertices[3].y, Axis.Y(y: -7))
        XCTAssertEqual(eastInverted.first!.lowerPolytope.vertices[0].y, Axis.Y(y: -9))
        XCTAssertEqual(eastInverted.first!.lowerPolytope.vertices[1].y, Axis.Y(y: -9))
        XCTAssertEqual(eastInverted.first!.lowerPolytope.vertices[2].y, Axis.Y(y: -9))
        XCTAssertEqual(eastInverted.first!.lowerPolytope.vertices[3].y, Axis.Y(y: -9))
        
        XCTAssertNotNil(southInverted)
        XCTAssertEqual(southInverted.count, 1)
        XCTAssertEqual(southInverted.first!.upperPolytope.vertices[0].y, Axis.Y(y: -6))
        XCTAssertEqual(southInverted.first!.upperPolytope.vertices[1].y, Axis.Y(y: -6))
        XCTAssertEqual(southInverted.first!.upperPolytope.vertices[2].y, Axis.Y(y: -6))
        XCTAssertEqual(southInverted.first!.upperPolytope.vertices[3].y, Axis.Y(y: -6))
        XCTAssertEqual(southInverted.first!.lowerPolytope.vertices[0].y, Axis.Y(y: -7))
        XCTAssertEqual(southInverted.first!.lowerPolytope.vertices[1].y, Axis.Y(y: -8))
        XCTAssertEqual(southInverted.first!.lowerPolytope.vertices[2].y, Axis.Y(y: -7))
        XCTAssertEqual(southInverted.first!.lowerPolytope.vertices[3].y, Axis.Y(y: -6))
        
        XCTAssertNotNil(westInverted)
        XCTAssertEqual(westInverted.count, 2)
        XCTAssertEqual(westInverted.first!.upperPolytope.vertices[0].y, Axis.Y(y: -6))
        XCTAssertEqual(westInverted.first!.upperPolytope.vertices[1].y, Axis.Y(y: -6))
        XCTAssertEqual(westInverted.first!.upperPolytope.vertices[2].y, Axis.Y(y: -6))
        XCTAssertEqual(westInverted.first!.upperPolytope.vertices[3].y, Axis.Y(y: -6))
        XCTAssertEqual(westInverted.first!.lowerPolytope.vertices[0].y, Axis.Y(y: -6))
        XCTAssertEqual(westInverted.first!.lowerPolytope.vertices[1].y, Axis.Y(y: -6))
        XCTAssertEqual(westInverted.first!.lowerPolytope.vertices[2].y, Axis.Y(y: -7))
        XCTAssertEqual(westInverted.first!.lowerPolytope.vertices[3].y, Axis.Y(y: -7))
        XCTAssertEqual(westInverted.last!.upperPolytope.vertices[0].y, Axis.Y(y: -9))
        XCTAssertEqual(westInverted.last!.upperPolytope.vertices[1].y, Axis.Y(y: -9))
        XCTAssertEqual(westInverted.last!.upperPolytope.vertices[2].y, Axis.Y(y: -9))
        XCTAssertEqual(westInverted.last!.upperPolytope.vertices[3].y, Axis.Y(y: -9))
        XCTAssertEqual(westInverted.last!.lowerPolytope.vertices[0].y, Axis.Y(y: -10))
        XCTAssertEqual(westInverted.last!.lowerPolytope.vertices[1].y, Axis.Y(y: -10))
        XCTAssertEqual(westInverted.last!.lowerPolytope.vertices[2].y, Axis.Y(y: -10))
        XCTAssertEqual(westInverted.last!.lowerPolytope.vertices[3].y, Axis.Y(y: -10))
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
