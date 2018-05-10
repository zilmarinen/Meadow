//
//  ColorPalette.swift
//  Meadow
//
//  Created by Zack Brown on 09/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @struct ColorPalette
 @abstract Defines a ColorPalette with four Colors.
 */
public struct ColorPalette: Decodable {
    
    let primary: Color
    let secondary: Color
    let tertiary: Color
    let quaternary: Color
}
