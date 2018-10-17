//
//  ColorPaletteTests.swift
//  MeadowTests
//
//  Created by Zack Brown on 27/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import XCTest

class ColorPaletteTests: XCTestCase {
    
    func testColorPalettesAreLoaded() {
        
        let expect = expectation(description: "Colors and Color Palettes are loaded and can be found")
        
        let knownColorPalette = ColorPalettes.shared?.palette(named: "Grass")
        let unknownColorPalette = ColorPalettes.shared!.palette(named: "unknown")
        
        XCTAssertNotNil(knownColorPalette)
        XCTAssertNil(unknownColorPalette)
        
        expect.fulfill()
        
        waitForExpectations(timeout: 1)
    }
}
