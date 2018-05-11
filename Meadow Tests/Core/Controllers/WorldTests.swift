//
//  WorldTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 29/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

class WorldTests: XCTestCase {

    func testWorldUnitY() {
        
        let expect = expectation(description: "Converting from integer y value to World coordinates yeilds correct y value as a float")
        
        XCTAssertEqual(World.Y(y: 0), 0.0)
        XCTAssertEqual(World.Y(y: 1), 0.25)
        XCTAssertEqual(World.Y(y: -1), -0.25)
        XCTAssertEqual(World.Y(y: 5), 1.25)
        XCTAssertEqual(World.Y(y: -5), -1.25)
        XCTAssertEqual(World.Y(y: 10), 2.5)
        XCTAssertEqual(World.Y(y: -10), -2.5)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
