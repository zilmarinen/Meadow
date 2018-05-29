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
public struct ColorPalette: Codable {
    
    /*!
     @property primary
     @abstract The primary Color of the ColorPalette.
     */
    public let primary: Color
    
    /*!
     @property secondary
     @abstract The secondary Color of the ColorPalette.
     */
    public let secondary: Color
    
    /*!
     @property tertiary
     @abstract The tertiary Color of the ColorPalette.
     */
    public let tertiary: Color
    
    /*!
     @property quaternary
     @abstract The quaternary Color of the ColorPalette.
     */
    public let quaternary: Color
}
